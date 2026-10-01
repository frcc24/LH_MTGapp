import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lighthouse_icon.dart';
import '../match/domain/game_controller.dart';
import '../monetization/ad_banner.dart';
import '../monetization/consent.dart';
import '../monetization/pro_state.dart';
import '../setup/last_config.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // consentimento de anúncios: depois da 1ª partida ou na 2ª abertura, nunca no 1º segundo
    WidgetsBinding.instance.addPostFrameCallback((_) => mounted ? maybeAskAdsConsent(context, ref) : null);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final last = ref.watch(lastConfigProvider) ?? defaultConfig(l);
    final game = ref.watch(matchControllerProvider.select((s) => s.game));
    final history = ref.watch(historyProvider);
    final pro = ref.watch(isProProvider);

    void quickStart() {
      ref.read(matchControllerProvider.notifier).start(last);
      ref.read(lastConfigProvider.notifier).save(last);
      context.go('/match');
    }

    Widget tile(FaIconData icon, Color color, String title, String sub, String route) => Expanded(
      child: Semantics(
        button: true,
        label: '$title, $sub',
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => context.push(route),
          child: Container(
            height: 112,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FaIcon(icon, size: 22, color: color),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppType.label.copyWith(fontSize: 18)),
                    Text(
                      sub,
                      style: AppType.caption.copyWith(color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 16, AppSpace.screenH, 16),
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: LighthouseIcon(size: 26, color: AppColors.accent)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l.appName.toUpperCase(), style: AppType.screenTitleDisplay.copyWith(fontSize: 30)),
                    ),
                    IconButton.outlined(
                      onPressed: () => context.push('/settings'),
                      tooltip: l.settings,
                      icon: const FaIcon(FontAwesomeIcons.gear, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // botão herói
                Semantics(
                  button: true,
                  label: '${l.newMatch}. ${configSummary(l, last)}',
                  excludeSemantics: true,
                  child: GestureDetector(
                    onTap: quickStart,
                    child: Container(
                      height: 220,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(AppRadius.dialog),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  l.lastConfig.toUpperCase(),
                                  style: AppType.overline.copyWith(color: AppColors.onAccent),
                                ),
                              ),
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.onAccent),
                                child: const Center(
                                  child: FaIcon(FontAwesomeIcons.play, size: 18, color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(l.newMatch.toUpperCase(), style: AppType.heroTitle.copyWith(color: AppColors.onAccent)),
                          const SizedBox(height: 6),
                          Text(
                            configSummary(l, last),
                            style: AppType.label.copyWith(color: AppColors.onAccent, fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () => context.push('/setup'),
                    child: Text(l.configureOther, style: AppType.label.copyWith(color: AppColors.accent)),
                  ),
                ),
                if (game != null && !game.finished)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Semantics(
                      button: true,
                      excludeSemantics: true,
                      label: l.continueMatch,
                      child: GestureDetector(
                        onTap: () => context.go('/match'),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  for (final p in game.config.players.take(4))
                                    Container(
                                      width: 8,
                                      height: 36,
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: p.color.color,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(l.continueMatch, style: AppType.label.copyWith(fontSize: 18)),
                                    Text(
                                      '${configSummary(l, game.config).split(' · ').first} · ${game.config.players.map((p) => '${p.name} ${game.player(p.id).life}').take(3).join(' × ')} · ${l.roundN(game.round)}',
                                      style: AppType.caption.copyWith(color: AppColors.textMuted),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    tile(FontAwesomeIcons.diceD20, AppColors.energy, l.tools, l.toolsSub, '/tools'),
                    const SizedBox(width: 12),
                    tile(FontAwesomeIcons.clone, AppColors.commander, l.cards, l.cardsSub, '/cards'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    tile(FontAwesomeIcons.chartSimple, AppColors.poison, l.manaBase, l.manaSub, '/mana'),
                    const SizedBox(width: 12),
                    tile(
                      FontAwesomeIcons.clockRotateLeft,
                      AppColors.textSecondary,
                      l.history,
                      l.historySub(history.length),
                      '/history',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (!pro)
                  Row(
                    children: [
                      const Expanded(child: AdBanner()),
                      TextButton(
                        onPressed: () => context.push('/pro'),
                        child: Text(l.removeAds, style: AppType.label.copyWith(color: AppColors.accent)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
