import 'package:flutter/services.dart';

/// Háptico central. Cada chamada respeita o ajuste do usuário.
class Haptics {
  const Haptics(this.enabled);
  final bool enabled;

  void tick() {
    if (enabled) HapticFeedback.selectionClick();
  }

  void light() {
    if (enabled) HapticFeedback.lightImpact();
  }

  void heavy() {
    if (enabled) HapticFeedback.heavyImpact();
  }
}
