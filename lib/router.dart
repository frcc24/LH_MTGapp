import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/cards/card_detail_screen.dart';
import 'features/cards/cards_screen.dart';
import 'features/cards/scryfall.dart';
import 'features/history/history_screen.dart';
import 'features/home/home_screen.dart';
import 'features/mana/mana_screen.dart';
import 'features/monetization/paywall_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/settings/about_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/match/match_screen.dart';
import 'features/match/result/result_screen.dart';
import 'features/settings/settings_state.dart';
import 'features/setup/setup_screen.dart';
import 'features/tools/tools_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final onboarded = ref.read(settingsProvider).onboardingDone;
  return GoRouter(
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/setup', builder: (_, _) => const SetupScreen()),
      GoRoute(
        path: '/match',
        builder: (_, _) => const MatchScreen(),
        routes: [GoRoute(path: 'result', builder: (_, _) => const ResultScreen())],
      ),
      GoRoute(path: '/tools', builder: (_, _) => const ToolsScreen()),
      GoRoute(
        path: '/cards',
        builder: (_, _) => const CardsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, st) => CardDetailScreen(id: st.pathParameters['id']!, card: st.extra as ScryCard?),
          ),
        ],
      ),
      GoRoute(path: '/mana', builder: (_, _) => const ManaScreen()),
      GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
      GoRoute(
        path: '/settings',
        builder: (_, _) => const SettingsScreen(),
        routes: [GoRoute(path: 'about', builder: (_, _) => const AboutScreen())],
      ),
      GoRoute(
        path: '/pro',
        pageBuilder: (_, _) => const MaterialPage(fullscreenDialog: true, child: PaywallScreen()),
      ),
    ],
  );
});
