import 'dart:ui';

import '../domain/models.dart';

/// Onde um jogador senta: retângulo + quartos de volta (0, 1, 2, 3 no sentido horário).
class Seat {
  const Seat(this.rect, this.quarterTurns, this.radius);
  final Rect rect;
  final int quarterTurns;
  final double radius;
}

/// Como montar a tela: assentos, faixa central (1–2 jogadores) ou hub (3–4).
class MatchGeometry {
  const MatchGeometry({
    required this.seats,
    required this.hubCenter,
    required this.hubSize,
    this.strip,
    this.stripVertical = false,
  });
  final List<Seat> seats;
  final Offset hubCenter;
  final double hubSize;

  /// Faixa de controles entre os painéis (1–2 jogadores).
  final Rect? strip;
  final bool stripVertical;
}

/// Motor único: (jogadores, tamanho, variante, times) -> geometria. Nada de telas por aparelho.
MatchGeometry computeGeometry({
  required int players,
  required Size size,
  required LayoutVariant variant,
  bool teams = false,
}) {
  final tablet = size.shortestSide >= 600;
  final pad = tablet ? 16.0 : 8.0;
  final gap = tablet ? 12.0 : 8.0;
  final hub = tablet ? 88.0 : 76.0;
  final landscape = size.width > size.height;
  final area = Rect.fromLTWH(pad, pad, size.width - 2 * pad, size.height - 2 * pad);
  final r2 = tablet ? 32.0 : 28.0;
  final r4 = tablet ? 32.0 : 24.0;
  const stripExtent = 72.0;

  switch (players) {
    case 1:
      if (landscape) {
        final w = area.width - stripExtent - gap;
        return MatchGeometry(
          seats: [Seat(Rect.fromLTWH(area.left, area.top, w, area.height), 0, r2)],
          hubCenter: Offset(area.right - stripExtent / 2, area.center.dy),
          hubSize: hub,
          strip: Rect.fromLTWH(area.right - stripExtent, area.top, stripExtent, area.height),
          stripVertical: true,
        );
      }
      final h = area.height - stripExtent - gap;
      return MatchGeometry(
        seats: [Seat(Rect.fromLTWH(area.left, area.top, area.width, h), 0, r2)],
        hubCenter: Offset(area.center.dx, area.bottom - stripExtent / 2),
        hubSize: hub,
        strip: Rect.fromLTWH(area.left, area.bottom - stripExtent, area.width, stripExtent),
      );

    case 2:
      if (landscape) {
        final w = (area.width - stripExtent - 2 * gap) / 2;
        final left = Rect.fromLTWH(area.left, area.top, w, area.height);
        final right = Rect.fromLTWH(area.right - w, area.top, w, area.height);
        final strip = Rect.fromLTWH(left.right + gap, area.top, stripExtent, area.height);
        return MatchGeometry(
          // p0 à esquerda (qt1), p1 à direita (qt3)
          seats: [Seat(left, 1, r2), Seat(right, 3, r2)],
          hubCenter: strip.center,
          hubSize: hub,
          strip: strip,
          stripVertical: true,
        );
      }
      final h = (area.height - stripExtent - 2 * gap) / 2;
      final top = Rect.fromLTWH(area.left, area.top, area.width, h);
      final bottom = Rect.fromLTWH(area.left, area.bottom - h, area.width, h);
      final strip = Rect.fromLTWH(area.left, top.bottom + gap, area.width, stripExtent);
      // p0 embaixo (qt0), p1 em cima (qt2)
      return MatchGeometry(
        seats: [Seat(bottom, 0, r2), Seat(top, 2, r2)],
        hubCenter: strip.center,
        hubSize: hub,
        strip: strip,
      );

    case 3:
      return landscape ? _three(area, gap, hub, r4, landscape: true) : _three(area, gap, hub, r4, landscape: false);

    default:
      final flipTop = tablet || landscape || variant == LayoutVariant.alternate;
      final w = (area.width - gap) / 2;
      final h = (area.height - gap) / 2;
      final tl = Rect.fromLTWH(area.left, area.top, w, h);
      final tr = Rect.fromLTWH(area.left + w + gap, area.top, w, h);
      final bl = Rect.fromLTWH(area.left, area.top + h + gap, w, h);
      final br = Rect.fromLTWH(area.left + w + gap, area.top + h + gap, w, h);
      final List<Seat> seats;
      if (flipTop) {
        // linha de cima virada 180°, de baixo normal. Ordem por linha (times = linhas).
        seats = [Seat(tl, 2, r4), Seat(tr, 2, r4), Seat(bl, 0, r4), Seat(br, 0, r4)];
      } else if (teams) {
        // colunas laterais; times = colunas (colegas do mesmo lado)
        seats = [Seat(tl, 1, r4), Seat(bl, 1, r4), Seat(tr, 3, r4), Seat(br, 3, r4)];
      } else {
        seats = [Seat(tl, 1, r4), Seat(tr, 3, r4), Seat(bl, 1, r4), Seat(br, 3, r4)];
      }
      return MatchGeometry(seats: seats, hubCenter: area.center, hubSize: hub);
  }
}

