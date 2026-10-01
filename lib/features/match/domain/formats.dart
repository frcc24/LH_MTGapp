import 'models.dart';

/// Preset de formato. Nomes próprios ficam fixos; "Livre" é traduzido na interface (`isCustom`).
class FormatPreset {
  const FormatPreset({
    required this.id,
    required this.name,
    required this.life,
    required this.counters,
    this.lifeMulti,
    this.teamsOnly = false,
    this.isCustom = false,
  });

  final String id;
  final String name;
  final int life;

  /// Vida quando há 3 ou mais jogadores (Brawl).
  final int? lifeMulti;
  final Set<CounterType> counters;
  final bool teamsOnly;
  final bool isCustom;

  int lifeFor(int players) => players >= 3 && lifeMulti != null ? lifeMulti! : life;

  /// Numero de jogadores aceitos pelo formato.
  bool supports(int players) => teamsOnly ? players == 4 : players >= 1 && players <= 4;
}

const formatPresets = <FormatPreset>[
  FormatPreset(id: 'standard', name: 'Standard', life: 20, counters: {}),
  FormatPreset(id: 'modern', name: 'Modern', life: 20, counters: {}),
  FormatPreset(id: 'legacy', name: 'Legacy', life: 20, counters: {}),
  FormatPreset(id: 'pauper', name: 'Pauper', life: 20, counters: {}),
  FormatPreset(
    id: 'commander',
    name: 'Commander',
    life: 40,
    counters: {CounterType.commander, CounterType.poison, CounterType.monarch},
  ),
  FormatPreset(id: 'brawl', name: 'Brawl', life: 25, lifeMulti: 30, counters: {CounterType.commander}),
  FormatPreset(id: 'thg', name: 'Two-Headed Giant', life: 30, counters: {CounterType.poison}, teamsOnly: true),
  FormatPreset(id: 'oathbreaker', name: 'Oathbreaker', life: 20, counters: {CounterType.commander, CounterType.poison}),
  FormatPreset(id: 'custom', name: 'Livre', life: 20, counters: {}, isCustom: true),
];

FormatPreset formatById(String id) => formatPresets.firstWhere((f) => f.id == id, orElse: () => formatPresets.first);

/// Contadores que podem ser ligados na configuração, na ordem em que aparecem.
const toggleableCounters = <CounterType>[
  CounterType.poison,
  CounterType.commander,
  CounterType.energy,
  CounterType.experience,
  CounterType.radiation,
  CounterType.monarch,
  CounterType.initiative,
  CounterType.dayNight,
  CounterType.ring,
];
