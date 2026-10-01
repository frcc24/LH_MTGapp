import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/glyphs.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lh_stepper.dart';
import '../domain/actions.dart';
import '../domain/formats.dart';
import '../domain/game_controller.dart';
import '../domain/models.dart';
import '../layout/match_layout.dart';
import '../widgets/delta_badge.dart';
import '../widgets/life_number.dart';
import '../widgets/player_panel.dart' show DrawerTab;

/// Folha que sobe do lado do jogador e cobre a metade da tela dele. A vida compacta fica sempre visível.
class PlayerDrawerOverlay extends ConsumerStatefulWidget {
  const PlayerDrawerOverlay({
    super.key,
    required this.playerId,
    required this.initialTab,
    required this.seat,
    required this.screen,
    required this.safePadding,
    required this.onClose,
    required this.onCheckWinner,
  });

  final String playerId;
  final DrawerTab initialTab;
  final Seat seat;
  final Size screen;

  /// Padding de segurança da tela (notch, home indicator), sem rotação.
  final Insets safePadding;
  final VoidCallback onClose;
  final VoidCallback onCheckWinner;

  @override
  ConsumerState<PlayerDrawerOverlay> createState() => _PlayerDrawerOverlayState();
}

class _PlayerDrawerOverlayState extends ConsumerState<PlayerDrawerOverlay> {
  late DrawerTab _tab = widget.initialTab;
  final Set<String> _partnerShown = {};

  MatchController get _c => ref.read(matchControllerProvider.notifier);
  DateTime get _now => DateTime.now();

