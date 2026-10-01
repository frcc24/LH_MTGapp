import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Rótulo de seção em caixa alta com espaçamento largo.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.text, {super.key, this.trailing});
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 10),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(text.toUpperCase(), style: AppType.overline.copyWith(color: AppColors.textMuted)),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}
