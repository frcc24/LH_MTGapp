import '../../../core/theme/app_tokens.dart';

/// Contadores que a partida pode exibir. `commander` liga o dano de comandante e a taxa.
enum CounterType {
  poison,
  energy,
  experience,
  radiation,
  commander,
  monarch,
  initiative,
  ring,
  dayNight;

  /// Contadores numéricos simples, por jogador, com −/valor/+.
  bool get isValueCounter => switch (this) {
    poison || energy || experience || radiation => true,
    _ => false,
  };

  static CounterType? tryParse(String? s) {
    for (final v in values) {
      if (v.name == s) return v;
    }
    return null;
  }
}

enum StarterMode { random, chosen }

enum LayoutVariant {
  /// 3J: duas em cima e uma embaixo; 4J (celular): colunas laterais.
  standard,

  /// 4J: fileira de cima girada 180°.
  alternate,
}

enum DayNight { day, night }

enum EliminationReason { life, poison, commander }

enum LifeEventKind { life, counter, cmd, status }

/// Dados de configuração de um jogador (antes e durante a partida).
class PlayerConfig {
  const PlayerConfig({required this.id, required this.name, required this.color, this.deck, this.seatQuarterTurns});

  final String id;
  final String name;
  final PlayerColor color;
  final String? deck;
  final int? seatQuarterTurns;

  PlayerConfig copyWith({
    String? name,
    PlayerColor? color,
    String? deck,
    bool clearDeck = false,
    int? seatQuarterTurns,
  }) => PlayerConfig(
    id: id,
    name: name ?? this.name,
    color: color ?? this.color,
    deck: clearDeck ? null : (deck ?? this.deck),
    seatQuarterTurns: seatQuarterTurns ?? this.seatQuarterTurns,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color.name,
    if (deck != null) 'deck': deck,
    if (seatQuarterTurns != null) 'seatQuarterTurns': seatQuarterTurns,
  };

  factory PlayerConfig.fromJson(Map<String, dynamic> j) => PlayerConfig(
    id: j['id'] as String,
    name: j['name'] as String,
    color: PlayerColor.values.byName(j['color'] as String),
    deck: j['deck'] as String?,
    seatQuarterTurns: j['seatQuarterTurns'] as int?,
  );
}

class GameConfig {
  const GameConfig({
    required this.formatId,
    required this.startingLife,
    required this.players,
    this.enabledCounters = const {},
    this.teams,
    this.turnTimerSeconds,
    this.starter = StarterMode.random,
    this.starterId,
    this.cmdDamageAffectsLife = true,
    this.layoutVariant = LayoutVariant.standard,
  });

  final String formatId;
  final int startingLife;
  final List<PlayerConfig> players;
  final Set<CounterType> enabledCounters;

  /// Times (ids dos jogadores). Quando preenchido, vida e veneno são compartilhados por time.
  final List<List<String>>? teams;
  final int? turnTimerSeconds;
  final StarterMode starter;
  final String? starterId;
  final bool cmdDamageAffectsLife;
  final LayoutVariant layoutVariant;

  bool get hasTeams => teams != null && teams!.isNotEmpty;
  bool has(CounterType t) => enabledCounters.contains(t);

  /// Limite de veneno letal: 15 no Two-Headed Giant, 10 no resto.
  int get poisonLimit => hasTeams ? 15 : 10;

  PlayerConfig playerById(String id) => players.firstWhere((p) => p.id == id);

  List<String>? teamOf(String playerId) {
    if (!hasTeams) return null;
    for (final t in teams!) {
      if (t.contains(playerId)) return t;
    }
    return null;
  }

