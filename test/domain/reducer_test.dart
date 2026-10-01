import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/core/providers.dart';
import 'package:magiccounter/core/theme/app_tokens.dart';
import 'package:magiccounter/features/match/domain/actions.dart';
import 'package:magiccounter/features/match/domain/game_controller.dart';
import 'package:magiccounter/features/match/domain/match_storage.dart';
import 'package:magiccounter/features/match/domain/models.dart';
import 'package:magiccounter/features/match/domain/reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final t0 = DateTime(2026, 1, 1, 20);
DateTime at(int ms) => t0.add(Duration(milliseconds: ms));

GameConfig cfg(int n, {Set<CounterType> counters = const {}, int life = 20, List<List<String>>? teams}) => GameConfig(
  formatId: 'custom',
  startingLife: life,
  players: [for (var i = 0; i < n; i++) PlayerConfig(id: 'p$i', name: 'J$i', color: PlayerColor.values[i])],
  enabledCounters: counters,
  teams: teams,
);

GameState start(GameConfig c) => createInitialState(c, now: t0, starterId: 'p0');

void main() {
  group('vida', () {
    test('±1 e vida negativa permitida', () {
      var s = start(cfg(2));
      s = reduce(s, ChangeLife(at(0), 'p0', -1));
      expect(s.player('p0').life, 19);
      s = reduce(s, ChangeLife(at(10), 'p0', -25));
      expect(s.player('p0').life, -6);
      expect(s.player('p0').eliminated, isTrue);
      expect(s.player('p0').eliminatedReason, EliminationReason.life);
    });

    test('cliques seguidos viram um só evento no log', () {
      var s = start(cfg(2));
      for (var i = 0; i < 5; i++) {
        s = reduce(s, ChangeLife(at(i * 200), 'p1', -1));
      }
      expect(s.log.length, 1);
      expect(s.log.single.delta, -5);
      expect(s.log.single.after, 15);
    });

    test('voltar acima do limite desfaz a eliminação', () {
      var s = start(cfg(2));
      s = reduce(s, ChangeLife(at(0), 'p0', -20));
      expect(s.player('p0').eliminated, isTrue);
      s = reduce(s, ChangeLife(at(10), 'p0', 3));
      expect(s.player('p0').eliminated, isFalse);
      expect(s.eliminationOrder, isEmpty);
    });

    test('reviver explícito mantém vivo até sair da condição letal', () {
      var s = start(cfg(2));
      s = reduce(s, ChangeLife(at(0), 'p0', -20));
      s = reduce(s, Revive(at(10), 'p0'));
      expect(s.player('p0').eliminated, isFalse);
      s = reduce(s, ChangeLife(at(20), 'p0', -1));
      expect(s.player('p0').eliminated, isFalse, reason: 'ainda revivido');
      s = reduce(s, ChangeLife(at(30), 'p0', 5));
      s = reduce(s, ChangeLife(at(40), 'p0', -10));
      expect(s.player('p0').eliminated, isTrue, reason: 'saiu da condição letal e voltou');
    });
  });

  group('contadores e comandante', () {
    test('veneno 10 elimina, 9 não', () {
      var s = start(cfg(2, counters: {CounterType.poison}));
      s = reduce(s, ChangeCounter(at(0), 'p1', CounterType.poison, 9));
      expect(s.player('p1').eliminated, isFalse);
      s = reduce(s, ChangeCounter(at(10), 'p1', CounterType.poison, 1));
      expect(s.player('p1').eliminated, isTrue);
      expect(s.player('p1').eliminatedReason, EliminationReason.poison);
    });

    test('contador não fica negativo', () {
      var s = start(cfg(2, counters: {CounterType.energy}));
      s = reduce(s, ChangeCounter(at(0), 'p0', CounterType.energy, -3));
      expect(s.player('p0').counter(CounterType.energy), 0);
    });

    test('comandante 21 elimina e, com opção ligada, tira vida', () {
      var s = start(cfg(3, counters: {CounterType.commander}, life: 40));
      s = reduce(s, ChangeCmdDamage(at(0), 'p1', 'p0', 20));
      expect(s.player('p1').life, 20);
      expect(s.player('p1').eliminated, isFalse);
      s = reduce(s, ChangeCmdDamage(at(10), 'p1', 'p0', 1));
      expect(s.player('p1').eliminated, isTrue);
      expect(s.player('p1').eliminatedReason, EliminationReason.commander);
      s = reduce(s, ChangeCmdDamage(at(20), 'p1', 'p0', -1));
      expect(s.player('p1').life, 20);
      expect(s.player('p1').eliminated, isFalse);
    });

    test('parceiro conta separado: 15 + 15 do mesmo oponente não elimina', () {
      var s = start(cfg(2, counters: {CounterType.commander}, life: 100));
      s = reduce(s, ChangeCmdDamage(at(0), 'p1', 'p0', 15));
      s = reduce(s, ChangeCmdDamage(at(10), 'p1', 'p0', 15, partner: true));
      expect(s.player('p1').eliminated, isFalse);
      s = reduce(s, ChangeCmdDamage(at(20), 'p1', 'p0', 6, partner: true));
      expect(s.player('p1').eliminated, isTrue);
    });

    test('dano de comandante sem afetar a vida', () {
      final c = cfg(2, counters: {CounterType.commander}, life: 40).copyWith(cmdDamageAffectsLife: false);
      var s = start(c);
      s = reduce(s, ChangeCmdDamage(at(0), 'p1', 'p0', 7));
      expect(s.player('p1').life, 40);
    });

    test('monarca é exclusivo', () {
      var s = start(cfg(3, counters: {CounterType.monarch}));
      s = reduce(s, SetMonarch(at(0), 'p0'));
      s = reduce(s, SetMonarch(at(1), 'p2'));
      expect(s.monarchId, 'p2');
    });

    test('anel vai de 0 a 4', () {
      var s = start(cfg(2));
      for (var i = 0; i < 6; i++) {
        s = reduce(s, ChangeRing(at(i), 'p0', 1));
      }
      expect(s.player('p0').ring, 4);
    });
  });

  group('Two-Headed Giant', () {
    final teams = [
      ['p0', 'p1'],
      ['p2', 'p3'],
    ];
    test('vida e veneno compartilhados; veneno letal em 15', () {
      var s = start(cfg(4, life: 30, counters: {CounterType.poison}, teams: teams));
      s = reduce(s, ChangeLife(at(0), 'p0', -5));
      expect(s.player('p1').life, 25);
      expect(s.player('p2').life, 30);
      s = reduce(s, ChangeCounter(at(10), 'p0', CounterType.poison, 14));
      expect(s.player('p1').eliminated, isFalse);
      s = reduce(s, ChangeCounter(at(20), 'p1', CounterType.poison, 1));
      expect(s.player('p0').eliminated, isTrue);
      expect(s.player('p1').eliminated, isTrue);
      expect(s.lastStanding, ['p2', 'p3']);
    });
  });

  group('turno e fim', () {
    test('passar o turno avança e conta a rodada ao dar a volta', () {
      var s = start(cfg(3));
      expect(s.round, 1);
      s = reduce(s, PassTurn(at(0)));
      expect(s.activePlayerId, 'p1');
      s = reduce(s, PassTurn(at(1)));
      expect(s.activePlayerId, 'p2');
      expect(s.round, 1);
      s = reduce(s, PassTurn(at(2)));
      expect(s.activePlayerId, 'p0');
      expect(s.round, 2);
    });

    test('pula eliminados', () {
      var s = start(cfg(3));
      s = reduce(s, ChangeLife(at(0), 'p1', -20));
      s = reduce(s, PassTurn(at(1)));
      expect(s.activePlayerId, 'p2');
    });

    test('último de pé; 1 jogador nunca vence', () {
      var s = start(cfg(3));
      s = reduce(s, ChangeLife(at(0), 'p1', -20));
      expect(s.lastStanding, isNull);
      s = reduce(s, ChangeLife(at(10), 'p2', -20));
      expect(s.lastStanding, ['p0']);
      expect(start(cfg(1)).lastStanding, isNull);
    });

    test('classificação: vencedor, depois quem caiu por último', () {
      var s = start(cfg(3));
      s = reduce(s, ChangeLife(at(0), 'p1', -20));
      s = reduce(s, ChangeLife(at(5000), 'p2', -20));
      s = reduce(s, EndGame(at(6000), ['p0']));
      final r = buildRecord(s, id: 'x', now: at(6000), finished: true);
      expect([for (final p in r.players) p.name], ['J0', 'J2', 'J1']);
      expect(r.players.first.place, 1);
      expect(r.winnerNames, ['J0']);
    });
  });

  group('contadores durante a partida e gráfico solo', () {
    test('ToggleCounter liga e desliga, e desfaz', () {
      var s = start(cfg(2));
      expect(s.config.has(CounterType.poison), isFalse);
      s = reduce(s, ToggleCounter(at(0), CounterType.poison));
      expect(s.config.has(CounterType.poison), isTrue);
      s = reduce(s, ToggleCounter(at(1), CounterType.poison));
      expect(s.config.has(CounterType.poison), isFalse);
    });

    test('lifeByRound: vida ao fim de cada rodada e a atual por último', () {
      var s = start(cfg(1, life: 20));
      s = reduce(s, ChangeLife(at(0), 'p0', -2)); // rodada 1: 18
      s = reduce(s, PassTurn(at(5000))); // rodada 2
      s = reduce(s, ChangeLife(at(10000), 'p0', -3)); // 15
      s = reduce(s, PassTurn(at(15000))); // rodada 3, sem mudança
      expect(lifeByRound(s, 'p0'), [18, 15, 15]);
      s = reduce(s, ChangeLife(at(20000), 'p0', 5));
      expect(lifeByRound(s, 'p0'), [18, 15, 20]);
    });

    test('mudanças de rodadas diferentes nunca se juntam no log (nem em menos de 2 s)', () {
      var s = start(cfg(1, life: 20));
      s = reduce(s, ChangeLife(at(0), 'p0', -5));
      s = reduce(s, PassTurn(at(100)));
      s = reduce(s, ChangeLife(at(200), 'p0', 5));
      expect(s.log.length, 2);
      expect(lifeByRound(s, 'p0'), [15, 20]);
    });

    test('solo: passar o turno conta a rodada', () {
      var s = start(cfg(1));
      s = reduce(s, PassTurn(at(0)));
      expect(s.round, 2);
    });
  });

  group('persistência', () {
    test('JSON ida e volta preserva o estado', () {
      var s = start(cfg(4, counters: {CounterType.commander, CounterType.poison}, life: 40));
      s = reduce(s, ChangeLife(at(0), 'p0', -4));
      s = reduce(s, ChangeCmdDamage(at(10), 'p1', 'p0', 5, partner: true));
      s = reduce(s, ChangeCounter(at(20), 'p2', CounterType.poison, 3));
      s = reduce(s, SetDayNight(at(30), DayNight.night));
      s = reduce(s, PassTurn(at(40)));
      final back = GameState.fromJson(jsonDecode(jsonEncode(s.toJson())) as Map<String, dynamic>);
      expect(jsonEncode(back.toJson()), jsonEncode(s.toJson()));
    });
  });

  group('MatchController', () {
    late ProviderContainer c;
    late MemoryMatchStorage storage;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storage = MemoryMatchStorage();
      c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
          matchStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(c.dispose);
      c.read(matchControllerProvider.notifier).seedRandom(Random(1));
    });

    test('desfazer reverte um gesto inteiro (vários toques) de uma vez', () {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2));
      for (var i = 0; i < 6; i++) {
        m.dispatch(ChangeLife(at(i * 150), 'p0', -1));
      }
      expect(c.read(matchControllerProvider).game!.player('p0').life, 14);
      expect(c.read(matchControllerProvider).undoCount, 1);
      m.undo();
      expect(c.read(matchControllerProvider).game!.player('p0').life, 20);
      expect(c.read(matchControllerProvider).canUndo, isFalse);
    });

    test('pausa de mais de 2 s separa as entradas do desfazer', () {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2));
      m.dispatch(ChangeLife(at(0), 'p0', -1));
      m.dispatch(ChangeLife(at(5000), 'p0', -1));
      expect(c.read(matchControllerProvider).undoCount, 2);
      m.undo();
      expect(c.read(matchControllerProvider).game!.player('p0').life, 19);
    });

    test('desfazer reverte eliminação, vida e dano de comandante juntos', () {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2, counters: {CounterType.commander}, life: 40));
      m.dispatch(ChangeCmdDamage(at(0), 'p1', 'p0', 21));
      expect(c.read(matchControllerProvider).game!.player('p1').eliminated, isTrue);
      m.undo();
      final p = c.read(matchControllerProvider).game!.player('p1');
      expect(p.eliminated, isFalse);
      expect(p.life, 40);
      expect(p.cmdDamage, isEmpty);
    });

    test('limite de 200 entradas', () {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2));
      for (var i = 0; i < 260; i++) {
        m.dispatch(ChangeLife(at(i * 10000), 'p0', -1));
      }
      expect(c.read(matchControllerProvider).undoCount, maxUndo);
    });

    test('partida salva é restaurada depois de matar o app', () async {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2));
      m.dispatch(ChangeLife(at(0), 'p1', -7));
      await m.flush();
      final saved = storage.current!;
      expect(saved.player('p1').life, 13);

      final c2 = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
          matchStorageProvider.overrideWithValue(storage),
          initialMatchProvider.overrideWithValue(await storage.loadCurrent()),
        ],
      );
      addTearDown(c2.dispose);
      expect(c2.read(matchControllerProvider).game!.player('p1').life, 13);
    });

    test('terminar grava no histórico e limpa a partida salva', () async {
      final m = c.read(matchControllerProvider.notifier);
      m.start(cfg(2));
      m.dispatch(ChangeLife(at(0), 'p1', -20));
      final r = m.finish(['p0']);
      await m.flush();
      expect(r.winnerNames, ['J0']);
      expect(c.read(historyProvider).length, 1);
      expect(storage.current, isNull);
    });

    test('histórico grátis guarda só 20', () async {
      final m = c.read(matchControllerProvider.notifier);
      for (var i = 0; i < 23; i++) {
        m.start(cfg(2));
        m.finish(['p0'], now: at(i * 100000));
      }
      expect(c.read(historyProvider).length, 20);
    });
  });
}
