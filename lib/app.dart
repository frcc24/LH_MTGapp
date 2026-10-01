import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/settings_state.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

class LighthouseApp extends ConsumerWidget {
  const LighthouseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    SystemChrome.setPreferredOrientations(
      s.lockOrientation ? [DeviceOrientation.portraitUp] : DeviceOrientation.values,
    );
    return MaterialApp.router(
      title: 'Lighthouse Life',
      debugShowCheckedModeBanner: false,
      // Tema claro é da v1.1: por enquanto só existe o escuro.
      theme: buildAppTheme(colorBlind: s.colorBlind),
      locale: s.locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
    );
  }
}
