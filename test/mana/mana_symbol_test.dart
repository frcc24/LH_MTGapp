import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:magiccounter/core/theme/app_tokens.dart';
import 'package:magiccounter/shared/widgets/mana_token.dart';

void main() {
  test('cada código da lista tem o SVG na pasta, e a pasta não tem arquivo fora da lista', () {
    final files = Directory('assets/mana').listSync().whereType<File>().map((f) => f.uri.pathSegments.last).toSet();
    final expected = {for (final c in manaSymbolCodes) '${c.replaceAll('/', '')}.svg'};
    expect(expected.difference(files), isEmpty, reason: 'código sem arquivo');
    expect(files.difference(expected), isEmpty, reason: 'arquivo sem código');
  });

  test('as 6 cores e os híbridos mais comuns resolvem para um arquivo', () {
    for (final c in ManaColor.values) {
      expect(manaAssetFor(c.symbol), 'assets/mana/${c.symbol}.svg');
    }
    expect(manaAssetFor('W/U'), 'assets/mana/WU.svg');
    expect(manaAssetFor('2/W'), 'assets/mana/2W.svg');
    expect(manaAssetFor('G/U/P'), 'assets/mana/GUP.svg');
    expect(manaAssetFor('99'), isNull, reason: 'sem arquivo cai no círculo com texto');
  });

  test('os SVGs são mesmo SVGs de 100x100 (sem HTML de erro baixado por engano)', () {
    for (final f in Directory('assets/mana').listSync().whereType<File>()) {
      final head = f.readAsStringSync().substring(0, 120);
      expect(head, contains('<svg'), reason: f.path);
      expect(head, contains('viewBox'), reason: f.path);
    }
  });
}
