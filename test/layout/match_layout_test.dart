import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/features/match/domain/models.dart';
import 'package:magiccounter/features/match/layout/match_layout.dart';

void main() {
  const sizes = {
    'celular retrato': Size(390, 844),
    'celular paisagem': Size(844, 390),
    'tablet retrato': Size(800, 1280),
    'tablet paisagem': Size(1280, 800),
  };

  for (final e in sizes.entries) {
    for (var n = 1; n <= 4; n++) {
      for (final v in LayoutVariant.values) {
        test('${e.key}, $n jogadores, $v: dentro da tela, sem sobreposição, hub livre', () {
          final g = computeGeometry(players: n, size: e.value, variant: v);
          expect(g.seats.length, n);
          final screen = Offset.zero & e.value;
          for (final s in g.seats) {
            expect(screen.contains(s.rect.topLeft) && screen.contains(s.rect.bottomRight), isTrue, reason: '${s.rect}');
            expect(s.quarterTurns, inInclusiveRange(0, 3));
          }
          for (var i = 0; i < n; i++) {
            for (var j = i + 1; j < n; j++) {
              final inter = g.seats[i].rect.intersect(g.seats[j].rect);
              expect(inter.width <= 0 || inter.height <= 0, isTrue, reason: 'painéis $i e $j se sobrepõem');
            }
          }
        });
      }
    }
  }

  test('4J celular retrato: colunas laterais giradas 90° e 270°; tablet: fileira de cima 180°', () {
    final phone = computeGeometry(players: 4, size: const Size(390, 844), variant: LayoutVariant.standard);
    expect(phone.seats.map((s) => s.quarterTurns), [1, 3, 1, 3]);
    final tablet = computeGeometry(players: 4, size: const Size(1280, 800), variant: LayoutVariant.standard);
    expect(tablet.seats.map((s) => s.quarterTurns), [2, 2, 0, 0]);
  });

  test('2J retrato: jogador 1 embaixo (0), jogador 2 em cima (180°)', () {
    final g = computeGeometry(players: 2, size: const Size(390, 844), variant: LayoutVariant.standard);
    expect(g.seats.map((s) => s.quarterTurns), [0, 2]);
    expect(g.seats[0].rect.top, greaterThan(g.seats[1].rect.top));
  });

  test('safe area: o inset gira junto com o painel', () {
    const notch = (l: 0.0, t: 47.0, r: 0.0, b: 34.0); // entalhe em cima, home indicator embaixo
    expect(rotateInsets(notch, 0), (l: 0.0, t: 47.0, r: 0.0, b: 34.0));
    // painel girado 90° horário: o topo da tela vira a ESQUERDA do painel, a base da tela vira a DIREITA
    expect(rotateInsets(notch, 1), (l: 47.0, t: 0.0, r: 34.0, b: 0.0));
    // 180°: topo vira base
    expect(rotateInsets(notch, 2), (l: 0.0, t: 34.0, r: 0.0, b: 47.0));
    // 270°: topo da tela vira a DIREITA do painel
    expect(rotateInsets(notch, 3), (l: 34.0, t: 0.0, r: 47.0, b: 0.0));
  });

  test('só leva inset o painel que encosta na borda da tela', () {
    const screen = Size(390, 844);
    const pad = (l: 0.0, t: 47.0, r: 0.0, b: 34.0);
    final g = computeGeometry(players: 2, size: screen, variant: LayoutVariant.standard);
    final top = screenInsetsFor(g.seats[1].rect, screen, pad); // painel de cima
    final bottom = screenInsetsFor(g.seats[0].rect, screen, pad);
    expect(top.t, 47.0);
    expect(top.b, 0.0);
    expect(bottom.b, 34.0);
    expect(bottom.t, 0.0);
  });
}
