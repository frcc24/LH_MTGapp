// Gera as capturas de tela da loja a partir do próprio app, sem barra de status nem moldura.
// Uso: flutter test tool/screenshots/store_screenshots_test.dart
// Saída: store/screenshots/{iphone,ipad}/NN-nome.png (iPhone 1284x2778, iPad 2064x2752).
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:magiccounter/app.dart';
import 'package:magiccounter/core/providers.dart';
import 'package:magiccounter/core/theme/app_tokens.dart';
import 'package:magiccounter/features/monetization/iap_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:magiccounter/features/match/domain/actions.dart';
import 'package:magiccounter/features/match/domain/match_storage.dart';
import 'package:magiccounter/features/match/domain/models.dart';
import 'package:magiccounter/features/match/domain/reducer.dart';
import 'package:magiccounter/router.dart';
import 'package:magiccounter/shared/widgets/lh_stepper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _t0 = DateTime.now().subtract(const Duration(minutes: 22));
DateTime _at(int s) => _t0.add(Duration(seconds: s * 7));

GameConfig _cfg(int n, {int life = 20, Set<CounterType> counters = const {}, int? timer, String format = 'standard'}) =>
    GameConfig(
      formatId: format,
      startingLife: life,
      players: [
        for (var i = 0; i < n; i++)
          PlayerConfig(id: 'p$i', name: const ['Ana', 'Bruno', 'Carla', 'Davi'][i], color: PlayerColor.values[i]),
      ],
      enabledCounters: counters,
      turnTimerSeconds: timer,
    );

GameState _play(GameConfig c, String active, List<GameAction> acts) {
  var s = createInitialState(c, now: _t0, starterId: active);
  for (final a in acts) {
    s = reduce(s, a);
  }
  return s;
}

GameState _commander4() => _play(
  _cfg(4, life: 40, format: 'commander', counters: {CounterType.commander, CounterType.poison, CounterType.monarch}),
  'p0',
  [
    ChangeLife(_at(1), 'p0', -9),
    ChangeLife(_at(3), 'p1', -4),
    ChangeLife(_at(5), 'p2', -8),
    ChangeCmdDamage(_at(8), 'p2', 'p0', 19),
    ChangeLife(_at(10), 'p3', -13),
    ChangeCounter(_at(12), 'p3', CounterType.poison, 3),
    ChangeCounter(_at(14), 'p1', CounterType.poison, 1),
    SetMonarch(_at(16), 'p1'),
    PassTurn(_at(20)),
    PassTurn(_at(25)),
    PassTurn(_at(30)),
    PassTurn(_at(35)),
  ],
);

GameState _two() => _play(_cfg(2, timer: 90, counters: {CounterType.poison, CounterType.energy}), 'p0', [
  ChangeLife(_at(1), 'p0', -3),
  ChangeLife(_at(3), 'p1', -6),
  ChangeCounter(_at(5), 'p1', CounterType.energy, 2),
  ChangeLife(_at(40), 'p1', -3),
  PassTurn(_at(45)),
  PassTurn(_at(50)),
]);

GameState _commander2() => _play(
  _cfg(2, life: 40, format: 'commander', counters: {CounterType.commander, CounterType.poison, CounterType.monarch}),
  'p0',
  [
    ChangeLife(_at(1), 'p0', -9),
    ChangeLife(_at(3), 'p1', -12),
    ChangeCmdDamage(_at(8), 'p0', 'p1', 11),
    ChangeCounter(_at(12), 'p1', CounterType.poison, 4),
    SetMonarch(_at(16), 'p0'),
  ],
);

Future<void> _loadFonts() async {
  final manifest = json.decode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final f in manifest) {
    final loader = FontLoader(f['family'] as String);
    for (final font in f['fonts'] as List) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

Future<void> _save(WidgetTester t, GlobalKey key, String path, double dpr) async {
  await t.runAsync(() async {
    final boundary = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: dpr);
    final data = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    final file = File(path)..createSync(recursive: true);
    file.writeAsBytesSync(data.buffer.asUint8List());
  });
}

