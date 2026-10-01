import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/glyphs.dart';
import '../../../l10n/app_localizations.dart';
import '../../monetization/ads_service.dart';
import '../../setup/last_config.dart';
import '../domain/formats.dart';
import '../domain/game_controller.dart';
import '../domain/models.dart';
import '../domain/reducer.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final game = ref.watch(matchControllerProvider.select((s) => s.game));
    if (game == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.mounted ? context.go('/') : null);
      return const Scaffold();
    }
    final record = buildRecord(game, id: 'view', now: DateTime.now(), finished: true);
    final c = ref.read(matchControllerProvider.notifier);
    final winner = record.players.isEmpty || record.winnerNames.isEmpty ? null : record.players.first;
    final dur = record.duration;
    final mins = dur.inMinutes;

    Widget stat(String v, String label) => Expanded(
      child: Column(
        children: [
          Text(v, style: AppType.lifeS.copyWith(fontSize: 34)),
          Text(label, style: AppType.caption.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(AppSpace.screenH),
              children: [
                const SizedBox(height: 16),
                if (winner != null) ...[
                  const Center(child: FaIcon(FontAwesomeIcons.crown, size: 40, color: AppColors.accent)),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      record.winnerNames.join(' + ').toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppType.heroTitle.copyWith(
                        color: winner.color.color,
                        shadows: [Shadow(color: winner.color.color.withValues(alpha: 0.4), blurRadius: 30)],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(l.wins, style: AppType.overline.copyWith(color: AppColors.textMuted)),
                  ),
                ] else
                  Center(child: Text(l.matchOver.toUpperCase(), style: AppType.screenTitleDisplay)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    stat(
                      mins >= 60 ? '${mins ~/ 60}h${(mins % 60).toString().padLeft(2, '0')}' : '$mins min',
                      l.duration,
                    ),
                    stat('${record.rounds}', l.rounds),
                    stat(
                      game.config.formatId == 'custom' ? l.formatCustom : formatById(game.config.formatId).name,
                      l.formatLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                for (final p in record.players)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.tile),
                      border: Border.all(color: p.place == 1 ? AppColors.accent : AppColors.line),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text('${p.place}º', style: AppType.label.copyWith(color: AppColors.textMuted)),
                        ),
                        FaIcon(p.color.glyph.icon, size: 16, color: p.color.color),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.name, style: AppType.label.copyWith(fontSize: 17)),
                              if (p.reason != null)
                                Text(
                                  _reason(l, p.reason!),
                                  style: AppType.caption.copyWith(color: AppColors.textMuted),
                                ),
                            ],
                          ),
                        ),
                        Text('${p.finalLife}', style: AppType.counterLarge),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    c.start(game.config);
                    context.go('/match');
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowRotateRight, size: 16),
                  label: Text(l.rematch),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    ref.read(lastConfigProvider.notifier).save(game.config);
                    c.clear();
                    context.go('/setup');
                  },
                  child: Text(l.changeConfig),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    c.clear();
                    context.go('/');
                    await ref.read(adsProvider.notifier).maybeShowInterstitial(minutesPlayed: mins);
                  },
                  child: Text(l.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _reason(AppL10n l, EliminationReason r) => switch (r) {
    EliminationReason.life => l.reasonLife,
    EliminationReason.poison => l.reasonPoison,
    EliminationReason.commander => l.reasonCommander,
  };
}
