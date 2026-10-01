import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_tokens.dart';

/// Ação destrutiva: segurar 800 ms com preenchimento visível. Soltar antes cancela.
class HoldToConfirmButton extends StatefulWidget {
  const HoldToConfirmButton({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.icon,
    this.haptics = true,
  });
  final String label;
  final VoidCallback onConfirmed;
  final FaIconData? icon;
  final bool haptics;

  @override
  State<HoldToConfirmButton> createState() => _HoldToConfirmButtonState();
}

class _HoldToConfirmButtonState extends State<HoldToConfirmButton> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: AppMotion.holdToConfirm)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) {
        if (widget.haptics) HapticFeedback.heavyImpact();
        _c.value = 0;
        widget.onConfirmed();
      }
    });

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _cancel() {
    if (_c.status != AnimationStatus.completed) _c.animateBack(0, duration: const Duration(milliseconds: 160));
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      onTap: widget.onConfirmed, // leitor de tela: toque duplo confirma (segurar é inviável)
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _c.forward(),
        onTapUp: (_) => _cancel(),
        onTapCancel: _cancel,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.button, minWidth: 120),
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) => DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.danger, width: 2),
                color: AppColors.dangerBg,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: _c.value,
                          heightFactor: 1,
                          child: ColoredBox(color: AppColors.danger.withValues(alpha: 0.38)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            FaIcon(widget.icon, size: 16, color: AppColors.dangerFg),
                            const SizedBox(width: 10),
                          ],
                          Flexible(
                            child: Text(
                              widget.label,
                              textAlign: TextAlign.center,
                              style: AppType.label.copyWith(color: AppColors.dangerFg, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
