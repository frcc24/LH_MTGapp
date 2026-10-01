import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/glyphs.dart';
import '../../../core/theme/theme_x.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/models.dart';
import '../domain/reducer.dart';
import 'counter_chip.dart';
import 'delta_badge.dart';
import 'life_number.dart';
import 'turn_timer_bar.dart';

/// Aba da gaveta que um toque no chip deve abrir.
enum DrawerTab { counters, commander, history }

/// Painel de um jogador. Desenhado sempre "em pé"; quem o gira é o `RotatedBox` do layout.
class PlayerPanel extends StatefulWidget {
  const PlayerPanel({
    super.key,
    required this.player,
    required this.state,
    required this.game,
    required this.onLife,
    required this.onOpenDrawer,
    this.radius = AppRadius.panelLarge,
    this.isActive = false,
    this.turnLabel,
    this.onTurnBadgeTap,
    this.timerFraction,
    this.timerSeconds,
    this.onRevive,
    this.onExactLife,
    this.safeInsets = EdgeInsets.zero,
    this.compact = false,
    this.showChips = true,
  });

  final PlayerConfig player;
  final PlayerState state;
  final GameState game;
  final ValueChanged<int> onLife;
  final ValueChanged<DrawerTab> onOpenDrawer;
  final double radius;
  final bool isActive;

  /// Texto do selo ("TURNO · 0:58"); null esconde.
  final String? turnLabel;
  final VoidCallback? onTurnBadgeTap;
  final double? timerFraction;
  final int? timerSeconds;
  final VoidCallback? onRevive;
  final VoidCallback? onExactLife;

  /// Áreas ocupadas por notch/ilha/home indicator, no referencial do painel.
  final EdgeInsets safeInsets;
  final bool compact;

  /// false no modo solo: os contadores ficam numa linha própria fora do painel.
  final bool showChips;

  @override
  State<PlayerPanel> createState() => _PlayerPanelState();
}

class _PlayerPanelState extends State<PlayerPanel> with SingleTickerProviderStateMixin {
  late final AnimationController _fx = AnimationController(vsync: this, duration: AppMotion.gainWave);
  Offset _lastTouch = Offset.zero;
  int _fxKind = 0; // 1 ganho, -1 perda
  int _acc = 0;
  Timer? _accTimer;

  // segurar
  Timer? _holdTimer;
  int _holdSign = 0;
  int _holdReps = 0;
  final Stopwatch _holdWatch = Stopwatch();

  // arrastar
  double _dragDy = 0;
  int _dragPreview = 0;

  Size _size = Size.zero;

