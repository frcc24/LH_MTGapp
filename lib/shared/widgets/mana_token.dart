import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';

/// Símbolo de mana funcional. Círculo com a letra da cor (fallback documentado no handoff);
/// quando a fonte Mana for adicionada, basta trocar o `child`.
class ManaToken extends StatelessWidget {
  const ManaToken(this.mana, {super.key, this.size = 22, this.label});
  final ManaColor mana;
  final double size;

  /// Texto no lugar da letra (ex.: custo genérico "2").
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: mana.label,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: mana.bg,
          border: mana == ManaColor.black ? Border.all(color: AppColors.manaBlackRing, width: size * 0.07) : null,
        ),
        child: Text(
          label ?? mana.symbol,
          style: TextStyle(
            fontFamily: AppFonts.body,
            fontWeight: FontWeight.w700,
            fontSize: size * 0.55,
            height: 1,
            color: mana.fg,
          ),
        ),
      ),
    );
  }
}

/// Custo genérico (número) em círculo neutro.
class GenericManaToken extends StatelessWidget {
  const GenericManaToken(this.value, {super.key, this.size = 22});
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) => ManaToken(ManaColor.colorless, size: size, label: value);
}
