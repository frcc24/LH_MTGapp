import 'actions.dart';
import 'models.dart';

const int cmdDamageLethal = 21;
const int cmdDamageWarn = 15;
const int poisonWarn = 8;
const int maxLogEntries = 2000;

GameState createInitialState(GameConfig config, {required DateTime now, String? starterId}) {
  final players = [
    for (final p in config.players)
      PlayerState(
        id: p.id,
        life: config.startingLife,
        counters: {
          for (final c in CounterType.values)
            if (c.isValueCounter && config.has(c)) c: 0,
        },
      ),
  ];
  return GameState(
    config: config,
    players: players,
    activePlayerId: starterId ?? config.starterId ?? config.players.first.id,
    startedAt: now,
  );
}

/// Quem está jogando agora, contando os colegas de time.
bool isActive(GameState s, String playerId) {
  if (s.activePlayerId == playerId) return true;
  final team = s.config.teamOf(s.activePlayerId);
  return team != null && team.contains(playerId);
}

GameState reduce(GameState s, GameAction a) {
  final next = switch (a) {
    ChangeLife() => _changeLife(s, a),
    SetLife() => _setLife(s, a),
    ChangeCounter() => _changeCounter(s, a),
    ChangeCmdDamage() => _changeCmd(s, a),
    ChangeCastCount() => _changeCast(s, a),
    SetMonarch() => a.playerId == null ? s.copyWith(clearMonarch: true) : s.copyWith(monarchId: a.playerId),
    SetInitiative() => a.playerId == null ? s.copyWith(clearInitiative: true) : s.copyWith(initiativeId: a.playerId),
    SetDayNight() => a.value == null ? s.copyWith(clearDayNight: true) : s.copyWith(dayNight: a.value),
    ChangeRing() => _changeRing(s, a),
    PassTurn() => _passTurn(s),
    SetActive() => s.copyWith(activePlayerId: a.playerId),
    Revive() => _revive(s, a),
    EndGame() => s.copyWith(endedAt: a.at, winnerIds: a.winnerIds),
    ResumeGame() => s.copyWith(clearEnded: true, winnerIds: const []),
  };
  return identical(next, s) ? s : _recompute(next);
}

// ── vida ────────────────────────────────────────────────────────────────

List<String> _lifeTargets(GameState s, String id) => s.config.teamOf(id) ?? [id];

GameState _changeLife(GameState s, ChangeLife a) {
  if (a.delta == 0) return s;
  final targets = _lifeTargets(s, a.playerId);
  final players = [for (final p in s.players) targets.contains(p.id) ? p.copyWith(life: p.life + a.delta) : p];
  final after = players.firstWhere((p) => p.id == a.playerId).life;
  return s.copyWith(
    players: players,
    log: _log(
      s,
      LifeEvent(at: a.at, round: s.round, playerId: a.playerId, kind: LifeEventKind.life, delta: a.delta, after: after),
    ),
  );
}

GameState _setLife(GameState s, SetLife a) {
  final cur = s.player(a.playerId).life;
  return _changeLife(s, ChangeLife(a.at, a.playerId, a.value - cur));
}

// ── contadores ─────────────────────────────────────────────────────────────

GameState _changeCounter(GameState s, ChangeCounter a) {
  if (!a.type.isValueCounter) return s;
  // Veneno é compartilhado no Two-Headed Giant.
  final targets = a.type == CounterType.poison ? _lifeTargets(s, a.playerId) : [a.playerId];
  final cur = s.player(a.playerId).counter(a.type);
  final applied = (cur + a.delta) < 0 ? -cur : a.delta;
  if (applied == 0) return s;
  final players = [
    for (final p in s.players)
      targets.contains(p.id) ? p.copyWith(counters: {...p.counters, a.type: p.counter(a.type) + applied}) : p,
  ];
  return s.copyWith(
    players: players,
    log: _log(
      s,
      LifeEvent(
        at: a.at,
        round: s.round,
        playerId: a.playerId,
        kind: LifeEventKind.counter,
        delta: applied,
        after: cur + applied,
        counter: a.type,
      ),
    ),
  );
}

GameState _changeCmd(GameState s, ChangeCmdDamage a) {
  final victim = s.player(a.playerId);
  final cur = victim.cmdDamage[a.sourceId] ?? const CmdDamage();
  final curValue = a.partner ? cur.partner : cur.main;
  final applied = (curValue + a.delta) < 0 ? -curValue : a.delta;
  if (applied == 0) return s;
  final updated = a.partner ? cur.copyWith(partner: curValue + applied) : cur.copyWith(main: curValue + applied);
  final players = [
    for (final p in s.players)
      p.id == a.playerId
          ? p.copyWith(
              cmdDamage: {...p.cmdDamage, a.sourceId: updated},
              life: s.config.cmdDamageAffectsLife ? p.life - applied : p.life,
            )
          : p,
  ];
  final log = _log(
    s,
    LifeEvent(
      at: a.at,
      round: s.round,
      playerId: a.playerId,
      kind: LifeEventKind.cmd,
      delta: applied,
      after: curValue + applied,
      sourceId: a.sourceId,
    ),
  );
  return s.copyWith(players: players, log: log);
}

GameState _changeCast(GameState s, ChangeCastCount a) {
  final p = s.player(a.playerId);
  final cur = a.partner ? p.castCountPartner : p.castCount;
  final v = (cur + a.delta) < 0 ? 0 : cur + a.delta;
  if (v == cur) return s;
  return s.copyWith(
    players: [
      for (final q in s.players)
        q.id == a.playerId ? (a.partner ? q.copyWith(castCountPartner: v) : q.copyWith(castCount: v)) : q,
    ],
  );
}