MatchGeometry _three(Rect area, double gap, double hub, double r, {required bool landscape}) {
  if (!landscape) {
    final topH = (area.height - gap) * 0.56;
    final w = (area.width - gap) / 2;
    final tl = Rect.fromLTWH(area.left, area.top, w, topH);
    final tr = Rect.fromLTWH(area.left + w + gap, area.top, w, topH);
    final bottom = Rect.fromLTWH(area.left, area.top + topH + gap, area.width, area.height - topH - gap);
    return MatchGeometry(
      seats: [Seat(tl, 1, r), Seat(tr, 3, r), Seat(bottom, 0, r)],
      hubCenter: Offset(area.center.dx, tl.bottom + gap / 2),
      hubSize: hub,
    );
  }
  // mesmo arranjo girado 90° no sentido horário: base -> esquerda inteira; cima-esq -> direita cima; cima-dir -> direita baixo
  final leftW = (area.width - gap) * 0.56;
  final rightW = area.width - leftW - gap;
  final h = (area.height - gap) / 2;
  final left = Rect.fromLTWH(area.left, area.top, leftW, area.height);
  final rt = Rect.fromLTWH(area.right - rightW, area.top, rightW, h);
  final rb = Rect.fromLTWH(area.right - rightW, area.top + h + gap, rightW, h);
  return MatchGeometry(
    seats: [Seat(rt, 2, r), Seat(rb, 0, r), Seat(left, 1, r)],
    hubCenter: Offset(left.right + gap / 2, area.center.dy),
    hubSize: hub,
  );
}

typedef Insets = ({double l, double t, double r, double b});

/// Insets da tela (notch, home indicator, cantos) no referencial de um painel girado [qt] quartos de volta
/// no sentido horário. Girando 90°: o topo do painel vai para a direita da tela, a esquerda do painel vai
/// para o topo, a base vai para a esquerda e a direita do painel vai para baixo.
Insets rotateInsets(Insets i, int qt) {
  switch (qt % 4) {
    case 1:
      return (l: i.t, t: i.r, r: i.b, b: i.l);
    case 2:
      return (l: i.r, t: i.b, r: i.l, b: i.t);
    case 3:
      return (l: i.b, t: i.l, r: i.t, b: i.r);
    default:
      return i;
  }
}

/// Insets de segurança cortados à parte do painel que realmente encosta na borda da tela.
Insets screenInsetsFor(Rect rect, Size screen, Insets pad) {
  const eps = 12.0;
  return (
    l: rect.left <= eps ? pad.l : 0,
    t: rect.top <= eps ? pad.t : 0,
    r: screen.width - rect.right <= eps ? pad.r : 0,
    b: screen.height - rect.bottom <= eps ? pad.b : 0,
  );
}
