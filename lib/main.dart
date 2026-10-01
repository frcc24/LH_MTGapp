import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/providers.dart';
import 'features/match/domain/match_storage.dart';
import 'features/settings/settings_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = FileMatchStorage();
  final current = await storage.loadCurrent();
  final history = await storage.loadHistory();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      matchStorageProvider.overrideWithValue(storage),
      initialMatchProvider.overrideWithValue(current),
      initialHistoryProvider.overrideWithValue(history),
    ],
  );
  container.read(settingsProvider.notifier).bumpSessions();
  runApp(UncontrolledProviderScope(container: container, child: const LighthouseApp()));
}
