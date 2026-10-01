import 'models.dart';

/// Toda mudança do estado da partida é uma ação. O reducer é puro; `at` vem de fora.
sealed class GameAction {
  const GameAction(this.at);
  final DateTime at;

  /// Ações com a mesma tag em até [coalesceWindow] viram uma só entrada no desfazer
  /// (segurar o botão, arrastar, vários toques seguidos).
  String? get undoTag => null;
}

const coalesceWindow = Duration(milliseconds: 2000);

class ChangeLife extends GameAction {
  const ChangeLife(super.at, this.playerId, this.delta);
  final String playerId;
  final int delta;
  @override
  String? get undoTag => 'life:$playerId';
}

class SetLife extends GameAction {
  const SetLife(super.at, this.playerId, this.value);
  final String playerId;
  final int value;
}

class ChangeCounter extends GameAction {
  const ChangeCounter(super.at, this.playerId, this.type, this.delta);
  final String playerId;
  final CounterType type;
  final int delta;
  @override
  String? get undoTag => 'counter:$playerId:${type.name}';
}

/// Dano de comandante recebido por [playerId] vindo de [sourceId].
class ChangeCmdDamage extends GameAction {
  const ChangeCmdDamage(super.at, this.playerId, this.sourceId, this.delta, {this.partner = false});
  final String playerId;
  final String sourceId;
  final int delta;
  final bool partner;
  @override
  String? get undoTag => 'cmd:$playerId:$sourceId:$partner';
}

/// Taxa de comandante: conjurações do próprio comandante.
class ChangeCastCount extends GameAction {
  const ChangeCastCount(super.at, this.playerId, this.delta, {this.partner = false});
  final String playerId;
  final int delta;
  final bool partner;
  @override
  String? get undoTag => 'cast:$playerId:$partner';
}

/// Dar o monarca a [playerId] (null limpa).
class SetMonarch extends GameAction {
  const SetMonarch(super.at, this.playerId);
  final String? playerId;
}

class SetInitiative extends GameAction {
  const SetInitiative(super.at, this.playerId);
  final String? playerId;
}

class SetDayNight extends GameAction {
  const SetDayNight(super.at, this.value);
  final DayNight? value;
}

class ChangeRing extends GameAction {
  const ChangeRing(super.at, this.playerId, this.delta);
  final String playerId;
  final int delta;
}

class PassTurn extends GameAction {
  const PassTurn(super.at);
}

class SetActive extends GameAction {
  const SetActive(super.at, this.playerId);
  final String playerId;
}

/// Reviver explícito (toque longo no selo ELIMINADO).
class Revive extends GameAction {
  const Revive(super.at, this.playerId);
  final String playerId;
}

class EndGame extends GameAction {
  const EndGame(super.at, this.winnerIds);
  final List<String> winnerIds;
}

class ResumeGame extends GameAction {
  const ResumeGame(super.at);
}
