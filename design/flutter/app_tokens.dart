// Lighthouse Life · tokens da direção "Sinal"
// Fonte da verdade visual. Os valores batem 1:1 com os mockups em design/mockups.
// Copiar para lib/core/theme/app_tokens.dart.

import 'package:flutter/material.dart';

/// Cores base (tema escuro OLED, padrão do app).
abstract final class AppColors {
  // Superfícies, do fundo para cima
  static const bg = Color(0xFF050608); // fundo OLED
  static const surface = Color(0xFF0E1014); // cards, sheets
  static const panel = Color(0xFF0B0D11); // fundo do PlayerPanel
  static const elevated = Color(0xFF161A20); // chips, botões secundários
  static const pressed = Color(0xFF232832); // estado pressionado, aba selecionada
  static const line = Color(0xFF232832); // bordas 1px
  static const lineStrong = Color(0xFF2C323C); // borda do hub e de diálogos
  static const divider = Color(0xFF1A1E25);
  static const dragHandle = Color(0xFF3A414D);
  static const adPlaceholderBorder = Color(0xFF343B46); // borda tracejada do espaço do banner
  static const manaBlackRing = Color(0xFF6B625F); // contorno do token de mana preta sobre fundo escuro
  static const toolSelectedBg = Color(0xFF0B2A33); // dado selecionado em Ferramentas
  static const legalText = Color(0xFFD5DAE0); // aviso legal em Sobre

  // Texto
  static const text = Color(0xFFF3F5F7);
  static const textSecondary = Color(0xFFB7BFCA);
  static const textMuted = Color(0xFF9AA3AF); // legendas (>= 4.5:1 sobre bg)
  static const textFaint = Color(0xFF7C8593); // rodapés pequenos (>= 4.5:1 sobre bg)
  static const iconIdle = Color(0xFF6B7480); // glifos +/- dentro do painel (decorativos)
  static const disabled = Color(0xFF4B525C);

  // Marca
  static const accent = Color(0xFFFFB020); // âmbar do farol
  static const onAccent = Color(0xFF1A1204);
  static const accentSoftBg = Color(0xFF1F1806); // fundo de item selecionado
  static const accentSoftFg = Color(0xFFFFD27A);

  // Semânticas
  static const gain = Color(0xFF7CF0B0); // delta positivo
  static const loss = Color(0xFFFF8A8A); // delta negativo
  static const danger = Color(0xFFFF6B6B);
  static const dangerBg = Color(0xFF2A1012);
  static const dangerFg = Color(0xFFFFD0D0);
  static const cmdAlertBg = Color(0xFF2A0F18);
  static const cmdAlertFg = Color(0xFFFFB3CB);
  static const poisonAlertBg = Color(0xFF1E2A0F);
  static const poisonAlertFg = Color(0xFFC9F2A4);

  // Ícones de contador
  static const poison = Color(0xFF9BE15D);
  static const energy = Color(0xFF22C7F0);
  static const experience = Color(0xFFA78BFA);
  static const radiation = Color(0xFFFFB020);
  static const commander = Color(0xFFFF4F8B);
}

/// Cor + ícone + nome: um jogador nunca é identificado só pela cor.
enum PlayerColor {
  amber('Âmbar', Color(0xFFFFB020), PlayerGlyph.flame, BorderDash.solid),
  cyan('Ciano', Color(0xFF22C7F0), PlayerGlyph.drop, BorderDash.dashed),
  magenta('Magenta', Color(0xFFFF4F8B), PlayerGlyph.gem, BorderDash.double),
  lime('Lima', Color(0xFF9BE15D), PlayerGlyph.leaf, BorderDash.dotted),
  violet('Violeta', Color(0xFFA78BFA), PlayerGlyph.star, BorderDash.solid),
  ice('Gelo', Color(0xFFE8EDF2), PlayerGlyph.shield, BorderDash.dashed);

  const PlayerColor(this.label, this.color, this.glyph, this.colorBlindDash);
  final String label;
  final Color color;
  final PlayerGlyph glyph;
  final BorderDash colorBlindDash; // usado só no modo daltônico