  Rect _area() {
    final s = widget.screen;
    return switch (widget.seat.quarterTurns % 4) {
      0 => Rect.fromLTWH(0, s.height / 2, s.width, s.height / 2),
      1 => Rect.fromLTWH(0, 0, s.width / 2, s.height),
      2 => Rect.fromLTWH(0, 0, s.width, s.height / 2),
      _ => Rect.fromLTWH(s.width / 2, 0, s.width / 2, s.height),
    };
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(matchControllerProvider.select((s) => s.game));
    if (game == null) return const SizedBox.shrink();
    final l = AppL10n.of(context);
    final me = game.config.playerById(widget.playerId);
    final st = game.player(widget.playerId);
    final area = _area();
    final qt = widget.seat.quarterTurns;
    final ins = rotateInsets(screenInsetsFor(area, widget.screen, widget.safePadding), qt);

    final sheet = Material(
      color: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.dialog))),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        // o RotatedBox não gira o MediaQuery: os insets são rotacionados aqui, só nas bordas que tocam a tela
        padding: EdgeInsets.only(left: ins.l, right: ins.r, bottom: ins.b),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.dragHandle, borderRadius: BorderRadius.circular(2)),
            ),
            _header(game, me, st, l),
            _tabs(l, game),
            const Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 8, AppSpace.screenH, 24),
                children: switch (_tab) {
                  DrawerTab.counters => _counters(game, st, l),
                  DrawerTab.commander => _commander(game, st, l),
                  DrawerTab.history => _history(game, l),
                },
              ),
            ),
          ],
        ),
      ),
    );

    return Positioned.fromRect(
      rect: area,
      child: Stack(
        children: [
          // toque fora fecha: a área toda do overlay
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: widget.onClose),
          ),
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: qt,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 1, end: 0),
                duration: AppMotion.sheet,
                curve: AppMotion.emphasized,
                builder: (_, t, child) => FractionalTranslation(translation: Offset(0, t), child: child),
                child: sheet,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(GameState game, PlayerConfig me, PlayerState st, AppL10n l) {
    final acc = _recentDelta(game);
    Widget lifeBtn(FaIconData icon, int d) => GestureDetector(
      onTap: () {
        _c.dispatch(ChangeLife(_now, me.id, d));
        widget.onCheckWinner();
      },
      child: SizedBox(
        width: 56,
        height: 56,
        child: Center(child: FaIcon(icon, size: 22, color: AppColors.textSecondary)),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH, vertical: 6),
      child: Row(
        children: [
          FaIcon(me.color.glyph.icon, size: 16, color: me.color.color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(me.name, style: AppType.title, overflow: TextOverflow.ellipsis),
          ),
          lifeBtn(FontAwesomeIcons.minus, -1),
          SizedBox(
            width: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                LifeNumber(value: st.life, color: me.color.color, fontSize: 60, dim: st.eliminated),
                Positioned(top: -4, right: 0, child: DeltaBadge(delta: acc, fontSize: 18)),
              ],
            ),
          ),
          lifeBtn(FontAwesomeIcons.plus, 1),
          IconButton(tooltip: l.close, onPressed: widget.onClose, icon: const FaIcon(FontAwesomeIcons.xmark, size: 18)),
        ],
      ),
    );
  }

  int _recentDelta(GameState g) {
    for (final e in g.log.reversed) {
      if (e.playerId == widget.playerId && e.kind == LifeEventKind.life) {
        return DateTime.now().difference(e.at) <= AppMotion.deltaHold ? e.delta : 0;
      }
    }
    return 0;
  }

  Widget _tabs(AppL10n l, GameState game) {
    final tabs = [
      (DrawerTab.counters, l.tabCounters),
      if (game.config.has(CounterType.commander)) (DrawerTab.commander, l.tabCommander),
      (DrawerTab.history, l.tabHistory),
    ];
    return SizedBox(
      height: 52,
      child: Row(
        children: [
          for (final t in tabs)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _tab = t.$1),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: _tab == t.$1 ? AppColors.accent : Colors.transparent, width: 2),
                    ),
                  ),
                  child: Text(
                    t.$2,
                    style: AppType.label.copyWith(color: _tab == t.$1 ? AppColors.text : AppColors.textMuted),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── abas ───────────────────────────────────────────────────────────────

  Widget _row(String label, Widget trailing, {FaIconData? icon, Color? color}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        if (icon != null) ...[FaIcon(icon, size: 18, color: color), const SizedBox(width: 12)],
        Expanded(child: Text(label, style: AppType.label)),
        trailing,
      ],
    ),
  );

  List<Widget> _counters(GameState g, PlayerState st, AppL10n l) {
    final cfg = g.config;
    final id = widget.playerId;
    final out = <Widget>[];
    final names = {
      CounterType.poison: l.counterPoison,
      CounterType.energy: l.counterEnergy,
      CounterType.experience: l.counterExperience,
      CounterType.radiation: l.counterRadiation,
    };
    for (final t in const [CounterType.poison, CounterType.energy, CounterType.experience, CounterType.radiation]) {
      if (!cfg.has(t)) continue;
      out.add(
        _row(
          names[t]!,
          LhStepper(
            compact: true,
            value: st.counter(t),
            onChanged: (v) {
              _c.dispatch(ChangeCounter(_now, id, t, v - st.counter(t)));
              widget.onCheckWinner();
            },
          ),
          icon: t.icon,
          color: t.color,
        ),
      );
    }
    final chips = <Widget>[];
    Widget toggle(CounterType t, String label, bool on, VoidCallback f) => FilterChip(
      selected: on,
      showCheckmark: false,
      avatar: FaIcon(t.icon, size: 14, color: on ? AppColors.onAccent : AppColors.accentSoftFg),
      label: Text(label),
      selectedColor: AppColors.accent,
      labelStyle: AppType.label.copyWith(color: on ? AppColors.onAccent : AppColors.text),
      onSelected: (_) => f(),
    );
    if (cfg.has(CounterType.monarch)) {
      final on = g.monarchId == id;
      chips.add(toggle(CounterType.monarch, l.counterMonarch, on, () => _c.dispatch(SetMonarch(_now, on ? null : id))));
    }
    if (cfg.has(CounterType.initiative)) {
      final on = g.initiativeId == id;
      chips.add(
        toggle(CounterType.initiative, l.counterInitiative, on, () => _c.dispatch(SetInitiative(_now, on ? null : id))),
      );
    }
    if (cfg.has(CounterType.dayNight)) {
      final v = g.dayNight;
      chips.add(
        FilterChip(
          selected: v != null,
          showCheckmark: false,
          avatar: FaIcon(
            v == DayNight.night ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
            size: 14,
            color: v != null ? AppColors.onAccent : AppColors.accentSoftFg,
          ),
          label: Text(v == null ? l.counterDayNight : (v == DayNight.day ? l.day : l.night)),
          selectedColor: AppColors.accent,
          labelStyle: AppType.label.copyWith(color: v != null ? AppColors.onAccent : AppColors.text),
          onSelected: (_) =>
              _c.dispatch(SetDayNight(_now, v == null ? DayNight.day : (v == DayNight.day ? DayNight.night : null))),
        ),
      );
    }
    if (chips.isNotEmpty)
      out.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Wrap(spacing: 8, runSpacing: 4, children: chips),
        ),
      );
    if (cfg.has(CounterType.ring)) {
      out.add(
        _row(
          l.counterRing,
          LhStepper(
            compact: true,
            value: st.ring,
            max: 4,
            onChanged: (v) => _c.dispatch(ChangeRing(_now, id, v - st.ring)),
          ),
          icon: CounterType.ring.icon,
          color: AppColors.accent,
        ),
      );
    }
    if (out.isEmpty)
      out.add(
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.noCountersEnabled,
            style: AppType.body.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      );
    out.add(
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 8),
        child: Text(
          l.countersInMatch.toUpperCase(),
          style: AppType.overline.copyWith(color: AppColors.textMuted, fontSize: 12),
        ),
      ),
    );
    out.add(
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final t in toggleableCounters)
            FilterChip(
              selected: cfg.has(t),
              showCheckmark: false,
              avatar: FaIcon(t.icon, size: 14, color: cfg.has(t) ? AppColors.accentSoftFg : AppColors.textMuted),
              label: Text(t.label(l)),
              selectedColor: AppColors.accentSoftBg,
              side: BorderSide(color: cfg.has(t) ? AppColors.accent : AppColors.line),
              onSelected: (_) => _c.dispatch(ToggleCounter(_now, t)),
            ),
        ],
      ),
    );
    return out;
  }

  List<Widget> _commander(GameState g, PlayerState st, AppL10n l) {
    final id = widget.playerId;
    final out = <Widget>[];
    for (final opp in g.config.players) {
      if (opp.id == id) continue;
      final d = st.cmdDamage[opp.id] ?? const CmdDamage();
      void change(int to, {required bool partner}) {
        _c.dispatch(ChangeCmdDamage(_now, id, opp.id, to - (partner ? d.partner : d.main), partner: partner));
        widget.onCheckWinner();
      }

      final showPartner = _partnerShown.contains(opp.id) || d.partner > 0;
      out.add(
        _row(
          l.cmdFrom(opp.name),
          LhStepper(
            compact: true,
            value: d.main,
            onChanged: (v) => change(v, partner: false),
            semanticLabel: l.cmdFrom(opp.name),
          ),
          icon: opp.color.glyph.icon,
          color: opp.color.color,
        ),
      );
      if (showPartner) {
        out.add(
          _row(
            l.partnerOf(opp.name),
            LhStepper(compact: true, value: d.partner, onChanged: (v) => change(v, partner: true)),
          ),
        );
      } else {
        out.add(
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => setState(() => _partnerShown.add(opp.id)), child: Text(l.addPartner)),
          ),
        );
      }
      out.add(const Divider(height: 8, color: AppColors.divider));
    }
    out.add(
      _row(
        l.commanderTax(st.castCount * 2),
        LhStepper(
          compact: true,
          value: st.castCount,
          onChanged: (v) => _c.dispatch(ChangeCastCount(_now, id, v - st.castCount)),
        ),
        icon: FontAwesomeIcons.coins,
        color: AppColors.accent,
      ),
    );
    return out;
  }

  List<Widget> _history(GameState g, AppL10n l) {
    final mine = g.log.where((e) => e.playerId == widget.playerId).toList().reversed.take(60).toList();
    final canUndo = ref.watch(matchControllerProvider).canUndo;
    String text(LifeEvent e) {
      final d = DeltaBadge.format(e.delta);
      return switch (e.kind) {
        LifeEventKind.life => '${l.life} $d → ${e.after}',
        LifeEventKind.counter => '${e.counter!.name} $d → ${e.after}',
        LifeEventKind.cmd => '${l.cmdShort} $d → ${e.after}',
        LifeEventKind.status => d,
      };
    }

    return [
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: canUndo ? _c.undo : null,
          icon: const FaIcon(FontAwesomeIcons.rotateLeft, size: 14),
          label: Text(l.undo),
        ),
      ),
      if (mine.isEmpty)
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l.historyEmpty,
            textAlign: TextAlign.center,
            style: AppType.body.copyWith(color: AppColors.textMuted),
          ),
        ),
      for (final e in mine)
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          leading: Text(l.roundShort(e.round), style: AppType.labelSmall.copyWith(color: AppColors.textMuted)),
          title: Text(text(e), style: AppType.label.copyWith(color: e.delta < 0 ? AppColors.loss : AppColors.gain)),
        ),
    ];
  }
}
