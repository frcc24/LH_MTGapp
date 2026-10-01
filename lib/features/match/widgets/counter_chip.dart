import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/theme/app_tokens.dart';

enum ChipAlert { none, warn, lethal }

/// Chip de contador: ícone + número. Alvo de toque de 56 pt com a área invisível.
class CounterChip extends StatelessWidget {
  const CounterChip({
    super.key,
    required this.icon,
    required this.value,
    required this.color,
    this.alert = ChipAlert.none,
    this.alertBg = AppColors.poisonAlertBg,
    this.alertFg = AppColors.poisonAlertFg,
    this.label,
    this.lethalLabel,
    this.height = AppSize.chipH,
    this.onTap,
    this.enabled = true,
    this.semanticLabel,
  });

  final FaIconData icon;
  final String value;
  final Color color;
  final ChipAlert alert;
  final Color alertBg;
  final Color alertFg;
  final String? label;
  final String? lethalLabel;
  final double height;
  final VoidCallback? onTap;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final alerted = alert != ChipAlert.none;
    final lethal = alert == ChipAlert.lethal;
    final fg = !enabled ? AppColors.disabled : (alerted ? alertFg : AppColors.text);
    final iconColor = !enabled ? AppColors.disabled : (alerted ? alertFg : color);
    final big = height > AppSize.chipH;
    final chip = AnimatedContainer(
      duration: AppMotion.tap,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: big ? 14 : 10),
      decoration: BoxDecoration(
        color: alerted ? alertBg : AppColors.elevated,
        borderRadius: BorderRadius.circular(height / 2),
        border: lethal ? Border.all(color: alertFg, width: 2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: big ? 18 : 14, color: iconColor),
          const SizedBox(width: 6),
          Text(value, style: (big ? AppType.counterLarge : AppType.counter).copyWith(color: fg)),
          if (lethal && lethalLabel != null) ...[
            const SizedBox(width: 6),
            Text(lethalLabel!, style: AppType.badge.copyWith(color: alertFg)),
          ] else if (label != null) ...[
            const SizedBox(width: 6),
            Text(label!, style: AppType.caption.copyWith(color: AppColors.textMuted)),
          ],
        ],
      ),
    );
    final padded = Padding(
      padding: EdgeInsets.symmetric(vertical: ((AppSize.touchMin - height) / 2).clamp(0, 28)),
      child: chip,
    );
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: onTap == null
          ? padded
          : GestureDetector(behavior: HitTestBehavior.opaque, onTap: enabled ? onTap : null, child: padded),
    );
  }
}