  GameConfig copyWith({
    String? formatId,
    int? startingLife,
    List<PlayerConfig>? players,
    Set<CounterType>? enabledCounters,
    List<List<String>>? teams,
    bool clearTeams = false,
    int? turnTimerSeconds,
    bool clearTimer = false,
    StarterMode? starter,
    String? starterId,
    bool? cmdDamageAffectsLife,
    LayoutVariant? layoutVariant,
  }) => GameConfig(
    formatId: formatId ?? this.formatId,
    startingLife: startingLife ?? this.startingLife,
    players: players ?? this.players,
    enabledCounters: enabledCounters ?? this.enabledCounters,
    teams: clearTeams ? null : (teams ?? this.teams),
    turnTimerSeconds: clearTimer ? null : (turnTimerSeconds ?? this.turnTimerSeconds),
    starter: starter ?? this.starter,
    starterId: starterId ?? this.starterId,
    cmdDamageAffectsLife: cmdDamageAffectsLife ?? this.cmdDamageAffectsLife,
    layoutVariant: layoutVariant ?? this.layoutVariant,
  );

  Map<String, dynamic> toJson() => {
    'formatId': formatId,
    'startingLife': startingLife,
    'players': [for (final p in players) p.toJson()],
    'enabledCounters': [for (final c in enabledCounters) c.name],
    if (teams != null) 'teams': teams,
    if (turnTimerSeconds != null) 'turnTimerSeconds': turnTimerSeconds,
    'starter': starter.name,
    if (starterId != null) 'starterId': starterId,
    'cmdDamageAffectsLife': cmdDamageAffectsLife,
    'layoutVariant': layoutVariant.name,
  };

  factory GameConfig.fromJson(Map<String, dynamic> j) => GameConfig(
    formatId: j['formatId'] as String,
    startingLife: j['startingLife'] as int,
    players: [for (final p in (j['players'] as List)) PlayerConfig.fromJson(Map<String, dynamic>.from(p as Map))],
    enabledCounters: {
      for (final c in (j['enabledCounters'] as List? ?? const []))
        if (CounterType.tryParse(c as String) != null) CounterType.tryParse(c)!,
    },
    teams: (j['teams'] as List?)?.map((t) => [for (final id in (t as List)) id as String]).toList(),
    turnTimerSeconds: j['turnTimerSeconds'] as int?,
    starter: StarterMode.values.byName((j['starter'] as String?) ?? 'random'),
    starterId: j['starterId'] as String?,
    cmdDamageAffectsLife: (j['cmdDamageAffectsLife'] as bool?) ?? true,
    layoutVariant: LayoutVariant.values.byName((j['layoutVariant'] as String?) ?? 'standard'),
  );
}

/// Dano de comandante recebido de um oponente (comandante principal e parceiro).
class CmdDamage {
  const CmdDamage({this.main = 0, this.partner = 0});
  final int main;
  final int partner;

  CmdDamage copyWith({int? main, int? partner}) => CmdDamage(main: main ?? this.main, partner: partner ?? this.partner);
  int get max => main > partner ? main : partner;

  Map<String, dynamic> toJson() => {'main': main, 'partner': partner};
  factory CmdDamage.fromJson(Map<String, dynamic> j) =>
      CmdDamage(main: j['main'] as int? ?? 0, partner: j['partner'] as int? ?? 0);
}

class PlayerState {
  const PlayerState({
    required this.id,
    required this.life,
    this.counters = const {},
    this.cmdDamage = const {},
    this.castCount = 0,
    this.castCountPartner = 0,
    this.eliminated = false,
    this.eliminatedReason,
    this.revived = false,
    this.ring = 0,
  });

  final String id;
  final int life;
  final Map<CounterType, int> counters;

  /// Dano de comandante recebido, por id do oponente.
  final Map<String, CmdDamage> cmdDamage;
  final int castCount;
  final int castCountPartner;
  final bool eliminated;
  final EliminationReason? eliminatedReason;

  /// Revivido à mão: ignora a condição letal até ela deixar de valer.
  final bool revived;

  /// Tentação do Anel, 0 a 4.
  final int ring;

  int counter(CounterType t) => counters[t] ?? 0;
  int get poison => counter(CounterType.poison);

  /// Maior dano de comandante recebido de um único comandante.
  int get maxCmdDamage {
    var m = 0;
    for (final d in cmdDamage.values) {
      if (d.max > m) m = d.max;
    }
    return m;
  }