  @override
  void didUpdateWidget(PlayerPanel old) {
    super.didUpdateWidget(old);
    final diff = widget.state.life - old.state.life;
    if (diff != 0) {
      _acc += diff;
      _accTimer?.cancel();
      _accTimer = Timer(AppMotion.deltaHold, () {
        if (mounted) setState(() => _acc = 0);
      });
      _fxKind = diff > 0 ? 1 : -1;
      if (!context.reduceMotion) _fx.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _accTimer?.cancel();
    _holdTimer?.cancel();
    _fx.dispose();
    super.dispose();
  }

  // ── gestos ───────────────────────────────────────────────────────────────

  int _signAt(Offset local) => local.dx >= _size.width / 2 ? 1 : -1;

  void _onTapUp(TapUpDetails d) {
    _lastTouch = d.localPosition;
    widget.onLife(_signAt(d.localPosition));
  }

  void _onLongPressStart(LongPressStartDetails d) {
    _lastTouch = d.localPosition;
    final center = (d.localPosition.dx - _size.width / 2).abs() < _size.width * 0.12;
    if (center && widget.onExactLife != null) {
      widget.onExactLife!();
      return;
    }
    _holdSign = _signAt(d.localPosition);
    _holdReps = 0;
    _holdWatch
      ..reset()
      ..start();
    _holdStep();
  }

  void _holdStep() {
    final big = _holdWatch.elapsed >= const Duration(milliseconds: 2500);
    widget.onLife(_holdSign * (big ? 5 : 1));
    _holdReps++;
    _holdTimer = Timer(_holdReps < 10 ? AppMotion.holdRepeatSlow : AppMotion.holdRepeatFast, _holdStep);
  }

  void _stopHold() {
    _holdTimer?.cancel();
    _holdTimer = null;
    _holdWatch.stop();
    _holdSign = 0;
  }

  static int _dragSteps(double dy) {
    final a = dy.abs();
    final steps = a >= 100 ? 10 : (a >= 40 ? 5 : 0);
    return dy < 0 ? steps : -steps; // para cima = ganhar
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _dragDy += d.delta.dy;
    final p = _dragSteps(_dragDy);
    if (p != _dragPreview) setState(() => _dragPreview = p);
  }

  void _onDragEnd() {
    final apply = _dragPreview;
    _dragDy = 0;
    if (_dragPreview != 0) setState(() => _dragPreview = 0);
    if (apply != 0) widget.onLife(apply);
  }

  // ── construção ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final p = widget.player;
    final s = widget.state;
    final color = p.color;
    final eliminated = s.eliminated;
    final cb = context.lh.colorBlind;

    return LayoutBuilder(
      builder: (context, box) {
        _size = box.biggest;
        final insets = widget.safeInsets;
        final usableH = math.max(0.0, box.maxHeight - insets.vertical - 110);
        final usableW = math.max(0.0, box.maxWidth - insets.horizontal - 112);
        final digits = s.life.toString().length;
        final fontSize = LifeNumber.sizeFor(usableH, usableW, digits);
        final shown = s.life + (_dragPreview != 0 ? _dragPreview : 0);
        final delta = _dragPreview != 0 ? _dragPreview : _acc;

        final decoration = BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          border: cb && color.colorBlindDash != BorderDash.solid
              ? null
              : Border.all(color: eliminated ? color.color.withValues(alpha: 0.4) : color.color, width: 2),
          gradient: RadialGradient(colors: [color.tint, AppColors.panel], stops: const [0, 0.72]),
          boxShadow: widget.isActive ? AppShadow.panelActive(color.color) : AppShadow.panelIdle(color.color),
        );

        final content = Stack(
          fit: StackFit.expand,
          children: [
            // fundo: onda de ganho
            if (_fxKind != 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _fx,
                    builder: (_, _) => CustomPaint(
                      painter: _WavePainter(
                        _fx.value,
                        _lastTouch == Offset.zero ? box.biggest.center(Offset.zero) : _lastTouch,
                        color.color,
                        _fxKind > 0,
                      ),
                    ),
                  ),
                ),
              ),
            // toques ±1, segurar e arrastar
            Positioned.fill(child: _gestureLayer(l, p.name)),
            // glifos − e +
            Positioned.fill(
              child: IgnorePointer(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(insets.left + 20, 0, insets.right + 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FaIcon(FontAwesomeIcons.minus, size: 24, color: AppColors.iconIdle),
                      FaIcon(FontAwesomeIcons.plus, size: 24, color: AppColors.iconIdle),
                    ],
                  ),
                ),
              ),
            ),
            // conteúdo central
            Padding(
              padding: EdgeInsets.fromLTRB(insets.left, insets.top, insets.right, insets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  IgnorePointer(
                    child: SizedBox(
                      height: widget.compact ? 30 : 36,
                      child: Center(
                        child: DeltaBadge(delta: delta, fontSize: widget.compact ? 28 : 34, preview: _dragPreview != 0),
                      ),
                    ),
                  ),
                  if (widget.turnLabel != null && !eliminated) _turnBadge(),
                  IgnorePointer(
                    child: Opacity(
                      opacity: eliminated ? 0.45 : 1,
                      child: LifeNumber(value: shown, color: color.color, fontSize: fontSize, dim: eliminated),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _chipsRow(l, eliminated),
                  const Spacer(),
                ],
              ),
            ),
            // barra do timer
            if (widget.isActive && widget.timerFraction != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: TurnTimerBar(fraction: widget.timerFraction!, remainingSeconds: widget.timerSeconds ?? 99),
              ),
          ],
        );

        final scale = _fxKind < 0 && !context.reduceMotion
            ? 1 -
                  0.015 *
                      math.sin(
                        math.pi *
                            (_fx.value * AppMotion.gainWave.inMilliseconds / AppMotion.lossPulse.inMilliseconds).clamp(
                              0.0,
                              1.0,
                            ),
                      )
            : 1.0;

        return Semantics(
          container: true,
          label: l.semLifeOf(p.name, s.life),
          customSemanticsActions: {
            CustomSemanticsAction(label: l.semGainLife(p.name)): () => widget.onLife(1),
            CustomSemanticsAction(label: l.semLoseLife(p.name)): () => widget.onLife(-1),
            CustomSemanticsAction(label: l.semGainFive(p.name)): () => widget.onLife(5),
            CustomSemanticsAction(label: l.semLoseFive(p.name)): () => widget.onLife(-5),
            CustomSemanticsAction(label: l.semOpenDrawer(p.name)): () => widget.onOpenDrawer(DrawerTab.counters),
          },
          child: AnimatedBuilder(
            animation: _fx,
            builder: (context, child) => Transform.scale(
              scale: scale,
              child: CustomPaint(
                foregroundPainter: cb ? _DashPainter(color.color, color.colorBlindDash, widget.radius) : null,
                child: DecoratedBox(
                  decoration: decoration.copyWith(
                    border: _fxKind < 0 && _fx.isAnimating && !(cb && color.colorBlindDash != BorderDash.solid)
                        ? Border.all(
                            color: Color.lerp(AppColors.loss, color.color, (_fx.value * 1.9).clamp(0.0, 1.0))!,
                            width: 2,
                          )
                        : decoration.border,
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(widget.radius), child: child),
                ),
              ),
            ),
            child: content,
          ),
        );
      },
    );
  }

  Widget _gestureLayer(AppL10n l, String name) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (r) => r.onTapUp = _onTapUp,
        ),
        LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
          () => LongPressGestureRecognizer(duration: AppMotion.holdRepeatDelay),
          (r) => r
            ..onLongPressStart = _onLongPressStart
            ..onLongPressEnd = ((_) => _stopHold())
            ..onLongPressCancel = _stopHold,
        ),
        VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
          (r) => r
            ..onStart = ((_) => _dragDy = 0)
            ..onUpdate = _onDragUpdate
            ..onEnd = ((_) => _onDragEnd())
            ..onCancel = _onDragEnd,
        ),
      },
      child: const SizedBox.expand(),
    );
  }

  Widget _turnBadge() {
    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
      ),
      child: Text(widget.turnLabel!, style: AppType.badge.copyWith(color: AppColors.onAccent, fontSize: 12)),
    );
    if (widget.onTurnBadgeTap == null) return IgnorePointer(child: badge);
    return Semantics(
      button: true,
      label: AppL10n.of(context).semPassTurn,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTurnBadgeTap,
        child: Padding(padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14), child: badge),
      ),
    );
  }

  Widget _chipsRow(AppL10n l, bool eliminated) {
    final s = widget.state;
    final cfg = widget.game.config;
    final p = widget.player;

    if (eliminated) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPress: widget.onRevive,
        child: Semantics(
          button: true,
          label: '${l.eliminatedBadge}. ${l.reviveAction}',
          onLongPress: widget.onRevive,
          excludeSemantics: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.cmdAlertBg,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                l.eliminatedBadge,
                style: AppType.overline.copyWith(color: AppColors.cmdAlertFg.withValues(alpha: 0.75), fontSize: 12),
              ),
            ),
          ),
        ),
      );
    }

    if (!widget.showChips) return const SizedBox(height: 14);

    final chips = <Widget>[
      // nome + glifo: abre a gaveta
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => widget.onOpenDrawer(DrawerTab.counters),
        child: Semantics(
          button: true,
          label: l.semOpenDrawer(p.name),
          excludeSemantics: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Container(
              height: AppSize.chipH + 4,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: AppColors.elevated, borderRadius: BorderRadius.circular(AppRadius.pill)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(p.color.glyph.icon, size: 14, color: p.color.color),
                  const SizedBox(width: 8),
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppType.label.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ];

    for (final t in const [CounterType.poison, CounterType.energy, CounterType.experience, CounterType.radiation]) {
      if (!cfg.has(t)) continue;
      final v = s.counter(t);
      var alert = ChipAlert.none;
      if (t == CounterType.poison) {
        if (v >= cfg.poisonLimit) {
          alert = ChipAlert.lethal;
        } else if (v >= poisonWarn) {
          alert = ChipAlert.warn;
        }
      }
      chips.add(
        CounterChip(
          icon: t.icon,
          value: '$v',
          color: t.color,
          alert: alert,
          lethalLabel: l.lethalBadge,
          onTap: () => widget.onOpenDrawer(DrawerTab.counters),
        ),
      );
    }

    if (cfg.has(CounterType.commander) && s.maxCmdDamage > 0) {
      final m = s.maxCmdDamage;
      chips.add(
        CounterChip(
          icon: CounterType.commander.icon,
          value: '${l.cmdShort} $m/$cmdDamageLethal',
          color: AppColors.commander,
          alert: m >= cmdDamageLethal ? ChipAlert.lethal : (m >= cmdDamageWarn ? ChipAlert.warn : ChipAlert.none),
          alertBg: AppColors.cmdAlertBg,
          alertFg: AppColors.cmdAlertFg,
          onTap: () => widget.onOpenDrawer(DrawerTab.commander),
        ),
      );
    }

    if (widget.game.monarchId == p.id) {
      chips.add(const _StatusChip(icon: FontAwesomeIcons.crown, active: true));
    }
    if (widget.game.initiativeId == p.id) {
      chips.add(const _StatusChip(icon: FontAwesomeIcons.dungeon, active: true));
    }
    if (cfg.has(CounterType.ring) && s.ring > 0) {
      chips.add(_StatusChip(icon: FontAwesomeIcons.ring, text: '${s.ring}/4'));
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 0,
      children: chips,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, this.text, this.active = false});
  final FaIconData icon;
  final String? text;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Container(
        height: AppSize.chipH,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.accent : AppColors.elevated,
          borderRadius: BorderRadius.circular(AppRadius.chip),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(icon, size: 13, color: active ? AppColors.onAccent : AppColors.accentSoftFg),
            if (text != null) ...[const SizedBox(width: 6), Text(text!, style: AppType.counter.copyWith(fontSize: 16))],
          ],
        ),
      ),
    );
  }
}

