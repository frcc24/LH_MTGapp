import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/theme/glyphs.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lighthouse_icon.dart';
import 'domain/formats.dart';
import 'domain/models.dart';
import 'domain/reducer.dart';
import 'widgets/counter_chip.dart';
import 'widgets/player_panel.dart';

/// Partida de 1 jogador (goldfish): cabeçalho com turno, painel com ±5 e "Digitar", contadores, vida por turno
/// e "Próximo turno". Em paisagem o painel fica à esquerda e o resto à direita.
class SoloView extends StatelessWidget {
  const SoloView({
    super.key,
    required this.game,
    required this.canUndo,
    required this.onLife,
    required this.onMenu,
    required this.onUndo,
    required this.onNextTurn,
    required this.onOpenDrawer,
    required this.onExactLife,
    required this.onRevive,
  });

  final GameState game;
  final bool canUndo;
  final ValueChanged<int> onLife;
  final VoidCallback onMenu;
  final VoidCallback onUndo;
  final VoidCallback onNextTurn;
  final ValueChanged<DrawerTab> onOpenDrawer;
  final VoidCallback onExactLife;
  final VoidCallback onRevive;

  PlayerConfig get _p => game.config.players.first;
  PlayerState get _s => game.players.first;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, box) {
          final wide = box.maxWidth > box.maxHeight;
          final panel = _panel(l);
          if (!wide) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Column(
                children: [
                  _header(l),
                  const SizedBox(height: 12),
                  Expanded(child: panel),
                  ..._rest(l),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(flex: 6, child: panel),
                const SizedBox(width: 12),
                Expanded(flex: 4, child: Column(children: [_header(l), const Spacer(), ..._rest(l)])),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _rest(AppL10n l) => [
    ..._counters(),
    const SizedBox(height: 12),
    _bars(l),
    const SizedBox(height: 12),
    SizedBox(
      height: 60,
      width: double.infinity,
      child: FilledButton(onPressed: onNextTurn, child: Text(l.nextTurn)),
    ),
  ];

  Widget _circle(FaIconData? icon, String label, VoidCallback? onTap, {Widget? child}) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.touchMin,
        height: AppSize.touchMin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.lineStrong, width: 2),
        ),
        child: child ?? FaIcon(icon, size: 20, color: onTap == null ? AppColors.disabled : AppColors.textSecondary),
      ),
    ),
  );

  Widget _header(AppL10n l) {
    final f = formatById(game.config.formatId);
    final format = f.isCustom ? l.formatCustom : f.name;
    return SizedBox(
      height: AppSize.touchMin,
      child: Row(
        children: [
          _circle(null, l.matchMenu, onMenu, child: const LighthouseIcon(size: 26, color: AppColors.accent)),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${l.soloLabel} · $format'.toUpperCase(),
                  style: AppType.overline.copyWith(color: AppColors.textMuted, fontSize: 12),
                ),
                Text(l.turnTitle(game.round), style: AppType.screenTitleDisplay.copyWith(fontSize: 34)),
              ],
            ),
          ),
          _circle(FontAwesomeIcons.rotateLeft, l.undo, canUndo ? onUndo : null),
        ],
      ),
    );
  }

  Widget _panel(AppL10n l) {
    Widget pill(String text, VoidCallback onTap, {bool display = true}) => Semantics(
      button: true,
      label: text,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.elevated,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: AppColors.lineStrong),
          ),
          child: Text(text, style: display ? AppType.counterLarge : AppType.labelSmall.copyWith(fontSize: 14)),
        ),
      ),
    );
    return Stack(
      children: [
        Positioned.fill(
          child: PlayerPanel(
            player: _p,
            state: _s,
            game: game,
            radius: AppRadius.dialog + 2,
            isActive: true,
            showChips: false,
            onLife: onLife,
            onOpenDrawer: onOpenDrawer,
            onExactLife: onExactLife,
            onRevive: onRevive,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 22,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pill('−5', () => onLife(-5)),
              const SizedBox(width: 8),
              pill(l.typeValue, onExactLife, display: false),
              const SizedBox(width: 8),
              pill('+5', () => onLife(5)),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _counters() {
    final on = [
      for (final t in const [CounterType.poison, CounterType.energy, CounterType.experience, CounterType.radiation])
        if (game.config.has(t)) t,
    ];
    if (on.isEmpty) return const [SizedBox(height: 12)];
    return [
      const SizedBox(height: 12),
      Row(
        children: [
          for (final t in on)
            Expanded(
              child: Center(
                child: CounterChip(
                  icon: t.icon,
                  value: '${_s.counter(t)}',
                  color: t.color,
                  height: 52,
                  onTap: () => onOpenDrawer(DrawerTab.counters),
                ),
              ),
            ),
        ],
      ),
    ];
  }

  Widget _bars(AppL10n l) {
    final all = lifeByRound(game, _p.id);
    final shown = all.length > 5 ? all.sublist(all.length - 5) : all;
    final top = shown.fold<int>(game.config.startingLife, math.max).clamp(1, 1 << 30);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l.lifePerTurn.toUpperCase(),
                style: AppType.overline.copyWith(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
            Text(
              l.lifeStartNow(game.config.startingLife, _s.life),
              style: AppType.overline.copyWith(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < shown.length; i++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${shown[i]}',
                          style: AppType.labelSmall.copyWith(
                            fontSize: 12,
                            color: i == shown.length - 1 ? AppColors.accent : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: math.max(10.0, 36 * shown[i].clamp(0, top) / top),
                          decoration: BoxDecoration(
                            color: i == shown.length - 1 ? AppColors.accent : AppColors.pressed,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