  PlayerState copyWith({
    int? life,
    Map<CounterType, int>? counters,
    Map<String, CmdDamage>? cmdDamage,
    int? castCount,
    int? castCountPartner,
    bool? eliminated,
    EliminationReason? eliminatedReason,
    bool clearReason = false,
    bool? revived,
    int? ring,
  }) => PlayerState(
    id: id,
    life: life ?? this.life,
    counters: counters ?? this.counters,
    cmdDamage: cmdDamage ?? this.cmdDamage,
    castCount: castCount ?? this.castCount,
    castCountPartner: castCountPartner ?? this.castCountPartner,
    eliminated: eliminated ?? this.eliminated,
    eliminatedReason: clearReason ? null : (eliminatedReason ?? this.eliminatedReason),
    revived: revived ?? this.revived,
    ring: ring ?? this.ring,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'life': life,
    'counters': {for (final e in counters.entries) e.key.name: e.value},
    'cmdDamage': {for (final e in cmdDamage.entries) e.key: e.value.toJson()},
    'castCount': castCount,
    'castCountPartner': castCountPartner,
    'eliminated': eliminated,
    if (eliminatedReason != null) 'eliminatedReason': eliminatedReason!.name,
    'revived': revived,
    'ring': ring,
  };

  factory PlayerState.fromJson(Map<String, dynamic> j) => PlayerState(
    id: j['id'] as String,
    life: j['life'] as int,
    counters: {
      for (final e in (j['counters'] as Map? ?? const {}).entries)
        if (CounterType.tryParse(e.key as String) != null) CounterType.tryParse(e.key as String)!: e.value as int,
    },
    cmdDamage: {
      for (final e in (j['cmdDamage'] as Map? ?? const {}).entries)
        e.key as String: CmdDamage.fromJson(Map<String, dynamic>.from(e.value as Map)),
    },
    castCount: j['castCount'] as int? ?? 0,
    castCountPartner: j['castCountPartner'] as int? ?? 0,
    eliminated: j['eliminated'] as bool? ?? false,
    eliminatedReason: j['eliminatedReason'] == null
        ? null
        : EliminationReason.values.byName(j['eliminatedReason'] as String),
    revived: j['revived'] as bool? ?? false,
    ring: j['ring'] as int? ?? 0,
  );
}

class LifeEvent {
  const LifeEvent({
    required this.at,
    required this.round,
    required this.playerId,
    required this.kind,
    required this.delta,
    required this.after,
    this.counter,
    this.sourceId,
  });

  final DateTime at;
  final int round;
  final String playerId;
  final LifeEventKind kind;
  final int delta;

  /// Valor resultante (vida, contador ou dano de comandante acumulado).
  final int after;
  final CounterType? counter;
  final String? sourceId;

  bool sameStream(LifeEvent o) =>
      playerId == o.playerId && kind == o.kind && counter == o.counter && sourceId == o.sourceId;

  LifeEvent merged(LifeEvent next) => LifeEvent(
    at: next.at,
    round: next.round,
    playerId: playerId,
    kind: kind,
    delta: delta + next.delta,
    after: next.after,
    counter: counter,
    sourceId: sourceId,
  );

  Map<String, dynamic> toJson() => {
    'at': at.millisecondsSinceEpoch,
    'round': round,
    'playerId': playerId,
    'kind': kind.name,
    'delta': delta,
    'after': after,
    if (counter != null) 'counter': counter!.name,
    if (sourceId != null) 'sourceId': sourceId,
  };

  factory LifeEvent.fromJson(Map<String, dynamic> j) => LifeEvent(
    at: DateTime.fromMillisecondsSinceEpoch(j['at'] as int),
    round: j['round'] as int,
    playerId: j['playerId'] as String,
    kind: LifeEventKind.values.byName(j['kind'] as String),
    delta: j['delta'] as int,
    after: j['after'] as int,
    counter: CounterType.tryParse(j['counter'] as String?),
    sourceId: j['sourceId'] as String?,
  );
}

