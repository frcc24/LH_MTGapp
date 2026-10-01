import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../monetization/pro_state.dart';
import 'actions.dart';
import 'models.dart';
import 'reducer.dart';

const maxUndo = 200;

class _Snap {
  _Snap(this.state, this.tag, this.at);
  final GameState state;
  final String? tag;
  final DateTime at;
}

/// Partida em andamento e a profundidade do desfazer.
class MatchSession {
  const MatchSession({this.game, this.undoCount = 0});
  final GameState? game;
  final int undoCount;

  bool get active => game != null;
  bool get canUndo => undoCount > 0;
}

/// Único ponto que muda o estado da partida: tudo passa por [reduce].
class MatchController extends Notifier<MatchSession> {
  final List<_Snap> _undo = [];
  Timer? _saveTimer;
  Random _rng = Random();

  @override
  MatchSession build() {
    ref.onDispose(() => _saveTimer?.cancel());
    return MatchSession(game: ref.read(initialMatchProvider));
  }

  /// Só para testes.
  void seedRandom(Random r) => _rng = r;

  GameState get game => state.game!;

  /// Começa uma partida nova. Sorteia o primeiro jogador se a config pedir.
  GameState start(GameConfig config, {DateTime? now}) {
    final alive = config.players.map((p) => p.id).toList();
    final starter = config.starter == StarterMode.chosen && config.starterId != null
        ? config.starterId!
        : alive[_rng.nextInt(alive.length)];
    _undo.clear();
    final g = createInitialState(config, now: now ?? DateTime.now(), starterId: starter);
    state = MatchSession(game: g);
    _persist();
    return g;
  }

  /// Mesma configuração, estado zerado, mesmo primeiro jogador sorteado de novo.
  GameState restart({DateTime? now}) => start(game.config, now: now);

  void dispatch(GameAction a) {
    final cur = state.game;
    if (cur == null) return;
    final next = reduce(cur, a);
    if (identical(next, cur)) return;
    final tag = a.undoTag;
    final last = _undo.isEmpty ? null : _undo.last;
    final coalesce = tag != null && last != null && last.tag == tag && a.at.difference(last.at) <= coalesceWindow;
    if (coalesce) {
      _undo[_undo.length - 1] = _Snap(last.state, tag, a.at);
    } else {
      _undo.add(_Snap(cur, tag, a.at));
      if (_undo.length > maxUndo) _undo.removeAt(0);
    }
    state = MatchSession(game: next, undoCount: _undo.length);
    _persist();
  }

  /// Desfaz a última entrada. Devolve false se não havia nada.
  bool undo() {
    if (_undo.isEmpty) return false;
    final snap = _undo.removeLast();
    state = MatchSession(game: snap.state, undoCount: _undo.length);
    _persist();
    return true;
  }

  /// Encerra a partida, grava no histórico e devolve o registro.
  MatchRecord finish(List<String> winnerIds, {DateTime? now}) {
    final t = now ?? DateTime.now();
    dispatch(EndGame(t, winnerIds));
    final record = buildRecord(game, id: t.microsecondsSinceEpoch.toString(), now: t, finished: true);
    ref.read(historyProvider.notifier).add(record);
    return record;
  }

  /// Descarta a partida (sair sem registrar, ou depois de ver o resultado).
  void clear() {
    _undo.clear();
    state = const MatchSession();
    _persist();
  }

  void _persist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 300), flush);
  }

  /// Grava agora (usado ao sair do app e nos testes).
  Future<void> flush() async {
    _saveTimer?.cancel();
    final g = state.game;
    await ref.read(matchStorageProvider).saveCurrent(g != null && !g.finished ? g : null);
  }
}

final matchControllerProvider = NotifierProvider<MatchController, MatchSession>(MatchController.new);

/// Histórico de partidas, mais recentes primeiro. Grátis guarda 20, Pro guarda todas.
class HistoryNotifier extends Notifier<List<MatchRecord>> {
  @override
  List<MatchRecord> build() => ref.read(initialHistoryProvider);

  Future<void> add(MatchRecord r) async {
    var list = [r, ...state];
    if (!ref.read(isProProvider) && list.length > FreeLimits.history) list = list.sublist(0, FreeLimits.history);
    state = list;
    await ref.read(matchStorageProvider).saveHistory(list);
  }

  Future<void> clear() async {
    state = const [];
    await ref.read(matchStorageProvider).saveHistory(const []);
  }
}

final historyProvider = NotifierProvider<HistoryNotifier, List<MatchRecord>>(HistoryNotifier.new);
