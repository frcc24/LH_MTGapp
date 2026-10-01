import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'ads_config.dart';
import 'ads_service.dart';

/// Banner 320x50 da Unity Ads. Reserva sempre 50 pt para o layout não "pular".
/// Nunca usar na partida, na gaveta, no menu, em diálogos, no paywall nem em Sobre.
class AdBanner extends ConsumerWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(adsProvider);
    return SizedBox(
      height: 50,
      child: ready ? Center(child: UnityBannerAd(placementId: AdsConfig.bannerPlacement)) : null,
    );
  }
}
