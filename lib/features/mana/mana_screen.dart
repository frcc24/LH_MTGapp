import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/theme/glyphs.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lh_stepper.dart';
import '../../shared/widgets/mana_token.dart';
import '../../shared/widgets/section_header.dart';
import 'mana_logic.dart';

class ManaScreen extends StatefulWidget {
  const ManaScreen({super.key});

  @override
  State<ManaScreen> createState() => _ManaScreenState();
}

class _ManaScreenState extends State<ManaScreen> {
  int _lands = 24;
  final Map<ManaColor, int> _symbols = {};

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final total = _symbols.values.fold<int>(0, (a, b) => a + b);
    final lands = landsPerColor(_lands, _symbols);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.manaBase),
        actions: [TextButton(onPressed: () => setState(_symbols.clear), child: Text(l.clear))],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, 24),
              children: [
                SectionHeader(l.manaTotalLands),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        children: [
                          ActionChip(label: Text(l.manaHint60), onPressed: () => setState(() => _lands = 24)),
                          ActionChip(label: Text(l.manaHintCommander), onPressed: () => setState(() => _lands = 37)),
                        ],
                      ),
                    ),
                    LhStepper(
                      value: _lands,
                      min: 1,
                      max: 99,
                      onChanged: (v) => setState(() => _lands = v),
                      semanticLabel: l.manaTotalLands,
                    ),
                  ],
                ),
                SectionHeader(l.manaSymbols),
                for (final c in ManaColor.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        ManaToken(c, size: 32),
                        const SizedBox(width: 14),
                        Expanded(child: Text(c.localized(l), style: AppType.label)),
                        LhStepper(
                          compact: true,
                          value: _symbols[c] ?? 0,
                          max: 99,
                          onChanged: (v) => setState(() => _symbols[c] = v),
                          semanticLabel: c.localized(l),
                        ),
                      ],
                    ),
                  ),
                SectionHeader(l.manaResult),
                if (total == 0)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: Text(l.manaEmpty, style: AppType.body.copyWith(color: AppColors.textMuted)),
                  )
                else ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 20,
                      child: Row(
                        children: [
                          for (final c in ManaColor.values)
                            if (lands[c]! > 0)
                              Expanded(
                                flex: lands[c]!,
                                child: ColoredBox(
                                  color: c.bg == ManaColor.black.bg ? AppColors.manaBlackRing : c.bg,
                                  child: const SizedBox.expand(),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final c in ManaColor.values)
                    if (lands[c]! > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            ManaToken(c, size: 26),
                            const SizedBox(width: 12),
                            Expanded(child: Text(c.localized(l), style: AppType.label)),
                            Text('${lands[c]}', style: AppType.counterLarge),
                            SizedBox(
                              width: 64,
                              child: Text(
                                '${(lands[c]! * 100 / _lands).round()}%',
                                textAlign: TextAlign.end,
                                style: AppType.caption.copyWith(color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