/// Onda de ganho: círculo na cor do jogador (20%) que cresce a partir do toque.
class _WavePainter extends CustomPainter {
  _WavePainter(this.t, this.origin, this.color, this.gain);
  final double t;
  final Offset origin;
  final Color color;
  final bool gain;

  @override
  void paint(Canvas canvas, Size size) {
    if (!gain || t <= 0 || t >= 1) return;
    final maxR = math.sqrt(size.width * size.width + size.height * size.height);
    final eased = Curves.easeOutCubic.transform(t);
    final paint = Paint()..color = color.withValues(alpha: 0.20 * (1 - t));
    canvas.drawCircle(origin, maxR * eased, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.t != t || old.origin != origin || old.color != color;
}

/// Traço próprio por jogador (modo daltônico): tracejado, pontilhado ou duplo.
class _DashPainter extends CustomPainter {
  _DashPainter(this.color, this.dash, this.radius);
  final Color color;
  final BorderDash dash;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (dash == BorderDash.solid) return;
    final rrect = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    if (dash == BorderDash.double) {
      canvas.drawRRect(rrect.deflate(1), paint..strokeWidth = 1.5);
      canvas.drawRRect(rrect.deflate(5), paint);
      return;
    }
    final on = dash == BorderDash.dashed ? 12.0 : 2.0;
    final off = dash == BorderDash.dashed ? 7.0 : 6.0;
    if (dash == BorderDash.dotted) paint.strokeCap = StrokeCap.round;
    final path = Path()..addRRect(rrect.deflate(1));
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + on, m.length)), paint);
        d += on + off;
      }
    }
  }

  @override
  bool shouldRepaint(_DashPainter old) => old.color != color || old.dash != dash || old.radius != radius;
}