class GameState {
  const GameState({
    required this.config,
    required this.players,
    required this.activePlayerId,
    required this.startedAt,
    this.round = 1,
    this.paused = false,
    this.dayNight,
    this.monarchId,
    this.initiativeId,
    this.eliminationOrder = const [],
    this.log = const [],
    this.endedAt,
    this.winnerIds = const [],
    this.turnCount = 0,
  });

  final GameConfig config;
  final List<PlayerState> players;
  final String activePlayerId;
  final int round;

  /// Turnos já passados (usado para saber se o jogo realmente começou).
  final int turnCount;
  final bool paused;
  final DayNight? dayNight;
  final String? monarchId;
  final String? initiativeId;

  /// Ids na ordem em que foram eliminados (o primeiro eliminado vem primeiro).
  final List<String> eliminationOrder;
  final List<LifeEvent> log;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<String> winnerIds;

  bool get finished => endedAt != null;

  PlayerState player(String id) => players.firstWhere((p) => p.id == id);

  /// Ids ainda vivos (times contam como vivos se algum membro não foi eliminado).
  List<String> get aliveIds => [
    for (final p in players)
      if (!p.eliminated) p.id,
  ];

  /// Quando sobra exatamente um jogador (ou um time) vivo, devolve os ids vencedores; senão, null.
  List<String>? get lastStanding {
    final alive = aliveIds;
    if (players.length < 2) return null;
    if (alive.isEmpty) return null;
    if (config.hasTeams) {
      final aliveTeams = <int>{};
      for (final id in alive) {
        final idx = config.teams!.indexWhere((t) => t.contains(id));
        aliveTeams.add(idx);
      }
      if (aliveTeams.length == 1) return List.of(config.teams![aliveTeams.first]);
      return null;
    }
    return alive.length == 1 ? alive : null;
  }

  GameState copyWith({
    List<PlayerState>? players,
    String? activePlayerId,
    int? round,
    int? turnCount,
    bool? paused,
    DayNight? dayNight,
    bool clearDayNight = false,
    String? monarchId,
    bool clearMonarch = false,
    String? initiativeId,
    bool clearInitiative = false,
    List<String>? eliminationOrder,
    List<LifeEvent>? log,
    DateTime? endedAt,
    bool clearEnded = false,
    List<String>? winnerIds,
  }) => GameState(
    config: config,
    players: players ?? this.players,
    activePlayerId: activePlayerId ?? this.activePlayerId,
    startedAt: startedAt,
    round: round ?? this.round,
    turnCount: turnCount ?? this.turnCount,
    paused: paused ?? this.paused,
    dayNight: clearDayNight ? null : (dayNight ?? this.dayNight),
    monarchId: clearMonarch ? null : (monarchId ?? this.monarchId),
    initiativeId: clearInitiative ? null : (initiativeId ?? this.initiativeId),
    eliminationOrder: eliminationOrder ?? this.eliminationOrder,
    log: log ?? this.log,
    endedAt: clearEnded ? null : (endedAt ?? this.endedAt),
    winnerIds: winnerIds ?? this.winnerIds,
  );

  Map<String, dynamic> toJson() => {
    'config': config.toJson(),
    'players': [for (final p in players) p.toJson()],
    'activePlayerId': activePlayerId,
    'round': round,
    'turnCount': turnCount,
    'paused': paused,
    if (dayNight != null) 'dayNight': dayNight!.name,
    if (monarchId != null) 'monarchId': monarchId,
    if (initiativeId != null) 'initiativeId': initiativeId,
    'eliminationOrder': eliminationOrder,
    'log': [for (final e in log) e.toJson()],
    'startedAt': startedAt.millisecondsSinceEpoch,
    if (endedAt != null) 'endedAt': endedAt!.millisecondsSinceEpoch,
    'winnerIds': winnerIds,
  };

