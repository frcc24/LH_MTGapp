import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/features/monetization/ads_service.dart';
import 'package:magiccounter/features/settings/settings_state.dart';

final _now = DateTime(2026, 10, 1, 20);

bool _show({AppSettings settings = const AppSettings(sessions: 3), bool pro = false, int minutes = 10}) =>
    shouldShowInterstitial(settings: settings, pro: pro, minutesPlayed: minutes, now: _now);

void main() {
  test('partida normal na 3ª sessão: mostra', () => expect(_show(), isTrue));
  test('toda partida elegível mostra (sem "1 a cada 2")', () {
    expect(_show(settings: const AppSettings(sessions: 3, matchesSinceInterstitial: 1)), isTrue);
    expect(_show(settings: const AppSettings(sessions: 3, matchesSinceInterstitial: 0)), isTrue);
  });
  test('Pro nunca vê', () => expect(_show(pro: true), isFalse));
  test('primeira sessão nunca', () => expect(_show(settings: const AppSettings(sessions: 1)), isFalse));
  test('partida de menos de 3 min não', () {
    expect(_show(minutes: 2), isFalse);
    expect(_show(minutes: 3), isTrue);
  });
  test('4 min de intervalo desde o último anúncio', () {
    final recent = AppSettings(sessions: 3, lastInterstitialAt: _now.subtract(const Duration(minutes: 3, seconds: 59)));
    final old = AppSettings(sessions: 3, lastInterstitialAt: _now.subtract(const Duration(minutes: 4)));
    expect(_show(settings: recent), isFalse);
    expect(_show(settings: old), isTrue);
  });
}
