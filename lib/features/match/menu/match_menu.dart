import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/hold_to_confirm_button.dart';
import '../../settings/settings_state.dart';
import '../../tools/tools_panel.dart';
import '../domain/actions.dart';
import '../domain/game_controller.dart';

Future<void> showMatchMenu(BuildContext context, {required VoidCallback onFinish}) => showDialog<void>(
  context: context,
  builder: (_) => _MatchMenu(onFinish: onFinish),
);

class _MatchMenu extends ConsumerStatefulWidget {
  const _MatchMenu({required this.onFinish});
  final VoidCallback onFinish;

  @override
  ConsumerState<_MatchMenu> createState() => _MatchMenuState();
}

class _MatchMenuState extends ConsumerState<_MatchMenu> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final game = ref.watch(matchControllerProvider).game;
    if (game == null) return const SizedBox.shrink();
    final nav = Navigator.of(context);
    final root = GoRouter.of(context);
    final haptics = ref.watch(settingsProvider.select((s) => s.haptics));
    final elapsed = DateTime.now().difference(game.startedAt);
    final clock = elapsed.inHours > 0
        ? '${elapsed.inHours}:${(elapsed.inMinutes % 60).toString().padLeft(2, '0')}'
        : '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';

    void closeThen(VoidCallback f) {
      nav.pop();
      f();
    }

    Widget shortcut(FaIconData icon, String label, VoidCallback onTap) => Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.elevated,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 22, color: AppColors.accent),
              const SizedBox(height: 8),
              Text(label, style: AppType.labelSmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );

    final c = ref.read(matchControllerProvider.notifier);
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(20),
      child: RotatedBox(
        quarterTurns: _flipped ? 2 : 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(l.matchMenu, style: AppType.title)),
                    Text(
                      '$clock · ${l.roundN(game.round)}',
                      style: AppType.labelSmall.copyWith(color: AppColors.textMuted),
                    ),
                    IconButton(
                      tooltip: l.flipDialog,
                      onPressed: () => setState(() => _flipped = !_flipped),
                      icon: const FaIcon(FontAwesomeIcons.rotate, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.15,
                  children: [
                    shortcut(
                      FontAwesomeIcons.diceD20,
                      l.toolDice,
                      () => closeThen(() => showToolsSheet(context, tab: ToolTab.dice)),
                    ),
                    shortcut(
                      FontAwesomeIcons.coins,
                      l.toolCoin,
                      () => closeThen(() => showToolsSheet(context, tab: ToolTab.coin)),
                    ),
                    shortcut(
                      FontAwesomeIcons.bullseye,
                      l.toolPicker,
                      () => closeThen(() => showToolsSheet(context, tab: ToolTab.picker)),
                    ),
                    shortcut(
                      FontAwesomeIcons.stopwatch,
                      l.toolTimer,
                      () => closeThen(() => showToolsSheet(context, tab: ToolTab.timer)),
                    ),
                    shortcut(
                      FontAwesomeIcons.forwardStep,
                      l.semPassTurn,
                      () => closeThen(() => c.dispatch(PassTurn(DateTime.now()))),
                    ),
                    shortcut(FontAwesomeIcons.sliders, l.quickSettings, () => closeThen(() => root.push('/settings'))),
                  ],
                ),
                const SizedBox(height: 16),
                HoldToConfirmButton(
                  label: l.holdRestart,
                  icon: FontAwesomeIcons.arrowRotateRight,
                  haptics: haptics,
                  onConfirmed: () => closeThen(() => c.restart()),
                ),
                const SizedBox(height: 10),
                HoldToConfirmButton(
                  label: l.holdEnd,
                  icon: FontAwesomeIcons.flagCheckered,
                  haptics: haptics,
                  onConfirmed: () => closeThen(widget.onFinish),
                ),
                const SizedBox(height: 10),
                HoldToConfirmButton(
                  label: l.holdLeave,
                  icon: FontAwesomeIcons.rightFromBracket,
                  haptics: haptics,
                  onConfirmed: () => closeThen(() {
                    c.clear();
                    root.go('/');
                  }),
                ),
                const SizedBox(height: 4),
                TextButton(onPressed: nav.pop, child: Text(l.resume)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
