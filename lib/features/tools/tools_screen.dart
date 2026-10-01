import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../monetization/pro_state.dart';
import 'tools_panel.dart';

/// Ferramentas abertas pela Home (com banner para quem não é Pro).
class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppL10n.of(context).tools)),
      body: SafeArea(child: ToolsPanel(showBanner: !pro)),
    );
  }
}
