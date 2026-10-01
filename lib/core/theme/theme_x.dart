import 'package:flutter/material.dart';

import 'app_tokens.dart';

extension ThemeX on BuildContext {
  LhTokens get lh => Theme.of(this).extension<LhTokens>() ?? const LhTokens(colorBlind: false, reduceMotion: false);

  /// Duração respeitando "reduzir movimento" do sistema ou do app.
  Duration motion(Duration d) => (lh.reduceMotion || MediaQuery.disableAnimationsOf(this)) ? AppMotion.reduced : d;

  bool get reduceMotion => lh.reduceMotion || MediaQuery.disableAnimationsOf(this);
}
