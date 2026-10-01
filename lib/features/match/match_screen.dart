import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/haptics.dart';
import '../../core/sounds.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lighthouse_icon.dart';
import '../settings/settings_state.dart';
import '../tools/tools_panel.dart';
import 'domain/actions.dart';
import 'domain/game_controller.dart';
import 'domain/models.dart';
import 'domain/reducer.dart';
import 'drawer/player_drawer.dart';
import 'layout/match_layout.dart';
import 'menu/match_menu.dart';
import 'widgets/player_panel.dart';

String fmtClock(int seconds) => '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';

class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> with WidgetsBindingObserver {
  Timer? _tick;
  int _remaining = 0;
  bool _timerPaused = false;
  String? _lastActive;
  String? _promptedWinner;
  Timer? _winnerTimer;
  ({String id, DrawerTab tab})? _drawer;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (ref.read(settingsProvider).keepAwake) WakelockPlus.enable();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tick?.cancel();
    _winnerTimer?.cancel();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.paused) ref.read(matchControllerProvider.notifier).flush();
  }

  GameState? get _game => ref.read(matchControllerProvider).game;
  Haptics get _haptics => Haptics(ref.read(settingsProvider).haptics);

  void _onTick() {
    final g = _game;
    if (g == null || g.config.turnTimerSeconds == null || _timerPaused || _menuOpen || g.finished) return;
    if (_remaining > 0) {
      setState(() => _remaining--);
      if (_remaining == 10) ref.read(soundProvider).play(Sfx.tick);
    }
  }

  void _resetTimer(GameState g) {
    _remaining = g.config.turnTimerSeconds ?? 0;
    _lastActive = g.activePlayerId;
  }

  // ── ações ─────────────────────────────────────────────────────────────

  void _life(String id, int delta) {
    final c = ref.read(matchControllerProvider.notifier);
    final wasAlive = !c.game.player(id).eliminated;
    c.dispatch(ChangeLife(DateTime.now(), id, delta));
    final now = c.game.player(id);
    if (wasAlive && now.eliminated) {
      _haptics.heavy();
      ref.read(soundProvider).play(Sfx.eliminated);
    } else if (delta.abs() == 1) {
      _haptics.tick();
    } else {
      _haptics.light();
    }
    _checkWinner();
  }

  void _checkWinner() {
    final g = _game;
    final winners = g?.lastStanding;
    final key = winners?.join(',');
    if (key == null) {
      _promptedWinner = null;
      _winnerTimer?.cancel();
      return;
    }
    if (_promptedWinner == key || g!.finished) return;
    _promptedWinner = key;
    _winnerTimer?.cancel();
    _winnerTimer = Timer(AppMotion.endGameDelay, () {
      if (!mounted) return;
      final l = AppL10n.of(context);
      final names = winners!.map((id) => g.config.playerById(id).name).join(' + ');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 12),
            content: Text(l.winnerPrompt(names)),
            action: SnackBarAction(label: l.seeResult, onPressed: _finish),
          ),
        );
    });
  }

  void _finish() {
    final g = _game;
    if (g == null) return;
    final winners = g.lastStanding ?? const <String>[];
    ref.read(matchControllerProvider.notifier).finish(winners);
    ref.read(settingsProvider.notifier).recordFinishedMatch();
    if (mounted) context.go('/match/result');
  }

  void _pass() {
    final c = ref.read(matchControllerProvider.notifier);
    c.dispatch(PassTurn(DateTime.now()));
    _haptics.light();
    final g = c.game;
    final l = AppL10n.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(l.turnOf(g.config.playerById(g.activePlayerId).name)),
          action: SnackBarAction(label: l.undo, onPressed: c.undo),
        ),
      );
  }

  Future<void> _openMenu() async {
    setState(() {
      _menuOpen = true;
      _drawer = null;
    });
    await showMatchMenu(context, onFinish: _finish);
    if (mounted) setState(() => _menuOpen = false);
  }

  Future<void> _openTools() async {
    setState(() => _menuOpen = true);
    await showToolsSheet(context);
    if (mounted) setState(() => _menuOpen = false);
  }

  Future<void> _exactLife(String id) async {
    final l = AppL10n.of(context);
    final ctrl = TextEditingController();
    final v = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.semEnterLife),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d{0,4}'))],
          style: AppType.lifeM,
          textAlign: TextAlign.center,
          onSubmitted: (s) => Navigator.pop(ctx, int.tryParse(s)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text)), child: Text(l.ok)),
        ],
      ),
    );
    if (v != null) {
      ref.read(matchControllerProvider.notifier).dispatch(SetLife(DateTime.now(), id, v));
      _checkWinner();
    }
  }

  // ── build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(matchControllerProvider.select((s) => s.game));
    if (game == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => mounted ? context.go('/') : null);
      return const Scaffold();
    }
    if (_lastActive != game.activePlayerId) _resetTimer(game);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => didPop ? null : _openMenu(),
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: LayoutBuilder(
          builder: (context, box) {
            final size = box.biggest;
            final pad = MediaQuery.paddingOf(context);
            final padRec = (l: pad.left, t: pad.top, r: pad.right, b: pad.bottom);
            final cfg = game.config;
            final geo = computeGeometry(
              players: cfg.players.length,
              size: size,
              variant: cfg.layoutVariant,
              teams: cfg.hasTeams,
            );
            final timerOn = cfg.turnTimerSeconds != null;
            final total = cfg.turnTimerSeconds ?? 1;
            final l = AppL10n.of(context);

            Widget panel(int i) {
              final seat = geo.seats[i];
              final pc = cfg.players[i];
              final ps = game.player(pc.id);
              final active = isActive(game, pc.id) && cfg.players.length > 1;
              final ins = rotateInsets(screenInsetsFor(seat.rect, size, padRec), seat.quarterTurns);
              final multi = cfg.players.length >= 3;
              final label = active
                  ? '${multi ? l.turnBadge : l.yourTurnBadge}${timerOn ? ' · ${fmtClock(_remaining)}' : ''}'
                  : null;
              return Positioned.fromRect(
                rect: seat.rect,
                child: RotatedBox(
                  quarterTurns: seat.quarterTurns,
                  child: PlayerPanel(
                    key: ValueKey(pc.id),
                    player: pc,
                    state: ps,
                    game: game,
                    radius: seat.radius,
                    isActive: active,
                    turnLabel: label,
                    onTurnBadgeTap: active && multi ? _pass : null,
                    timerFraction: active && timerOn ? _remaining / total : null,
                    timerSeconds: _remaining,
                    safeInsets: EdgeInsets.fromLTRB(ins.l, ins.t, ins.r, ins.b),
                    compact: multi,
                    onLife: (d) => _life(pc.id, d),
                    onOpenDrawer: (tab) => setState(() => _drawer = (id: pc.id, tab: tab)),
                    onRevive: () => ref.read(matchControllerProvider.notifier).dispatch(Revive(DateTime.now(), pc.id)),
                    onExactLife: () => _exactLife(pc.id),
                  ),
                ),
              );
            }

            final c = ref.read(matchControllerProvider);
            return Stack(
              children: [
                for (var i = 0; i < cfg.players.length; i++) panel(i),
                if (geo.strip != null) _strip(geo, game, c.canUndo),
                if (_drawer == null) _hub(geo),
                if (_drawer != null)
                  PlayerDrawerOverlay(
                    key: ValueKey(_drawer!.id),
                    playerId: _drawer!.id,
                    initialTab: _drawer!.tab,
                    seat: geo.seats[cfg.players.indexWhere((p) => p.id == _drawer!.id)],
                    screen: size,
                    safePadding: padRec,
                    onClose: () => setState(() => _drawer = null),
                    onCheckWinner: _checkWinner,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _hub(MatchGeometry geo) {
    final d = geo.hubSize;
    return Positioned(
      left: geo.hubCenter.dx - d / 2,
      top: geo.hubCenter.dy - d / 2,
      width: d,
      height: d,
      child: Semantics(
        button: true,
        label: AppL10n.of(context).matchMenu,
        child: GestureDetector(
          onTap: _openMenu,
          onLongPress: () {
            _haptics.heavy();
            showD20Roll(context);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bg,
              border: Border.all(color: AppColors.lineStrong, width: 2),
              boxShadow: AppShadow.hubGlow,
            ),
            // anel de 6 px da cor do fundo "recorta" os painéis
            foregroundDecoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.bg, width: 6),
            ),
            child: Center(
              child: LighthouseIcon(size: d * 0.5, color: AppColors.accent),
            ),
          ),
        ),
      ),
    );
  }

  Widget _strip(MatchGeometry geo, GameState game, bool canUndo) {
    final l = AppL10n.of(context);
    final cfg = game.config;
    final timerOn = cfg.turnTimerSeconds != null;
    Widget round(FaIconData icon, String label, VoidCallback? onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            border: Border.all(color: AppColors.line),
          ),
          child: FaIcon(icon, size: 20, color: onTap == null ? AppColors.disabled : AppColors.textSecondary),
        ),
      ),
    );
    final vertical = geo.stripVertical;
    final pass = Semantics(
      button: true,
      label: '${l.semPassTurn} (${l.roundN(game.round)})',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: _pass,
        child: vertical
            ? Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'R${game.round}',
                      style: AppType.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                    const FaIcon(FontAwesomeIcons.forwardStep, size: 16, color: AppColors.text),
                  ],
                ),
              )
            : Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('R${game.round}', style: AppType.label.copyWith(color: AppColors.textMuted)),
                    const SizedBox(width: 8),
                    Text(l.pass, style: AppType.label.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
      ),
    );
    final left = <Widget>[
      if (timerOn)
        round(
          _timerPaused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
          l.pauseTimer,
          () => setState(() => _timerPaused = !_timerPaused),
        ),
      pass,
    ];
    final right = <Widget>[
      round(FontAwesomeIcons.diceD20, l.tools, _openTools),
      round(FontAwesomeIcons.rotateLeft, l.undo, canUndo ? _undo : null),
    ];
    Widget group(List<Widget> w) => Expanded(
      child: vertical
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: w)
          : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: w),
    );
    final gap = SizedBox(width: vertical ? 0 : geo.hubSize + 8, height: vertical ? geo.hubSize + 8 : 0);
    final flex = [group(left), gap, group(right)];
    return Positioned.fromRect(
      rect: geo.strip!,
      child: vertical ? Column(children: flex) : Row(children: flex),
    );
  }

  void _undo() {
    if (ref.read(matchControllerProvider.notifier).undo()) _haptics.light();
  }
}
