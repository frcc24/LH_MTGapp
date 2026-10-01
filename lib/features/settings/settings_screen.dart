import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/links.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/section_header.dart';
import '../monetization/ads_service.dart';
import '../monetization/iap_service.dart';
import '../monetization/pro_state.dart';
import 'settings_state.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final pro = ref.watch(isProProvider);

    Widget sw(String title, bool v, ValueChanged<bool> f, {String? sub}) => SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppType.label.copyWith(fontSize: 17)),
      subtitle: sub == null ? null : Text(sub, style: AppType.caption.copyWith(color: AppColors.textMuted)),
      value: v,
      onChanged: f,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, 32),
              children: [
                if (!pro)
                  GestureDetector(
                    onTap: () => context.push('/pro'),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.accentSoftBg,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.crown, color: AppColors.accent),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.proName,
                                  style: AppType.label.copyWith(fontSize: 18, color: AppColors.accentSoftFg),
                                ),
                                Text(l.proTagline, style: AppType.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          const FaIcon(FontAwesomeIcons.chevronRight, size: 14, color: AppColors.accent),
                        ],
                      ),
                    ),
                  ),
                SectionHeader(l.sectionMatch),
                sw(l.keepAwake, s.keepAwake, n.setKeepAwake),
                sw(l.haptics, s.haptics, n.setHaptics),
                sw(l.sounds, s.sounds, n.setSounds),
                sw(l.lockOrientation, s.lockOrientation, n.setLockOrientation),
                const SizedBox(height: 8),
                Text(l.defaultTimer, style: AppType.label.copyWith(fontSize: 17)),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  showSelectedIcon: false,
                  segments: [
                    for (final v in const [0, 60, 90, 120])
                      ButtonSegment(value: v, label: Text(v == 0 ? l.noTimer : '${v}s')),
                  ],
                  selected: {s.defaultTimerSeconds},
                  onSelectionChanged: (v) => n.setDefaultTimer(v.first),
                ),
                SectionHeader(l.sectionLook),
                sw(l.colorBlind, s.colorBlind, n.setColorBlind, sub: l.colorBlindSub),
                Text(l.followsSystem, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                SectionHeader(l.sectionLanguage),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(value: '', label: Text(l.langSystem)),
                    const ButtonSegment(value: 'pt', label: Text('PT')),
                    const ButtonSegment(value: 'en', label: Text('EN')),
                    const ButtonSegment(value: 'es', label: Text('ES')),
                  ],
                  selected: {s.localeCode ?? ''},
                  onSelectionChanged: (v) => n.setLocale(v.first.isEmpty ? null : v.first),
                ),
                SectionHeader(l.sectionPurchases),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.restorePurchases, style: AppType.label.copyWith(fontSize: 17)),
                  trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                  onTap: () async {
                    await ref.read(iapProvider.notifier).restore();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(ref.read(isProProvider) ? l.proOwned : l.nothingToRestore)),
                      );
                    }
                  },
                ),
                if (!pro)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.adsAndTracking, style: AppType.label.copyWith(fontSize: 17)),
                    subtitle: Text(switch (s.adsConsent) {
                      AdsConsent.unknown => l.consentUnknown,
                      AdsConsent.personalized => l.consentPersonalized,
                      AdsConsent.nonPersonalized => l.consentNonPersonalized,
                    }, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                    trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                    onTap: () => _consentDialog(context, ref),
                  ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.privacyPolicy, style: AppType.label.copyWith(fontSize: 17)),
                  trailing: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 14),
                  onTap: () => launchUrl(Uri.parse(Links.privacy), mode: LaunchMode.externalApplication),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l.about, style: AppType.label.copyWith(fontSize: 17)),
                  trailing: const FaIcon(FontAwesomeIcons.chevronRight, size: 14),
                  onTap: () => context.push('/settings/about'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _consentDialog(BuildContext context, WidgetRef ref) async {
    final l = AppL10n.of(context);
    final v = await showDialog<AdsConsent>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.adsAndTracking),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, AdsConsent.personalized),
            child: Text(l.consentPersonalized),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, AdsConsent.nonPersonalized),
            child: Text(l.consentNonPersonalized),
          ),
        ],
      ),
    );
    if (v != null) {
      ref.read(settingsProvider.notifier).setAdsConsent(v);
      await ref.read(adsProvider.notifier).init();
    }
  }
}
