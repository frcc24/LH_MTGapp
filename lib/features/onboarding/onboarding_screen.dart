import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lighthouse_icon.dart';
import '../settings/settings_state.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _i = 0;

  void _done() {
    ref.read(settingsProvider.notifier).setOnboardingDone();
    context.go('/');
  }

  @override
  void dispose() {
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final pages = [
      (const LighthouseIcon(size: 96, color: AppColors.accent), l.onb1Title, l.onb1Body),
      (const FaIcon(FontAwesomeIcons.usersGear, size: 72, color: AppColors.energy), l.onb2Title, l.onb2Body),
      (const FaIcon(FontAwesomeIcons.diceD20, size: 72, color: AppColors.poison), l.onb3Title, l.onb3Body),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: _done, child: Text(l.skip)),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (i) => setState(() => _i = i),
                children: [
                  for (final p in pages)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          p.$1,
                          const SizedBox(height: 32),
                          Text(p.$2, style: AppType.screenTitleDisplay, textAlign: TextAlign.center),
                          const SizedBox(height: 12),
                          Text(
                            p.$3,
                            style: AppType.bodyLarge.copyWith(color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pages.length; i++)
                  Container(
                    width: i == _i ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == _i ? AppColors.accent : AppColors.pressed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpace.screenH),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _i == pages.length - 1
                      ? _done()
                      : _page.nextPage(duration: AppMotion.page, curve: AppMotion.standard),
                  child: Text(_i == pages.length - 1 ? l.getStarted : l.next),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
