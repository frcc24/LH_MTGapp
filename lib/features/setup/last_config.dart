import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../match/domain/formats.dart';
import '../match/domain/models.dart';

const _key = 'last_config';

/// Última configuração usada: "Nova partida" na Home começa direto com ela.
class LastConfigNotifier extends Notifier<GameConfig?> {
  @override
  GameConfig? build() {
    final s = ref.watch(sharedPreferencesProvider).getString(_key);
    if (s == null) return null;
    try {
      return GameConfig.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  void save(GameConfig c) {
    state = c;
    ref.read(sharedPreferencesProvider).setString(_key, jsonEncode(c.toJson()));
  }
}

final lastConfigProvider = NotifierProvider<LastConfigNotifier, GameConfig?>(LastConfigNotifier.new);

List<PlayerConfig> defaultPlayers(AppL10n l, int n, {List<PlayerConfig> keep = const []}) => [
  for (var i = 0; i < n; i++)
    i < keep.length
        ? keep[i]
        : PlayerConfig(
            id: 'p$i',
            name: l.playerDefault(i + 1),
            color: PlayerColor.values[i % PlayerColor.values.length],
          ),
];

GameConfig defaultConfig(AppL10n l) => GameConfig(
  formatId: 'standard',
  startingLife: 20,
  players: defaultPlayers(l, 2),
  enabledCounters: formatById('standard').counters,
);

/// Linha curta da configuração: "Commander · 4 jogadores · 40 de vida".
String configSummary(AppL10n l, GameConfig c) {
  final f = formatById(c.formatId);
  final name = f.isCustom ? l.formatCustom : f.name;
  return '$name · ${l.playersCount(c.players.length)} · ${l.lifeTotal(c.startingLife)}';
}