  Color get glowSoft => color.withValues(alpha: 0.18); // sombra parada
  Color get glowActive => color.withValues(alpha: 0.40); // sombra do jogador ativo
  Color get ring => color.withValues(alpha: 0.33); // anel de 3px do ativo
  Color get tint => color.withValues(alpha: 0.14); // centro do gradiente radial
}

enum PlayerGlyph { flame, drop, gem, leaf, star, shield }

enum BorderDash { solid, dashed, double, dotted }

/// Cores de mana. Glifo vem da fonte Mana (SIL OFL); letra é fallback.
enum ManaColor {
  white('W', 'Branco', Color(0xFFF6E7BE), Color(0xFF2A2416)),
  blue('U', 'Azul', Color(0xFF5AA9E6), Color(0xFF08182A)),
  black('B', 'Preto', Color(0xFF4A4240), Color(0xFFF3EDEA)),
  red('R', 'Vermelho', Color(0xFFEE6A4D), Color(0xFF2A0D06)),
  green('G', 'Verde', Color(0xFF3FB273), Color(0xFF062014)),
  colorless('C', 'Incolor', Color(0xFFBEB6AE), Color(0xFF1E1A16));

  const ManaColor(this.symbol, this.label, this.bg, this.fg);
  final String symbol;
  final String label;
  final Color bg;
  final Color fg;
}

abstract final class AppFonts {
  static const display = 'BigShouldersDisplay'; // números (vida, contadores, títulos curtos)
  static const body = 'InstrumentSans'; // todo o resto
}

/// Tipografia. Números sempre com algarismos tabulares.
abstract final class AppType {
  static const _tab = [FontFeature.tabularFigures()];

  // LifeNumber: tamanho calculado pelo painel (ver LifeNumber.sizeFor). Estes são os degraus de referência.
  static const lifeXL = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 210, height: 0.85, fontFeatures: _tab);
  static const lifeL = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 112, height: 0.88, fontFeatures: _tab);
  static const lifeM = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 72, height: 0.9, fontFeatures: _tab);
  static const lifeS = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 40, height: 0.9, fontFeatures: _tab);

  static const delta = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 32, height: 1, fontFeatures: _tab);
  static const counter = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 22, height: 1, fontFeatures: _tab);
  static const counterLarge = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w800, fontSize: 30, height: 1, fontFeatures: _tab);
  static const heroTitle = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w900, fontSize: 58, height: 0.9);
  static const screenTitleDisplay = TextStyle(fontFamily: AppFonts.display, fontWeight: FontWeight.w900, fontSize: 44, height: 0.95);

  static const title = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w700, fontSize: 22);
  static const bodyLarge = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w400, fontSize: 17, height: 1.5);
  static const body = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w400, fontSize: 15, height: 1.5);
  static const label = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w600, fontSize: 16);
  static const labelSmall = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w600, fontSize: 13);
  static const caption = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w400, fontSize: 12);
  static const overline = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 1.8); // 0.14em, CAIXA ALTA
  static const badge = TextStyle(fontFamily: AppFonts.body, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.9);
}

abstract final class AppSpace {
  static const s2 = 2.0, s4 = 4.0, s6 = 6.0, s8 = 8.0, s10 = 10.0, s12 = 12.0, s14 = 14.0;
  static const s16 = 16.0, s18 = 18.0, s20 = 20.0, s24 = 24.0, s28 = 28.0, s32 = 32.0, s48 = 48.0;
  static const screenH = 20.0; // margem lateral das telas comuns
  static const matchGutter = 8.0; // espaço entre painéis no celular
  static const matchGutterTablet = 12.0;
}

abstract final class AppRadius {
  static const chip = 14.0; // chips de 28px de altura
  static const pill = 999.0;
  static const tile = 18.0; // CardTile, linhas de lista
  static const card = 22.0; // cards, grupos de ajustes
  static const panel = 24.0; // PlayerPanel 4J
  static const panelLarge = 28.0; // PlayerPanel 1-2J, sheets
  static const dialog = 30.0;
  static const appIcon = 0.22; // fração do lado (22%)
}

