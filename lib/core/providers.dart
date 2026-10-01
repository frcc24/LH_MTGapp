import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/match/domain/match_storage.dart';
import '../features/match/domain/models.dart';

/// Sobrescrito em `main()` depois de `SharedPreferences.getInstance()`.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider'),
);

final matchStorageProvider = Provider<MatchStorage>((ref) => FileMatchStorage());

/// Partida salva lida na abertura; sobrescrito em `main()`.
final initialMatchProvider = Provider<GameState?>((ref) => null);

/// Histórico lido na abertura; sobrescrito em `main()`.
final initialHistoryProvider = Provider<List<MatchRecord>>((ref) => const []);
