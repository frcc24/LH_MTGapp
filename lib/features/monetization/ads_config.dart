import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode;

/// IDs da Unity Ads (projeto "Lighthouse Life", criado em 01/10/2026). Android e iOS são projetos separados no console da
/// Unity, então têm Game IDs separados: usar o errado inicializa contra o projeto errado e nunca preenche.
///
/// Os Placement IDs são os das Ad Units que a Unity criou sozinha para o projeto; confira em Monetization > Ad Units.
/// Não são segredos: identificam o jogo para a rede, como um bundle id.
abstract final class AdsConfig {
  static const androidGameId = '6198412';
  static const iosGameId = '6198413';

  /// Build de debug pede anúncio de teste; release pede o real. Release com teste não rende nada, e debug com anúncio real
  /// é o jeito mais rápido de a conta ser marcada por tráfego inválido.
  static const testMode = kDebugMode;

  static String get gameId => Platform.isIOS ? iosGameId : androidGameId;
  static String get bannerPlacement => Platform.isIOS ? 'Banner_iOS' : 'Banner_Android';
  static String get interstitialPlacement => Platform.isIOS ? 'Interstitial_iOS' : 'Interstitial_Android';
}
