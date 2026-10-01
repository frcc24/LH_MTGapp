import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/theme_x.dart';

/// Número grande da vida. Dígitos tabulares; só os dígitos que mudam rolam.
class LifeNumber extends StatefulWidget {
  const LifeNumber({super.key, required this.value, required this.color, required this.fontSize, this.dim = false});
  final int value;
  final Color color;
  final double fontSize;
  final bool dim;

  /// tamanho = min(altura útil × 0,62, largura útil × (≤2 dígitos ? 0,55 : 0,40)), entre 40 e 260.
  static double sizeFor(double usableHeight, double usableWidth, int digits) {
    final byW = usableWidth * (digits <= 2 ? 0.55 : 0.40);
    return math.min(usableHeight * 0.62, byW).clamp(40.0, 260.0);
  }

  @override
  State<LifeNumber> createState() => _LifeNumberState();
}

class _LifeNumberState extends State<LifeNumber> {
  int _dir = 1; // 1 = ganhou (antigo sobe), -1 = perdeu (antigo desce)

  @override
  void didUpdateWidget(LifeNumber old) {
    super.didUpdateWidget(old);
    if (widget.value != old.value) _dir = widget.value > old.value ? 1 : -1;
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.value.toString();
    final base = AppType.lifeXL.copyWith(
      fontSize: widget.fontSize,
      color: widget.dim ? AppColors.textFaint : AppColors.text,
      shadows: widget.dim
          ? null
          : [
              Shadow(
                color: widget.color.withValues(alpha: 0.33),
                blurRadius: math.min(44, math.max(28, widget.fontSize * 0.2)),
              ),
            ],
    );
    final duration = context.motion(AppMotion.numberRoll);
    final reduce = context.reduceMotion;
    return Semantics(
      liveRegion: true,
      excludeSemantics: true,
      label: '${widget.value}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [for (var i = 0; i < text.length; i++) _digit(text, i, base, duration, reduce)],
      ),
    );
  }

  Widget _digit(String text, int i, TextStyle base, Duration duration, bool reduce) {
    // Chave pela posição contada da direita: "31" -> "30" só anima o último dígito.
    final key = ValueKey('${text.length - i}:${text[i]}');
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: AppMotion.standard,
      switchOutCurve: AppMotion.exit,
      layoutBuilder: (cur, prev) => Stack(alignment: Alignment.center, children: [...prev, if (cur != null) cur]),
      transitionBuilder: (child, anim) {
        if (reduce) return FadeTransition(opacity: anim, child: child);
        final incoming = child.key == key;
        // entrada: vem de baixo (ganho) ou de cima (perda); saída: o inverso
        final from = Offset(0, incoming ? 0.5 * _dir : -0.5 * _dir);
        return FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween(begin: from, end: Offset.zero).animate(anim),
            child: child,
          ),
        );
      },
      child: Text(text[i], key: key, style: base),
    );
  }
}