/// Monta o app com [game] salvo (ou nenhum), vai para [route] e salva o PNG.
Future<void> _shoot(
  WidgetTester t, {
  required String path,
  required Size logical,
  required double dpr,
  required String route,
  GameState? game,
  Future<void> Function()? act,
  List<Override> extra = const [],
}) async {
  t.view.physicalSize = Size(logical.width * dpr, logical.height * dpr);
  t.view.devicePixelRatio = dpr;
  SharedPreferences.setMockInitialValues({'onboarding_done': true, 'keep_awake': false, 'sessions': 1, 'locale': 'en'});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      matchStorageProvider.overrideWithValue(MemoryMatchStorage()),
      initialMatchProvider.overrideWithValue(game),
      ...extra,
    ],
  );
  final key = GlobalKey();
  await t.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RepaintBoundary(key: key, child: const LighthouseApp()),
    ),
  );
  await t.pump(const Duration(milliseconds: 300));
  container.read(routerProvider).go(route);
  for (var i = 0; i < 6; i++) {
    await t.pump(const Duration(milliseconds: 250));
  }
  if (act != null) {
    await act();
    for (var i = 0; i < 6; i++) {
      await t.pump(const Duration(milliseconds: 250));
    }
  }
  await _save(t, key, path, dpr);
  await t.pumpWidget(const SizedBox());
  await t.pump();
  container.dispose();
}

/// Loja falsa só para a captura do paywall mostrar o preço.
class _FakeIap extends IapNotifier {
  @override
  IapState build() => IapState(
    available: true,
    products: {
      proProductId: ProductDetails(
        id: proProductId,
        title: 'Lighthouse Pro',
        description: 'Lighthouse Pro',
        price: r'$1.99',
        rawPrice: 1.99,
        currencyCode: 'USD',
      ),
    },
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const iphone = (name: 'iphone', size: Size(428, 926), dpr: 3.0);
  const ipad = (name: 'ipad', size: Size(1032, 1376), dpr: 2.0);

  setUpAll(_loadFonts);

  for (final d in [iphone, ipad]) {
    final dir = 'store/screenshots/${d.name}';

    testWidgets('${d.name} 01 partida de 4 jogadores', (t) async {
      await _shoot(
        t,
        path: '$dir/01-quatro-jogadores.png',
        logical: d.size,
        dpr: d.dpr,
        route: '/match',
        game: _commander4(),
      );
    });

    testWidgets('${d.name} 02 partida de 2 jogadores com timer', (t) async {
      await _shoot(t, path: '$dir/02-dois-jogadores.png', logical: d.size, dpr: d.dpr, route: '/match', game: _two());
    });

    testWidgets('${d.name} 03 ferramentas', (t) async {
      await _shoot(
        t,
        path: '$dir/03-ferramentas.png',
        logical: d.size,
        dpr: d.dpr,
        route: '/tools',
        act: () async {
          await t.tap(find.text('Roll'));
          await t.pump(const Duration(seconds: 1));
        },
      );
    });

    testWidgets('${d.name} 04 gaveta de comandante', (t) async {
      await _shoot(
        t,
        path: '$dir/04-gaveta.png',
        logical: d.size,
        dpr: d.dpr,
        route: '/match',
        game: _commander2(),
        act: () async {
          await t.tap(find.text('Ana').first);
          await t.pump(const Duration(milliseconds: 500));
          await t.tap(find.text('Commander').last);
        },
      );
    });

    testWidgets('${d.name} 05 base de mana', (t) async {
      await _shoot(
        t,
        path: '$dir/05-base-de-mana.png',
        logical: d.size,
        dpr: d.dpr,
        route: '/mana',
        act: () async {
          // steppers: 0 = total de terrenos; 1 = branco, 2 = azul, 3 = preto
          for (final entry in {1: 8, 2: 6, 3: 3}.entries) {
            final plus = find
                .descendant(of: find.byType(LhStepper).at(entry.key), matching: find.byType(GestureDetector))
                .last;
            for (var i = 0; i < entry.value; i++) {
              await t.tap(plus);
              await t.pump();
            }
          }
        },
      );
    });
  }

  testWidgets('captura do paywall para a revisão da compra', (t) async {
    await _shoot(
      t,
      path: 'store/screenshots/iap/lighthouse-pro.png',
      logical: iphone.size,
      dpr: iphone.dpr,
      route: '/pro',
      extra: [iapProvider.overrideWith(_FakeIap.new)],
    );
  });

  // referência para o analisador não reclamar do import quando só o iPhone roda
  test('tokens carregam', () => expect(AppColors.bg, isNotNull));
  test('router existe', () => expect(GoRouter, isNotNull));
}