GameState _changeRing(GameState s, ChangeRing a) {
  final p = s.player(a.playerId);
  final v = (p.ring + a.delta).clamp(0, 4);
  if (v == p.ring) return s;
  return s.copyWith(players: [for (final q in s.players) q.id == a.playerId ? q.copyWith(ring: v) : q]);
}

// ── turno ─────────────────────────────────────────────────────────────────

GameState _passTurn(GameState s) {
  final order = s.config.players.map((p) => p.id).toList();
  final alive = s.aliveIds;
  if (alive.isEmpty) return s;
  final team = s.config.teamOf(s.activePlayerId);
  final idx = order.indexOf(s.activePlayerId);
  for (var step = 1; step <= order.length; step++) {
    final ni = (idx + step) % order.length;
    final wrapped = idx + step >= order.length;
    final cand = order[ni];
    if (!alive.contains(cand)) continue;
    if (team != null && team.contains(cand)) continue; // time inteiro joga junto
    return s.copyWith(activePlayerId: cand, round: wrapped ? s.round + 1 : s.round, turnCount: s.turnCount + 1);
  }
  // Só sobrou o próprio jogador (ou time): nova rodada, mesmo jogador.
  return s.copyWith(round: s.round + 1, turnCount: s.turnCount + 1);
}

// ── eliminação ─────────────────────────────────────────────────────────────

GameState _revive(GameState s, Revive a) {
  final targets = _lifeTargets(s, a.playerId);
  return s.copyWith(
    players: [for (final p in s.players) targets.contains(p.id) && p.eliminated ? p.copyWith(revived: true) : p],
  );
}

EliminationReason? _lethalReason(GameState s, PlayerState p) {
  if (p.life <= 0) return EliminationReason.life;
  if (s.config.has(CounterType.poison) || p.poison > 0) {
    if (p.poison >= s.config.poisonLimit) return EliminationReason.poison;
  }
  if (s.config.has(CounterType.commander) && p.maxCmdDamage >= cmdDamageLethal) return EliminationReason.commander;
  return null;
}

/// Recalcula eliminações e mantém a ordem de eliminação.
GameState _recompute(GameState s) {
  var order = List<String>.of(s.eliminationOrder);
  var changed = false;
  final players = <PlayerState>[];
  for (final p in s.players) {
    final reason = _lethalReason(s, p);
    var np = p;
    if (reason == null) {
      if (p.revived || p.eliminated) {
        np = p.copyWith(revived: false, eliminated: false, clearReason: true);
      }
    } else if (p.revived) {
      np = p.copyWith(eliminated: false, clearReason: true);
    } else if (!p.eliminated || p.eliminatedReason != reason) {
      np = p.copyWith(eliminated: true, eliminatedReason: reason);
    }
    if (np.eliminated && !order.contains(np.id)) {
      order.add(np.id);
      changed = true;
    } else if (!np.eliminated && order.contains(np.id)) {
      order.remove(np.id);
      changed = true;
    }
    if (!identical(np, p)) changed = true;
    players.add(np);
  }
  if (!changed) return s;
  return s.copyWith(players: players, eliminationOrder: order);
}

List<LifeEvent> _log(GameState s, LifeEvent e) {
  final log = s.log;
  if (log.isNotEmpty) {
    final last = log.last;
    if (last.sameStream(e) && e.at.difference(last.at) <= coalesceWindow) {
      final merged = last.merged(e);
      final out = [...log.sublist(0, log.length - 1)];
      if (merged.delta != 0) out.add(merged);
      return out;
    }
  }
  final out = [...log, e];
  return out.length > maxLogEntries ? out.sublist(out.length - maxLogEntries) : out;
}

// ── resultado ─────────────────────────────────────────────────────────────

/// Monta o registro de histórico. Vencedores em primeiro; depois quem foi eliminado por último.
MatchRecord buildRecord(GameState s, {required String id, required DateTime now, required bool finished}) {
  final winners = s.winnerIds.isNotEmpty ? s.winnerIds : (s.lastStanding ?? const <String>[]);
  final placed = <String>[
    ...winners,
    ...[
      for (final p in s.players)
        if (!winners.contains(p.id) && !p.eliminated) p.id,
    ]..sort((a, b) => s.player(b).life.compareTo(s.player(a).life)),
    ...s.eliminationOrder.reversed.where((e) => !winners.contains(e)),
  ];
  final seen = <String>{};
  final rows = <MatchPlayerResult>[];
  var place = 0;
  for (final pid in placed) {
    if (!seen.add(pid)) continue;
    place++;
    final ps = s.player(pid);
    final cfg = s.config.playerById(pid);
    rows.add(
      MatchPlayerResult(
        name: cfg.name,
        color: cfg.color,
        finalLife: ps.life,
        place: winners.contains(pid) ? 1 : place,
        reason: ps.eliminated ? ps.eliminatedReason : null,
        deck: cfg.deck,
      ),
    );
  }
  return MatchRecord(
    id: id,
    formatId: s.config.formatId,
    players: rows,
    winnerNames: [for (final w in winners) s.config.playerById(w).name],
    duration: (s.endedAt ?? now).difference(s.startedAt),
    rounds: s.round,
    endedAt: s.endedAt ?? now,
    finished: finished,
  );
}
