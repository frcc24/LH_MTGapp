import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/core/theme/app_tokens.dart';
import 'package:magiccounter/features/mana/mana_logic.dart';

void main() {
  int sum(Map<ManaColor, int> m) => m.values.fold(0, (a, b) => a + b);

  test('a soma fecha no total para qualquer combinação', () {
    for (var total = 1; total <= 40; total++) {
      for (final s in [
        {ManaColor.white: 7, ManaColor.blue: 5, ManaColor.black: 3},
        {ManaColor.red: 1, ManaColor.green: 1, ManaColor.blue: 1},
        {ManaColor.green: 13},
        {ManaColor.white: 2, ManaColor.red: 9, ManaColor.colorless: 4},
      ]) {
        expect(sum(landsPerColor(total, s)), total, reason: 'total=$total $s');
      }
    }
  });

  test('proporcional e sem terrenos para cor sem símbolo', () {
    final r = landsPerColor(24, {ManaColor.white: 10, ManaColor.red: 5});
    expect(r[ManaColor.white], 16);
    expect(r[ManaColor.red], 8);
    expect(r[ManaColor.blue], 0);
  });

  test('sem símbolos devolve zeros', () {
    expect(sum(landsPerColor(24, {})), 0);
  });
}
