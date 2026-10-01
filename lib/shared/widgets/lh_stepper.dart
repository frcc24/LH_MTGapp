import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_tokens.dart';

/// Pílula − valor +. Botões de 56 pt por padrão; `compact` usa 48.
class LhStepper extends StatelessWidget {
  const LhStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.compact = false,
    this.onTapValue,
    this.format,
    this.semanticLabel,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final int step;
  final bool compact;
  final VoidCallback? onTapValue;
  final String Function(int)? format;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final h = compact ? 48.0 : AppSize.button;
    Widget btn(FaIconData icon, bool enabled, int delta) => Semantics(
      button: true,
      enabled: enabled,
      label: '${semanticLabel ?? ''} ${delta > 0 ? '+' : '-'}$step'.trim(),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? () => onChanged((value + delta).clamp(min, max)) : null,
        child: SizedBox(
          width: h,
          height: h,
          child: Center(child: FaIcon(icon, size: 16, color: enabled ? AppColors.text : AppColors.disabled)),
        ),
      ),
    );
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: AppColors.elevated,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(FontAwesomeIcons.minus, value > min, -step),
          GestureDetector(
            onTap: onTapValue,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: compact ? 44 : 64),
              child: Center(
                child: Text(
                  format?.call(value) ?? '$value',
                  style: compact ? AppType.counterLarge : AppType.lifeS.copyWith(fontSize: 34),
                ),
              ),
            ),
          ),
          btn(FontAwesomeIcons.plus, value < max, step),
        ],
      ),
    );
  }
}