abstract final class AppSize {
  static const touchMin = 56.0; // mínimo da casa (acima dos 44/48 das plataformas)
  static const touchIdeal = 72.0;
  static const button = 56.0;
  static const buttonHero = 64.0;
  static const hub = 76.0; // botão central no celular
  static const hubTablet = 88.0;
  static const chipH = 28.0; // chip dentro do painel
  static const counterChipH = 40.0; // fora do painel; alvo de toque continua 56
  static const timerBar = 4.0;
}

abstract final class AppShadow {
  static List<BoxShadow> panelIdle(Color c) => [BoxShadow(color: c.withValues(alpha: 0.18), blurRadius: 16)];
  static List<BoxShadow> panelActive(Color c) => [
        BoxShadow(color: c.withValues(alpha: 0.33), spreadRadius: 3),
        BoxShadow(color: c.withValues(alpha: 0.40), blurRadius: 34),
      ];
  static const hubGlow = [BoxShadow(color: Color(0x59FFB020), blurRadius: 30)];
  static const dialog = [BoxShadow(color: Color(0x99000000), blurRadius: 80, offset: Offset(0, 24))];
}

abstract final class AppMotion {
  static const tap = Duration(milliseconds: 90); // feedback de toque
  static const numberRoll = Duration(milliseconds: 180);
  static const lossPulse = Duration(milliseconds: 220);
  static const gainWave = Duration(milliseconds: 420);
  static const deltaIn = Duration(milliseconds: 120);
  static const deltaHold = Duration(milliseconds: 2000); // conta a partir da última mudança
  static const deltaOut = Duration(milliseconds: 250);
  static const sheet = Duration(milliseconds: 280);
  static const page = Duration(milliseconds: 300);
  static const holdToConfirm = Duration(milliseconds: 800);
  static const holdRepeatDelay = Duration(milliseconds: 450);
  static const holdRepeatSlow = Duration(milliseconds: 120);
  static const holdRepeatFast = Duration(milliseconds: 60);
  static const endGameDelay = Duration(milliseconds: 1200);
  static const reduced = Duration(milliseconds: 100); // quando "reduzir movimento" está ativo

  static const standard = Curves.easeOutCubic;
  static const emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const exit = Curves.easeInCubic;
}

/// ThemeExtension para acessar tokens dentro dos widgets: Theme.of(context).extension<LhTokens>()!
@immutable
class LhTokens extends ThemeExtension<LhTokens> {
  const LhTokens({required this.colorBlind, required this.reduceMotion});
  final bool colorBlind;
  final bool reduceMotion;

  Duration motion(Duration d) => reduceMotion ? AppMotion.reduced : d;

  @override
  LhTokens copyWith({bool? colorBlind, bool? reduceMotion}) =>
      LhTokens(colorBlind: colorBlind ?? this.colorBlind, reduceMotion: reduceMotion ?? this.reduceMotion);

  @override
  LhTokens lerp(LhTokens? other, double t) => other ?? this;
}

ThemeData buildDarkTheme({bool colorBlind = false, bool reduceMotion = false}) {
  final scheme = const ColorScheme.dark(
    surface: AppColors.bg,
    onSurface: AppColors.text,
    primary: AppColors.accent,
    onPrimary: AppColors.onAccent,
    secondary: AppColors.energy,
    error: AppColors.danger,
    outline: AppColors.line,
    surfaceContainerHighest: AppColors.elevated,
    surfaceContainer: AppColors.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    fontFamily: AppFonts.body,
    splashFactory: InkSparkle.splashFactory,
    extensions: [LhTokens(colorBlind: colorBlind, reduceMotion: reduceMotion)],
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, AppSize.button),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        textStyle: AppType.label.copyWith(fontWeight: FontWeight.w700),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppSize.button),
        backgroundColor: AppColors.elevated,
        foregroundColor: AppColors.text,
        side: const BorderSide(color: AppColors.line),
        shape: const StadiumBorder(),
        textStyle: AppType.label,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.dialog))),
      showDragHandle: true,
      dragHandleColor: AppColors.dragHandle,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.dialog))),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.onAccent : AppColors.textMuted),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? AppColors.accent : AppColors.pressed),
    ),
  );
}
