import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'iap_service.dart';
import 'pro_state.dart';

/// Lighthouse Pro: compra única, sem assinatura, sem urgência falsa. Fechar sempre visível.
class PaywallScreen extends ConsumerWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final pro = ref.watch(isProProvider);
    final iap = ref.watch(iapProvider);
    final price = iap.pro?.price;

    Widget row(String free, String proText) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(free, style: AppType.body.copyWith(color: AppColors.textMuted)),
          ),
          const FaIcon(FontAwesomeIcons.arrowRight, size: 12, color: AppColors.iconIdle),
          const SizedBox(width: 12),
          Expanded(child: Text(proText, style: AppType.label)),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 64, AppSpace.screenH, 24),
                  children: [
                    const Center(child: FaIcon(FontAwesomeIcons.crown, size: 44, color: AppColors.accent)),
                    const SizedBox(height: 16),
                    Center(child: Text(l.proName.toUpperCase(), style: AppType.screenTitleDisplay)),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        l.proTagline,
                        style: AppType.bodyLarge.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 28),
                    row(l.proFreeAds, l.proPaidNoAds),
                    const Divider(color: AppColors.divider),
                    row(l.proFreeHistory(FreeLimits.history), l.proPaidHistory),
                    const SizedBox(height: 28),
                    if (pro)
                      Center(
                        child: Text(l.proOwned, style: AppType.title.copyWith(color: AppColors.gain)),
                      )
                    else ...[
                      SizedBox(
                        height: AppSize.buttonHero,
                        child: FilledButton(
                          onPressed: iap.busy || iap.pro == null ? null : () => ref.read(iapProvider.notifier).buyPro(),
                          child: Text(price == null ? l.storeUnavailable : l.buyPro(price)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(l.oneTimeNote, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                      ),
                      if (iap.error != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            iap.error!,
                            style: AppType.caption.copyWith(color: AppColors.danger),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton(
                        onPressed: iap.busy ? null : () => ref.read(iapProvider.notifier).restore(),
                        child: Text(l.restorePurchases),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton.filledTonal(
                onPressed: () => context.pop(),
                tooltip: l.close,
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
