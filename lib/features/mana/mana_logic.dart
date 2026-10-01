import '../../core/theme/app_tokens.dart';

/// Terrenos por cor, proporcionais aos símbolos de mana. Método do maior resto:
/// a soma sempre fecha exatamente em [totalLands].
Map<ManaColor, int> landsPerColor(int totalLands, Map<ManaColor, int> symbols) {
  final sum = symbols.values.fold<int>(0, (a, b) => a + b);
  if (sum <= 0 || totalLands <= 0) return {for (final c in ManaColor.values) c: 0};
  final out = <ManaColor, int>{};
  final rem = <ManaColor, double>{};
  var given = 0;
  for (final c in ManaColor.values) {
    final exact = totalLands * (symbols[c] ?? 0) / sum;
    out[c] = exact.floor();
    rem[c] = exact - exact.floor();
    given += out[c]!;
  }
  final order = ManaColor.values.toList()
    ..sort((a, b) {
      final d = rem[b]!.compareTo(rem[a]!);
      return d != 0 ? d : (symbols[b] ?? 0).compareTo(symbols[a] ?? 0);
    });
  for (var i = 0; given < totalLands; i = (i + 1) % order.length) {
    if ((symbols[order[i]] ?? 0) == 0) continue;
    out[order[i]] = out[order[i]]! + 1;
    given++;
  }
  return out;
}
