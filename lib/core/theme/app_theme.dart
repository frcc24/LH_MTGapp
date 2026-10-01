import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// Tema do app: o tema base dos tokens mais os componentes que as telas usam (AppBar, chips, segmentados...).
ThemeData buildAppTheme({bool colorBlind = false, bool reduceMotion = false}) {
  final base = buildDarkTheme(colorBlind: colorBlind, reduceMotion: reduceMotion);
  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppType.title.copyWith(color: AppColors.text),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: AppColors.elevated,
      selectedColor: AppColors.accentSoftBg,
      side: const BorderSide(color: AppColors.line),
      labelStyle: AppType.label.copyWith(fontSize: 14, color: AppColors.text),
      shape: const StadiumBorder(),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.accentSoftBg : AppColors.surface,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.accentSoftFg : AppColors.text,
        ),
        side: WidgetStateProperty.resolveWith(
          (s) => BorderSide(color: s.contains(WidgetState.selected) ? AppColors.accent : AppColors.line),
        ),
        textStyle: WidgetStatePropertyAll(AppType.label.copyWith(fontSize: 14)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.elevated,
      contentTextStyle: AppType.label.copyWith(color: AppColors.text),
      actionTextColor: AppColors.accent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.tile)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: AppType.label,
        minimumSize: const Size(0, 48),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(minimumSize: const Size(48, 48), foregroundColor: AppColors.text),
    ),
    listTileTheme: const ListTileThemeData(minVerticalPadding: 12, iconColor: AppColors.textSecondary),
    dividerTheme: const DividerThemeData(color: AppColors.divider),
  );
}
