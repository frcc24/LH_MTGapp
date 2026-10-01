import 'dart:io' show Platform;

/// IDs da Unity Ads. Pegue no painel da Unity (Monetization > Placements) e troque aqui.
/// Enquanto forem os de exemplo, `testMode` fica ligado e nenhum anúncio real é exibido.
abstract final class AdsConfig {
  static const androidGameId = '0000000'; // TODO: Game ID Android
  static const iosGameId = '0000000'; // TODO: Game ID iOS
  static const testMode = true;

  static String get gameId => Platform.isIOS ? iosGameId : androidGameId;
  static String get bannerPlacement => Platform.isIOS ? 'Banner_iOS' : 'Banner_Android';
  static String get interstitialPlacement => Platform.isIOS ? 'Interstitial_iOS' : 'Interstitial_Android';
}
