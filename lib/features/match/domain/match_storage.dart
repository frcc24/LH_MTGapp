import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'models.dart';

/// Persistência local: partida em andamento e histórico. Volume minúsculo, então JSON em arquivo.
abstract class MatchStorage {
  Future<GameState?> loadCurrent();
  Future<void> saveCurrent(GameState? state);
  Future<List<MatchRecord>> loadHistory();
  Future<void> saveHistory(List<MatchRecord> records);
}

class FileMatchStorage implements MatchStorage {
  Future<File> _file(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$name');
  }

  @override
  Future<GameState?> loadCurrent() async {
    try {
      final f = await _file('current_match.json');
      if (!await f.exists()) return null;
      return GameState.fromJson(jsonDecode(await f.readAsString()) as Map<String, dynamic>);
    } catch (_) {
      return null; // arquivo corrompido: começa limpo
    }
  }

  @override
  Future<void> saveCurrent(GameState? state) async {
    final f = await _file('current_match.json');
    if (state == null) {
      if (await f.exists()) await f.delete();
      return;
    }
    await f.writeAsString(jsonEncode(state.toJson()), flush: true);
  }

  @override
  Future<List<MatchRecord>> loadHistory() async {
    try {
      final f = await _file('history.json');
      if (!await f.exists()) return [];
      final list = jsonDecode(await f.readAsString()) as List;
      return [for (final e in list) MatchRecord.fromJson(Map<String, dynamic>.from(e as Map))];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveHistory(List<MatchRecord> records) async {
    final f = await _file('history.json');
    await f.writeAsString(jsonEncode([for (final r in records) r.toJson()]), flush: true);
  }
}

class MemoryMatchStorage implements MatchStorage {
  GameState? current;
  List<MatchRecord> history = [];

  @override
  Future<GameState?> loadCurrent() async => current;
  @override
  Future<void> saveCurrent(GameState? state) async => current = state;
  @override
  Future<List<MatchRecord>> loadHistory() async => history;
  @override
  Future<void> saveHistory(List<MatchRecord> records) async => history = records;
}
