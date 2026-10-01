import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/theme_x.dart';

/// "−3" / "+5". O sinal sempre aparece (não depende de cor).
class DeltaBadge extends StatelessWidget {
  const DeltaBadge({super.key, required this.delta, this.fontSize = 32, this.preview = false});

  /// null ou 0 esconde.
  final int? delta;
  final double fontSize;

  /// Prévia durante o arraste: mais apagado.
  final bool preview;

  static String format(int d) => d > 0 ? '+$d' : '−${d.abs()}';

  @override
  Widget build(BuildContext context) {
    final d = delta ?? 0;
    final visible = d != 0;
    return ExcludeSemantics(
      child: AnimatedOpacity(
        opacity: visible ? (preview ? 0.7 : 1) : 0,
        duration: context.motion(visible ? AppMotion.deltaIn : AppMotion.deltaOut),
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, 0.2),
          duration: context.motion(AppMotion.deltaIn),
          child: Text(
            visible ? format(d) : ' ',
            style: AppType.delta.copyWith(fontSize: fontSize, color: d < 0 ? AppColors.loss : AppColors.gain),
          ),
        ),
      ),
    );
  }
}
