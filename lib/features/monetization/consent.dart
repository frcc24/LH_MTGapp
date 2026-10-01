import 'dart:io' show Platform;

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../settings/settings_state.dart';
import 'ads_service.dart';
import 'pro_state.dart';

/// Pede consentimento de anúncios no momento certo: depois da primeira partida ou na segunda abertura,
/// nunca no primeiro segundo. No iOS mostra o pré-prompt e então o pedido do sistema (ATT).
Future<void> maybeAskAdsConsent(BuildContext context, WidgetRef ref) async {
  final s = ref.read(settingsProvider);
  if (ref.read(isProProvider)) return;
  if (s.adsConsent != AdsConsent.unknown) {
    await ref.read(adsProvider.notifier).init();
    return;
  }
  if (s.sessions < 2 && s.matchesFinished < 1) return;
  final l = AppL10n.of(context);
  final n = ref.read(settingsProvider.notifier);

  if (Platform.isIOS) {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.attPreTitle),
        content: Text(l.attPreBody),
        actions: [FilledButton(onPressed: () => Navigator.pop(ctx), child: Text(l.continueLabel))],
      ),
    );
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    n.setAttPromptShown();
    n.setAdsConsent(status == TrackingStatus.authorized ? AdsConsent.personalized : AdsConsent.nonPersonalized);
  } else {
    if (!context.mounted) return;
    final personalized = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l.consentTitle),
        content: Text(l.consentBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.consentNonPersonalized)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.consentPersonalized)),
        ],
      ),
    );
    n.setAdsConsent(personalized == true ? AdsConsent.personalized : AdsConsent.nonPersonalized);
  }
  await ref.read(adsProvider.notifier).init();
}
