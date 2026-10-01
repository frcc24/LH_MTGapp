import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const scryfallBase = 'https://api.scryfall.com';
const scryfallMinGap = Duration(milliseconds: 100);

/// Uma face da carta (cartas de duas faces têm duas).
class CardFace {
  const CardFace({
    required this.name,
    this.manaCost = '',
    this.typeLine = '',
    this.oracleText = '',
    this.imageUrl,
    this.smallUrl,
  });
  final String name;
  final String manaCost;
  final String typeLine;
  final String oracleText;
  final String? imageUrl;
  final String? smallUrl;
}

/// Só os campos que o app usa. Preços (`prices`) e links de compra (`purchase_uris`) NÃO são lidos.
class ScryCard {
  const ScryCard({
    required this.id,
    required this.name,
    required this.faces,
    required this.legalities,
    required this.scryfallUri,
  });
  final String id;
  final String name;
  final List<CardFace> faces;
  final Map<String, String> legalities;
  final String scryfallUri;

  CardFace get front => faces.first;

  factory ScryCard.fromJson(Map<String, dynamic> j) {
    CardFace face(Map<String, dynamic> f, {Map<String, dynamic>? fallbackImages}) {
      final img = (f['image_uris'] ?? fallbackImages) as Map?;
      return CardFace(
        name: f['name'] as String? ?? '',
        manaCost: f['mana_cost'] as String? ?? '',
        typeLine: f['type_line'] as String? ?? '',
        oracleText: f['oracle_text'] as String? ?? '',
        imageUrl: img?['normal'] as String?,
        smallUrl: img?['small'] as String?,
      );
    }

    final facesJson = j['card_faces'] as List?;
    final topImages = j['image_uris'] as Map<String, dynamic>?;
    final faces = (facesJson != null && facesJson.isNotEmpty && topImages == null)
        ? [for (final f in facesJson) face(Map<String, dynamic>.from(f as Map))]
        : [
            face({
              'name': j['name'],
              'mana_cost': j['mana_cost'] ?? (facesJson?.first as Map?)?['mana_cost'],
              'type_line': j['type_line'],
              'oracle_text': j['oracle_text'],
              'image_uris': topImages,
            }),
          ];
    return ScryCard(
      id: j['id'] as String,
      name: j['name'] as String,
      faces: faces,
      legalities: {for (final e in (j['legalities'] as Map? ?? const {}).entries) e.key as String: e.value as String},
      scryfallUri: j['scryfall_uri'] as String? ?? 'https://scryfall.com',
    );
  }
}

class CardPage {
  const CardPage(this.cards, this.nextPage, this.total);
  final List<ScryCard> cards;
  final String? nextPage;
  final int total;
}

/// Espaça as requisições em no mínimo [scryfallMinGap] (limite pedido pela Scryfall).
class RateGate {
  RateGate({this.gap = scryfallMinGap, DateTime Function()? now}) : _now = now ?? DateTime.now;
  final Duration gap;
  final DateTime Function() _now;
  DateTime _next = DateTime.fromMillisecondsSinceEpoch(0);

  /// Reserva a vez e devolve quanto esperar antes de disparar.
  Duration reserve() {
    final t = _now();
    final start = t.isAfter(_next) ? t : _next;
    _next = start.add(gap);
    return start.difference(t);
  }
}

class ScryfallClient {
  ScryfallClient({Dio? dio, this.version = '1.0.0', this.contact = 'frcc24@gmail.com', RateGate? gate})
    : _gate = gate ?? RateGate(),
      _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = scryfallBase
      ..connectTimeout = const Duration(seconds: 10)
      ..receiveTimeout = const Duration(seconds: 15)
      ..headers = {'User-Agent': 'LighthouseLife/$version (contato: $contact)', 'Accept': 'application/json'};
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) async {
          final wait = _gate.reserve();
          if (wait > Duration.zero) await Future<void>.delayed(wait);
          h.next(o);
        },
        onError: (e, h) async {
          // 429: espera e tenta uma vez de novo
          if (e.response?.statusCode == 429 && e.requestOptions.extra['retried'] != true) {
            await Future<void>.delayed(const Duration(seconds: 2));
            e.requestOptions.extra['retried'] = true;
            try {
              return h.resolve(await _dio.fetch<dynamic>(e.requestOptions));
            } catch (_) {}
          }
          h.next(e);
        },
      ),
    );
  }

  final Dio _dio;
  final RateGate _gate;
  final String version;
  final String contact;

  Future<List<String>> autocomplete(String q) async {
    final r = await _dio.get<Map<String, dynamic>>('/cards/autocomplete', queryParameters: {'q': q});
    return [for (final s in (r.data?['data'] as List? ?? const [])) s as String];
  }

  /// [nextPage] é a URL completa devolvida em `next_page`.
  Future<CardPage> search(String query, {String? nextPage}) async {
    try {
      final r = nextPage != null
          ? await _dio.getUri<Map<String, dynamic>>(Uri.parse(nextPage))
          : await _dio.get<Map<String, dynamic>>(
              '/cards/search',
              queryParameters: {'q': query, 'order': 'name', 'unique': 'cards'},
            );
      final d = r.data!;
      return CardPage(
        [for (final c in (d['data'] as List)) ScryCard.fromJson(Map<String, dynamic>.from(c as Map))],
        d['has_more'] == true ? d['next_page'] as String? : null,
        d['total_cards'] as int? ?? 0,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return const CardPage([], null, 0); // nenhum resultado
      rethrow;
    }
  }

  Future<ScryCard> byId(String id) async {
    final r = await _dio.get<Map<String, dynamic>>('/cards/$id');
    return ScryCard.fromJson(r.data!);
  }
}

final scryfallProvider = Provider<ScryfallClient>((ref) => ScryfallClient());

/// Monta a consulta: nome + cores + tipo + valor de mana máximo.
String buildQuery({required String name, Set<String> colors = const {}, String? type, int? maxMv}) {
  final parts = <String>[];
  if (name.trim().isNotEmpty) parts.add(name.trim());
  if (colors.isNotEmpty) parts.add('c:${colors.join()}');
  if (type != null) parts.add('t:$type');
  if (maxMv != null) parts.add('mv<=$maxMv');
  return parts.join(' ');
}
