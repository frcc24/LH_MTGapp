import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/core/theme/app_theme.dart';
import 'package:magiccounter/core/theme/app_tokens.dart';
import 'package:magiccounter/features/match/domain/models.dart';
import 'package:magiccounter/features/match/domain/reducer.dart';
import 'package:magiccounter/features/match/widgets/player_panel.dart';
import 'package:magiccounter/l10n/app_localizations.dart';

GameState _game() => createInitialState(
  GameConfig(
    formatId: 'standard',
    startingLife: 20,
    players: const [
      PlayerConfig(id: 'a', name: 'Ana', color: PlayerColor.amber),
      PlayerConfig(id: 'b', name: 'Bruno', color: PlayerColor.cyan),
    ],
  ),
  now: DateTime(2026),
);

Future<List<int>> _pump(WidgetTester t, {int quarterTurns = 0, Size size = const Size(400, 500)}) async {
  final calls = <int>[];
  final g = _game();
  await t.pumpWidget(
    MaterialApp(
      theme: buildAppTheme(),
      locale: const Locale('pt'),
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: RotatedBox(
              quarterTurns: quarterTurns,
              child: PlayerPanel(
                player: g.config.players.first,
                state: g.players.first,
                game: g,
                onLife: calls.add,
                onOpenDrawer: (_) {},
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await t.pump();
  return calls;
}

void main() {
  testWidgets('toque na metade direita soma 1 e na esquerda tira 1', (t) async {
    final calls = await _pump(t);
    final box = t.getRect(find.byType(PlayerPanel));
    await t.tapAt(Offset(box.right - 40, box.top + 60));
    await t.tapAt(Offset(box.left + 40, box.top + 60));
    expect(calls, [1, -1]);
  });

  testWidgets('painel girado 180°: a metade direita para o jogador é a esquerda da tela', (t) async {
    final calls = await _pump(t, quarterTurns: 2);
    final box = t.getRect(find.byType(PlayerPanel));
    await t.tapAt(Offset(box.left + 40, box.top + 60)); // esquerda da tela = direita do jogador
    expect(calls, [1]);
    await t.tapAt(Offset(box.right - 40, box.top + 60));
    expect(calls, [1, -1]);
  });

  testWidgets('painel girado 90°: direita do jogador é a parte de baixo da tela', (t) async {
    final calls = await _pump(t, quarterTurns: 1, size: const Size(300, 600));
    final box = t.getRect(find.byType(PlayerPanel));
    await t.tapAt(Offset(box.center.dx - 60, box.bottom - 40));
    expect(calls, [1]);
    await t.tapAt(Offset(box.center.dx - 60, box.top + 40));
    expect(calls, [1, -1]);
  });

  testWidgets('segurar repete: perto de 450 ms começa e acelera', (t) async {
    final calls = await _pump(t);
    final box = t.getRect(find.byType(PlayerPanel));
    final g = await t.startGesture(Offset(box.right - 40, box.top + 60));
    await t.pump(const Duration(milliseconds: 440));
    expect(calls, isEmpty, reason: 'antes dos 450 ms não repete');
    await t.pump(const Duration(milliseconds: 40));
    final first = calls.length;
    expect(first, 1);
    await t.pump(const Duration(milliseconds: 130));
    expect(calls.length, greaterThan(first));
    await g.up();
    final after = calls.length;
    await t.pump(const Duration(milliseconds: 400));
    expect(calls.length, after, reason: 'soltar para de repetir');
    expect(calls.every((c) => c == 1), isTrue);
  });

  testWidgets('arrastar para cima 120 pt aplica +10 ao soltar; voltar ao início cancela', (t) async {
    final calls = await _pump(t);
    final box = t.getRect(find.byType(PlayerPanel));
    final start = Offset(box.center.dx, box.center.dy + 40);
    final g = await t.startGesture(start);
    await g.moveBy(const Offset(0, -30)); // passa do limite de toque: o arraste começa aqui
    await g.moveBy(const Offset(0, -120));
    await t.pump();
    await g.up();
    await t.pump();
    expect(calls, [10]);

    final g2 = await t.startGesture(start);
    await g2.moveBy(const Offset(0, 30));
    await g2.moveBy(const Offset(0, 120));
    await g2.moveBy(const Offset(0, -150)); // volta ao ponto de partida
    await g2.up();
    await t.pump();
    expect(calls, [10], reason: 'voltar ao ponto inicial cancela');
  });
}
