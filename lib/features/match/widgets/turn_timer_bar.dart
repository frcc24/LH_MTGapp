import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.dart';
import '../../../core/theme/theme_x.dart';

/// Barra de 4 pt no topo do painel ativo. Nos últimos 10 s fica vermelha e pulsa.
class TurnTimerBar extends StatefulWidget {
  const TurnTimerBar({super.key, required this.fraction, required this.remainingSeconds});

  /// Restante / total, entre 0 e 1.
  final double fraction;
  final int remainingSeconds;

  @override
  State<TurnTimerBar> createState() => _TurnTimerBarState();
}

class _TurnTimerBarState extends State<TurnTimerBar> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

  bool get _urgent => widget.remainingSeconds <= 10;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(TurnTimerBar old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    if (_urgent && !context.reduceMotion) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, _) {
          final color = _urgent ? AppColors.loss.withValues(alpha: 1 - 0.45 * _pulse.value) : AppColors.accent;
          return SizedBox(
            height: AppSize.timerBar,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: widget.fraction.clamp(0.0, 1.0),
                child: ColoredBox(color: color, child: const SizedBox.expand()),
              ),
            ),
          );
        },
      ),
    );
  }
}
