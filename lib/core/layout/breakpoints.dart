import 'package:flutter/widgets.dart';

enum WindowClass { compact, medium, expanded }

/// compact < 600, medium 600–839, expanded ≥ 840 (largura em pt lógicos).
WindowClass windowClassOf(double width) {
  if (width < 600) return WindowClass.compact;
  if (width < 840) return WindowClass.medium;
  return WindowClass.expanded;
}

extension WindowClassContext on BuildContext {
  WindowClass get windowClass => windowClassOf(MediaQuery.sizeOf(this).width);
  bool get isTablet => windowClass != WindowClass.compact;
}
