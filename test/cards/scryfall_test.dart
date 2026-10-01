import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/features/cards/scryfall.dart';

class _Fake implements HttpClientAdapter {
  _Fake(this.respond);
  final ResponseBody Function(RequestOptions) respond;
  final calls = <RequestOptions>[];
  final times = <DateTime>[];

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? s, Future<void>? c) async {
    calls.add(o);
    times.add(DateTime.now());
    return respond(o);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(Object body, [int status = 200]) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

const _single = {
  'id': 'a1',
  'name': 'Llanowar Elves',
  'mana_cost': '{G}',
  'type_line': 'Creature — Elf Druid',
  'oracle_text': '{T}: Add {G}.',
  'image_uris': {'small': 's', 'normal': 'n'},
  'legalities': {'standard': 'not_legal', 'commander': 'legal'},
  'scryfall_uri': 'https://scryfall.com/card/x',
  'prices': {'usd': '1.00'},
  'purchase_uris': {'tcgplayer': 'x'},
};

const _double = {
  'id': 'b2',
  'name': 'Delver // Insectile',
  'legalities': <String, String>{},
  'scryfall_uri': 'u',
  'card_faces': [
    {
      'name': 'Delver',
      'mana_cost': '{U}',
      'type_line': 'Creature',
      'oracle_text': 'a',
      'image_uris': {'normal': 'f1', 'small': 'f1s'},
    },
    {
      'name': 'Insectile',
      'type_line': 'Creature',
      'oracle_text': 'b',
      'image_uris': {'normal': 'f2', 'small': 'f2s'},
    },
  ],
};

void main() {
  test('toda requisição leva User-Agent e Accept', () async {
    final f = _Fake((_) => _json({'data': <Object>[], 'has_more': false, 'total_cards': 0}));
    final c = ScryfallClient(dio: Dio()..httpClientAdapter = f, version: '9.9');
    await c.search('elf');
    expect(f.calls.single.headers['User-Agent'], contains('LighthouseLife/9.9'));
    expect(f.calls.single.headers['Accept'], 'application/json');
  });

  test('fila: nunca mais que 1 requisição por 100 ms (rajada de 5)', () async {
    final f = _Fake((_) => _json({'data': <Object>[], 'has_more': false}));
    final c = ScryfallClient(dio: Dio()..httpClientAdapter = f);
    await Future.wait([for (var i = 0; i < 5; i++) c.search('x$i')]);
    for (var i = 1; i < f.times.length; i++) {
      expect(f.times[i].difference(f.times[i - 1]).inMilliseconds, greaterThanOrEqualTo(90), reason: 'intervalo $i');
    }
  });

  test('RateGate reserva vagas espaçadas', () {
    var t = DateTime(2026);
    final g = RateGate(now: () => t);
    expect(g.reserve(), Duration.zero);
    expect(g.reserve(), const Duration(milliseconds: 100));
    expect(g.reserve(), const Duration(milliseconds: 200));
    t = t.add(const Duration(seconds: 1));
    expect(g.reserve(), Duration.zero);
  });

  test('não expõe preços nem links de compra', () {
    final card = ScryCard.fromJson(Map<String, dynamic>.from(_single));
    expect(card.front.name, 'Llanowar Elves');
    expect(card.front.imageUrl, 'n');
    expect(card.legalities['commander'], 'legal');
    // o modelo simplesmente não tem esses campos
    expect(card.toString(), isNot(contains('1.00')));
  });

  test('carta de duas faces vira duas faces com imagens próprias', () {
    final card = ScryCard.fromJson(Map<String, dynamic>.from(_double));
    expect(card.faces.length, 2);
    expect(card.faces[1].imageUrl, 'f2');
    expect(card.front.manaCost, '{U}');
  });

  test('404 vira lista vazia e a consulta é montada', () async {
    final f = _Fake((_) => _json({'object': 'error'}, 404));
    final c = ScryfallClient(dio: Dio()..httpClientAdapter = f);
    final p = await c.search('zzzz');
    expect(p.cards, isEmpty);
    expect(buildQuery(name: 'elf', colors: {'g', 'w'}, type: 'creature', maxMv: 3), 'elf c:gw t:creature mv<=3');
  });
}
