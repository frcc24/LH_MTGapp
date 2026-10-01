import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../settings/settings_state.dart';
import 'ads_config.dart';
import 'pro_state.dart';

/// Regras de frequência do intersticial (handoff, seção 12), puras para poder testar:
/// no máximo 1 a cada 2 partidas terminadas, 4 min entre exibições, nunca na primeira sessão,
/// nunca se a partida durou menos de 3 min e nunca para Pro.
bool shouldShowInterstitial({
  required AppSettings settings,
  required bool pro,
  required int minutesPlayed,
  required DateTime now,
}) {
  if (pro) return false;
  if (settings.sessions <= 1) return false;
  if (minutesPlayed < 3) return false;
  if (settings.matchesSinceInterstitial < 2) return false;
  final last = settings.lastInterstitialAt;
  if (last != null && now.difference(last) < const Duration(minutes: 4)) return false;
  return true;
}

/// state = Unity inicializada (só acontece depois do consentimento e fora do Pro).
class AdsNotifier extends Notifier<bool> {
  bool _loaded = false;

  @override
  bool build() => false;

  bool get _supported => Platform.isAndroid || Platform.isIOS;

  Future<void> init() async {
    if (state || !_supported || ref.read(isProProvider)) return;
    final consent = ref.read(settingsProvider).adsConsent;
    if (consent == AdsConsent.unknown) return;
    final personalized = consent == AdsConsent.personalized;
    try {
      await UnityAds.setPrivacyConsent(PrivacyConsentType.gdpr, personalized);
      await UnityAds.setPrivacyConsent(PrivacyConsentType.ccpa, personalized);
      await UnityAds.init(
        gameId: AdsConfig.gameId,
        testMode: AdsConfig.testMode,
        onComplete: () {
          state = true;
          _preload();
        },
        onFailed: (_, _) {},
      );
    } catch (_) {
      // sem Unity (plataforma ou rede): o app segue sem anúncios
    }
  }

  void _preload() {
    _loaded = false;
    UnityAds.load(
      placementId: AdsConfig.interstitialPlacement,
      onComplete: (_) => _loaded = true,
      onFailed: (_, _, _) => _loaded = false,
    );
  }

  /// Chamado só depois de tocar em "Início" na tela de fim de partida.
  Future<void> maybeShowInterstitial({required int minutesPlayed}) async {
    final now = DateTime.now();
    if (!state || !_loaded) return;
    if (!shouldShowInterstitial(
      settings: ref.read(settingsProvider),
      pro: ref.read(isProProvider),
      minutesPlayed: minutesPlayed,
      now: now,
    ))
      return;
    final done = Completer<bool>();
    await UnityAds.showVideoAd(
      placementId: AdsConfig.interstitialPlacement,
      onComplete: (_) => done.complete(true),
      onSkipped: (_) => done.complete(true),
      onFailed: (_, _, _) => done.complete(false),
    );
    if (await done.future.timeout(const Duration(seconds: 60), onTimeout: () => false)) {
      ref.read(settingsProvider.notifier).recordInterstitialShown(now);
    }
    _preload();
  }
}

final adsProvider = NotifierProvider<AdsNotifier, bool>(AdsNotifier.new);
