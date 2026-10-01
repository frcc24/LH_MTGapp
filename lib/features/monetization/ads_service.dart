import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../settings/settings_state.dart';
import 'ads_config.dart';
import 'pro_state.dart';

/// Regras do intersticial de fim de partida, puras para poder testar: nunca para Pro, nunca na primeira sessão,
/// nunca se a partida durou menos de [minMatchMinutes] e nunca antes de [minGap] desde o último anúncio.
const minMatchMinutes = 3;
const minGap = Duration(minutes: 4);

bool shouldShowInterstitial({
  required AppSettings settings,
  required bool pro,
  required int minutesPlayed,
  required DateTime now,
}) {
  if (pro) return false;
  if (settings.sessions <= 1) return false;
  if (minutesPlayed < minMatchMinutes) return false;
  final last = settings.lastInterstitialAt;
  if (last != null && now.difference(last) < minGap) return false;
  return true;
}

/// state = Unity inicializada (só acontece depois do consentimento e fora do Pro).
class AdsNotifier extends Notifier<bool> {
  bool _loaded = false;

  /// A inicialização em andamento, para dois chamadores dividirem uma só: `UnityAds.init` chamado duas vezes ao mesmo tempo
  /// responde `internalError` e deixa o SDK inutilizável até o app fechar.
  Future<void>? _initializing;

  @override
  bool build() => false;

  bool get _supported => Platform.isAndroid || Platform.isIOS;

  Future<void> init() {
    if (state || !_supported || ref.read(isProProvider)) return Future<void>.value();
    if (ref.read(settingsProvider).adsConsent == AdsConsent.unknown) return Future<void>.value();
    return _initializing ??= _initOnce().whenComplete(() => _initializing = null);
  }

  Future<void> _initOnce() async {
    final personalized = ref.read(settingsProvider).adsConsent == AdsConsent.personalized;
    final done = Completer<void>();
    try {
      await UnityAds.setPrivacyConsent(PrivacyConsentType.gdpr, personalized);
      await UnityAds.setPrivacyConsent(PrivacyConsentType.ccpa, personalized);
      await UnityAds.init(
        gameId: AdsConfig.gameId,
        testMode: AdsConfig.testMode,
        onComplete: () {
          state = true;
          if (!done.isCompleted) done.complete();
        },
        // sem Unity (rede, projeto sem preenchimento): o app segue sem anúncios
        onFailed: (_, _) {
          if (!done.isCompleted) done.complete();
        },
      );
      await done.future.timeout(const Duration(seconds: 20), onTimeout: () {});
    } catch (_) {}
    if (state) await _load();
  }

  /// Carrega o intersticial. Falta de preenchimento é o estado normal de um projeto novo, não um erro.
  Future<void> _load() {
    final done = Completer<void>();
    _loaded = false;
    UnityAds.load(
      placementId: AdsConfig.interstitialPlacement,
      onComplete: (_) {
        _loaded = true;
        if (!done.isCompleted) done.complete();
      },
      onFailed: (_, _, _) {
        _loaded = false;
        if (!done.isCompleted) done.complete();
      },
    );
    return done.future.timeout(const Duration(seconds: 10), onTimeout: () {});
  }

  /// Chamado quando a tela de fim de partida abre (a partida já foi encerrada e gravada).
  /// Nunca durante a partida: o fim só vale depois de confirmado, e a partida em si não tem anúncio.
  Future<void> maybeShowInterstitial({required int minutesPlayed}) async {
    final now = DateTime.now();
    if (!state) return;
    if (!shouldShowInterstitial(
      settings: ref.read(settingsProvider),
      pro: ref.read(isProProvider),
      minutesPlayed: minutesPlayed,
      now: now,
    )) {
      return;
    }
    if (!_loaded) await _load(); // uma segunda chance, como nos outros apps
    if (!_loaded) return;
    _loaded = false; // gasto ao exibir, aconteça o que acontecer
    final done = Completer<bool>();
    await UnityAds.showVideoAd(
      placementId: AdsConfig.interstitialPlacement,
      onComplete: (_) => done.complete(true),
      onSkipped: (_) => done.complete(true),
      onFailed: (_, _, _) => done.complete(false),
    );
    if (await done.future.timeout(const Duration(seconds: 90), onTimeout: () => false)) {
      ref.read(settingsProvider.notifier).recordInterstitialShown(now);
    }
    unawaited(_load());
  }
}

final adsProvider = NotifierProvider<AdsNotifier, bool>(AdsNotifier.new);
