import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_tokens.dart';

/// Códigos de símbolo que têm arquivo em `assets/mana/` (SVGs da Scryfall; "W/U" vira `WU.svg`).
/// O teste `mana_symbol_test.dart` garante que esta lista e a pasta andam juntas.
const manaSymbolCodes = <String>{
  'W', 'U', 'B', 'R', 'G', 'C', 'X', 'S',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16',
  'W/U', 'W/B', 'B/R', 'B/G', 'U/B', 'U/R', 'R/G', 'R/W', 'G/W', 'G/U', //
  'C/W', 'C/U', 'C/B', 'C/R', 'C/G',
  '2/W', '2/U', '2/B', '2/R', '2/G',
  'W/P', 'U/P', 'B/P', 'R/P', 'G/P', 'G/U/P', 'G/W/P',
};

/// Caminho do SVG do símbolo (`W`, `W/U`, `10`...) ou null se não houver arquivo.
String? manaAssetFor(String code) =>
    manaSymbolCodes.contains(code) ? 'assets/mana/${code.replaceAll('/', '')}.svg' : null;

/// Símbolo de mana de verdade (SVG). Sem arquivo para o código, cai no círculo cinza com o texto.
/// Só como elemento funcional da interface (custo de carta, cor, calculadora).
class ManaSymbol extends StatelessWidget {
  const ManaSymbol(this.code, {super.key, this.size = 22, this.semanticLabel});
  final String code;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final asset = manaAssetFor(code);
    return Semantics(
      label: semanticLabel ?? code,
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: asset != null
            ? SvgPicture.asset(asset, width: size, height: size)
            : DecoratedBox(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.textMuted),
                child: Center(
                  child: Text(
                    code,
                    style: TextStyle(
                      fontFamily: AppFonts.body,
                      fontWeight: FontWeight.w700,
                      fontSize: size * 0.4,
                      height: 1,
                      color: AppColors.bg,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

/// Uma das 6 cores (W, U, B, R, G, C) com o nome para leitores de tela.
class ManaToken extends StatelessWidget {
  const ManaToken(this.mana, {super.key, this.size = 22});
  final ManaColor mana;
  final double size;

  @override
  Widget build(BuildContext context) => ManaSymbol(mana.symbol, size: size, semanticLabel: mana.label);
}
