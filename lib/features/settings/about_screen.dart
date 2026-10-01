import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/links.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lighthouse_icon.dart';
import '../../shared/widgets/section_header.dart';
import '../monetization/iap_service.dart';

/// Sobre: sem anúncios aqui, nunca.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  Future<void> _open(String url) => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final iap = ref.watch(iapProvider);

    Widget link(String label, VoidCallback f, {FaIconData icon = FontAwesomeIcons.arrowUpRightFromSquare}) => ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: AppType.label.copyWith(fontSize: 17)),
      trailing: FaIcon(icon, size: 14),
      onTap: f,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 8, AppSpace.screenH, 32),
              children: [
                const Center(child: LighthouseIcon(size: 72, color: AppColors.accent)),
                const SizedBox(height: 12),
                Center(child: Text(l.appName.toUpperCase(), style: AppType.screenTitleDisplay)),
                Center(
                  child: FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (_, snap) => Text(
                      snap.hasData ? l.versionN('${snap.data!.version} (${snap.data!.buildNumber})') : '',
                      style: AppType.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Text(l.legalNotice, style: AppType.body.copyWith(color: AppColors.legalText)),
                ),
                SectionHeader(l.aboutContact),
                link(l.sendSuggestion, () async {
                  final info = await PackageInfo.fromPlatform();
                  _open(
                    'mailto:${Links.contactEmail}?subject=${Uri.encodeComponent('Lighthouse Life ${info.version}')}',
                  );
                }, icon: FontAwesomeIcons.envelope),
                link(l.rateApp, () => _open(Links.androidStore)),
                link(l.privacyPolicy, () => _open(Links.privacy)),
                link(l.terms, () => _open(Links.terms)),
                link(
                  l.licenses,
                  () => showLicensePage(context: context, applicationName: l.appName),
                  icon: FontAwesomeIcons.chevronRight,
                ),
                if (iap.available &&
                    (iap.products.containsKey('tip_small') || iap.products.containsKey('tip_medium'))) ...[
                  SectionHeader(l.supportProject),
                  Text(l.supportBody, style: AppType.body.copyWith(color: AppColors.textMuted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (final id in tipProductIds)
                        if (iap.products[id] != null)
                          OutlinedButton(
                            onPressed: iap.busy ? null : () => ref.read(iapProvider.notifier).tip(id),
                            child: Text(iap.products[id]!.price),
                          ),
                    ],
                  ),
                ],
                SectionHeader(l.credits),
                Text(l.creditsBody, style: AppType.body.copyWith(color: AppColors.textMuted)),
                const SizedBox(height: 6),
                TextButton(onPressed: () => _open(Links.scryfall), child: const Text('scryfall.com')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