  factory GameState.fromJson(Map<String, dynamic> j) => GameState(
    config: GameConfig.fromJson(Map<String, dynamic>.from(j['config'] as Map)),
    players: [for (final p in (j['players'] as List)) PlayerState.fromJson(Map<String, dynamic>.from(p as Map))],
    activePlayerId: j['activePlayerId'] as String,
    round: j['round'] as int? ?? 1,
    turnCount: j['turnCount'] as int? ?? 0,
    paused: j['paused'] as bool? ?? false,
    dayNight: j['dayNight'] == null ? null : DayNight.values.byName(j['dayNight'] as String),
    monarchId: j['monarchId'] as String?,
    initiativeId: j['initiativeId'] as String?,
    eliminationOrder: [for (final id in (j['eliminationOrder'] as List? ?? const [])) id as String],
    log: [for (final e in (j['log'] as List? ?? const [])) LifeEvent.fromJson(Map<String, dynamic>.from(e as Map))],
    startedAt: DateTime.fromMillisecondsSinceEpoch(j['startedAt'] as int),
    endedAt: j['endedAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(j['endedAt'] as int),
    winnerIds: [for (final id in (j['winnerIds'] as List? ?? const [])) id as String],
  );
}

/// Linha do resultado de uma partida terminada.
class MatchPlayerResult {
  const MatchPlayerResult({
    required this.name,
    required this.color,
    required this.finalLife,
    required this.place,
    this.reason,
    this.deck,
  });

  final String name;
  final PlayerColor color;
  final int finalLife;
  final int place;
  final EliminationReason? reason;
  final String? deck;

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color.name,
    'finalLife': finalLife,
    'place': place,
    if (reason != null) 'reason': reason!.name,
    if (deck != null) 'deck': deck,
  };

  factory MatchPlayerResult.fromJson(Map<String, dynamic> j) => MatchPlayerResult(
    name: j['name'] as String,
    color: PlayerColor.values.byName(j['color'] as String),
    finalLife: j['finalLife'] as int,
    place: j['place'] as int,
    reason: j['reason'] == null ? null : EliminationReason.values.byName(j['reason'] as String),
    deck: j['deck'] as String?,
  );
}

class MatchRecord {
  const MatchRecord({
    required this.id,
    required this.formatId,
    required this.players,
    required this.winnerNames,
    required this.duration,
    required this.rounds,
    required this.endedAt,
    required this.finished,
  });

  final String id;
  final String formatId;
  final List<MatchPlayerResult> players;
  final List<String> winnerNames;
  final Duration duration;
  final int rounds;
  final DateTime endedAt;
  final bool finished;

  Map<String, dynamic> toJson() => {
    'id': id,
    'formatId': formatId,
    'players': [for (final p in players) p.toJson()],
    'winnerNames': winnerNames,
    'duration': duration.inSeconds,
    'rounds': rounds,
    'endedAt': endedAt.millisecondsSinceEpoch,
    'finished': finished,
  };

  factory MatchRecord.fromJson(Map<String, dynamic> j) => MatchRecord(
    id: j['id'] as String,
    formatId: j['formatId'] as String,
    players: [for (final p in (j['players'] as List)) MatchPlayerResult.fromJson(Map<String, dynamic>.from(p as Map))],
    winnerNames: [for (final n in (j['winnerNames'] as List? ?? const [])) n as String],
    duration: Duration(seconds: j['duration'] as int),
    rounds: j['rounds'] as int,
    endedAt: DateTime.fromMillisecondsSinceEpoch(j['endedAt'] as int),
    finished: j['finished'] as bool? ?? true,
  );
}

/// Jogador salvo para reaproveitar entre partidas.
class SavedPlayer {
  const SavedPlayer({required this.id, required this.name, required this.color, this.defaultDeck});
  final String id;
  final String name;
  final PlayerColor color;
  final String? defaultDeck;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color.name,
    if (defaultDeck != null) 'defaultDeck': defaultDeck,
  };
  factory SavedPlayer.fromJson(Map<String, dynamic> j) => SavedPlayer(
    id: j['id'] as String,
    name: j['name'] as String,
    color: PlayerColor.values.byName(j['color'] as String),
    defaultDeck: j['defaultDeck'] as String?,
  );
}
