import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/theme/glyphs.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/lh_stepper.dart';
import '../../shared/widgets/section_header.dart';
import '../match/domain/formats.dart';
import '../match/domain/game_controller.dart';
import '../match/domain/models.dart';
import '../settings/settings_state.dart';
import 'last_config.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  late GameConfig _c;
  bool _lifeEdited = false;
  bool _init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) return;
    _init = true;
    final l = AppL10n.of(context);
    _c = ref.read(lastConfigProvider) ?? defaultConfig(l);
    final timer = ref.read(settingsProvider).defaultTimerSeconds;
    if (ref.read(lastConfigProvider) == null && timer > 0) _c = _c.copyWith(turnTimerSeconds: timer);
    _lifeEdited =
        !formatById(_c.formatId).isCustom && _c.startingLife != formatById(_c.formatId).lifeFor(_c.players.length);
  }

  FormatPreset get _format => formatById(_c.formatId);

  void _setPlayers(int n) {
    final l = AppL10n.of(context);
    setState(() {
      final players = defaultPlayers(l, n, keep: _c.players);
      _c = _c.copyWith(
        players: players,
        startingLife: _lifeEdited || _format.isCustom ? _c.startingLife : _format.lifeFor(n),
        clearTeams: !(n == 4 && _c.hasTeams),
      );
      if (_c.hasTeams) _c = _c.copyWith(teams: _teamsFor(players));
    });
  }

  List<List<String>> _teamsFor(List<PlayerConfig> p) => [
    [p[0].id, p[1].id],
    [p[2].id, p[3].id],
  ];

  void _setFormat(FormatPreset f) {
    final l = AppL10n.of(context);
    setState(() {
      var n = _c.players.length;
      if (!f.supports(n)) n = 4;
      final players = defaultPlayers(l, n, keep: _c.players);
      _lifeEdited = false;
      _c = _c.copyWith(
        formatId: f.id,
        players: players,
        startingLife: f.isCustom ? _c.startingLife : f.lifeFor(n),
        enabledCounters: f.isCustom ? _c.enabledCounters : f.counters,
        teams: f.teamsOnly ? _teamsFor(players) : null,
        clearTeams: !f.teamsOnly,
      );
    });
  }

  void _toggleCounter(CounterType t) {
    setState(() {
      final s = {..._c.enabledCounters};
      s.contains(t) ? s.remove(t) : s.add(t);
      _c = _c.copyWith(enabledCounters: s);
    });
  }

  Future<int?> _askInt(String title, int initial) async {
    final ctrl = TextEditingController(text: '$initial');
    final l = AppL10n.of(context);
    return showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppType.lifeM,
          textAlign: TextAlign.center,
          onSubmitted: (s) => Navigator.pop(ctx, int.tryParse(s)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, int.tryParse(ctrl.text)), child: Text(l.ok)),
        ],
      ),
    );
  }

  Future<void> _editPlayer(int i) async {
    final l = AppL10n.of(context);
    final p = _c.players[i];
    final name = TextEditingController(text: p.name);
    final deck = TextEditingController(text: p.deck ?? '');
    var color = p.color;
    final used = {
      for (final q in _c.players)
        if (q.id != p.id) q.color,
    };
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text(l.editPlayer),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  maxLength: 16,
                  decoration: InputDecoration(labelText: l.nameLabel),
                ),
                TextField(
                  controller: deck,
                  maxLength: 24,
                  decoration: InputDecoration(labelText: l.deckLabel),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final c in PlayerColor.values)
                      Semantics(
                        button: true,
                        selected: c == color,
                        label: c.label,
                        child: GestureDetector(
                          onTap: used.contains(c) ? null : () => setD(() => color = c),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c.tint,
                              border: Border.all(
                                color: used.contains(c) ? AppColors.disabled : c.color,
                                width: c == color ? 4 : 2,
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                c.glyph.icon,
                                size: 16,
                                color: used.contains(c) ? AppColors.disabled : c.color,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
          ],
        ),
      ),
    );
    if (ok == true) {
      setState(() {
        final players = [..._c.players];
        final n = name.text.trim();
        players[i] = p.copyWith(
          name: n.isEmpty ? p.name : n,
          color: color,
          deck: deck.text.trim(),
          clearDeck: deck.text.trim().isEmpty,
        );
        _c = _c.copyWith(players: players);
      });
    }
  }

  void _start() {
    final cfg = _c.copyWith(starter: _c.starter, layoutVariant: _c.layoutVariant);
    ref.read(lastConfigProvider.notifier).save(cfg);
    ref.read(matchControllerProvider.notifier).start(cfg);
    context.go('/match');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final n = _c.players.length;
    final timers = const [0, 60, 90, 120];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 12, AppSpace.screenH, 0),
              child: Row(
                children: [
                  IconButton.outlined(
                    onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                    tooltip: l.back,
                    icon: const FaIcon(FontAwesomeIcons.chevronLeft, size: 16),
                  ),
                  const SizedBox(width: 14),
                  Text(l.newMatch, style: AppType.title.copyWith(fontSize: 26)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 8, AppSpace.screenH, 24),
                children: [
                  SectionHeader(l.playersLabel),
                  Row(
                    children: [
                      for (var i = 1; i <= 4; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i < 4 ? 10 : 0),
                            child: _Tile(
                              selected: n == i,
                              enabled: _format.supports(i) || _format.teamsOnly,
                              onTap: () => _format.supports(i) ? _setPlayers(i) : null,
                              height: 64,
                              semantics: l.playersCount(i),
                              child: Center(child: Text('$i', style: AppType.lifeS.copyWith(fontSize: 32))),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SectionHeader(l.formatLabel),
                  LayoutBuilder(
                    builder: (context, box) {
                      final cols = box.maxWidth > 560 ? 4 : 3;
                      final w = (box.maxWidth - (cols - 1) * 10) / cols;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final f in formatPresets)
                            SizedBox(
                              width: w,
                              child: _Tile(
                                selected: _c.formatId == f.id,
                                height: 92,
                                onTap: () => _setFormat(f),
                                semantics: '${f.isCustom ? l.formatCustom : f.name} ${f.isCustom ? '' : f.lifeFor(n)}',
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        f.isCustom ? l.formatCustom : f.name,
                                        style: AppType.labelSmall,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        f.isCustom ? '—' : '${f.lifeFor(n)}',
                                        style: AppType.lifeS.copyWith(fontSize: 28),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l.startingLife, style: AppType.label.copyWith(fontSize: 18)),
                            Text(l.tapToType, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      LhStepper(
                        value: _c.startingLife,
                        min: 1,
                        max: 999,
                        onChanged: (v) => setState(() {
                          _lifeEdited = true;
                          _c = _c.copyWith(startingLife: v);
                        }),
                        onTapValue: () async {
                          final v = await _askInt(l.startingLife, _c.startingLife);
                          if (v != null && v > 0) {
                            setState(() {
                              _lifeEdited = true;
                              _c = _c.copyWith(startingLife: v);
                            });
                          }
                        },
                        semanticLabel: l.startingLife,
                      ),
                    ],
                  ),
                  SectionHeader(l.whoPlays),
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorderItem: (a, b) => setState(() {
                      final list = [..._c.players];
                      list.insert(b, list.removeAt(a));
                      _c = _c.copyWith(players: list, teams: _c.hasTeams ? _teamsFor(list) : null);
                    }),
                    children: [
                      for (var i = 0; i < n; i++)
                        Padding(
                          key: ValueKey(_c.players[i].id),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _PlayerRow(
                            player: _c.players[i],
                            index: i,
                            starter: _c.starter == StarterMode.chosen && _c.starterId == _c.players[i].id,
                            onTap: () => _editPlayer(i),
                          ),
                        ),
                    ],
                  ),
                  if (n == 4 && !_format.teamsOnly)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l.playTeams, style: AppType.label.copyWith(fontSize: 17)),
                      value: _c.hasTeams,
                      onChanged: (v) => setState(
                        () => _c = v ? _c.copyWith(teams: _teamsFor(_c.players)) : _c.copyWith(clearTeams: true),
                      ),
                    ),
                  SectionHeader(l.countersLabel),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final t in toggleableCounters)
                        FilterChip(
                          selected: _c.has(t),
                          showCheckmark: false,
                          avatar: FaIcon(
                            t.icon,
                            size: 14,
                            color: _c.has(t) ? AppColors.accentSoftFg : AppColors.textMuted,
                          ),
                          label: Text(_counterName(l, t)),
                          selectedColor: AppColors.accentSoftBg,
                          side: BorderSide(color: _c.has(t) ? AppColors.accent : AppColors.line),
                          onSelected: (_) => _toggleCounter(t),
                        ),
                    ],
                  ),
                  SectionHeader(l.turnTimer),
                  SegmentedButton<int>(
                    showSelectedIcon: false,
                    segments: [
                      for (final s in timers) ButtonSegment(value: s, label: Text(s == 0 ? l.noTimer : '${s}s')),
                    ],
                    selected: {_c.turnTimerSeconds ?? 0},
                    onSelectionChanged: (v) => setState(
                      () => _c = v.first == 0 ? _c.copyWith(clearTimer: true) : _c.copyWith(turnTimerSeconds: v.first),
                    ),
                  ),
                  if (n >= 3) ...[
                    SectionHeader(l.layoutLabel),
                    SegmentedButton<LayoutVariant>(
                      showSelectedIcon: false,
                      segments: [
                        ButtonSegment(value: LayoutVariant.standard, label: Text(l.layoutSides)),
                        ButtonSegment(value: LayoutVariant.alternate, label: Text(l.layoutTopFlipped)),
                      ],
                      selected: {_c.layoutVariant},
                      onSelectionChanged: (v) => setState(() => _c = _c.copyWith(layoutVariant: v.first)),
                    ),
                  ],
                  SectionHeader(l.whoStarts),
                  SegmentedButton<StarterMode>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: StarterMode.random, label: Text(l.starterRandom)),
                      ButtonSegment(value: StarterMode.chosen, label: Text(l.starterChoose)),
                    ],
                    selected: {_c.starter},
                    onSelectionChanged: (v) => setState(
                      () => _c = _c.copyWith(starter: v.first, starterId: _c.starterId ?? _c.players.first.id),
                    ),
                  ),
                  if (_c.starter == StarterMode.chosen)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Wrap(
                        spacing: 8,
                        children: [
                          for (final p in _c.players)
                            ChoiceChip(
                              label: Text(p.name),
                              selected: _c.starterId == p.id,
                              onSelected: (_) => setState(() => _c = _c.copyWith(starterId: p.id)),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 8, AppSpace.screenH, 12),
              child: SizedBox(
                width: double.infinity,
                height: AppSize.buttonHero,
                child: FilledButton.icon(
                  onPressed: _start,
                  icon: const FaIcon(FontAwesomeIcons.play, size: 16),
                  label: Text(
                    '${l.startMatch} · ${configSummary(l, _c)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _counterName(AppL10n l, CounterType t) => switch (t) {
  CounterType.poison => l.counterPoison,
  CounterType.energy => l.counterEnergy,
  CounterType.experience => l.counterExperience,
  CounterType.radiation => l.counterRadiation,
  CounterType.commander => l.tabCommander,
  CounterType.monarch => l.counterMonarch,
  CounterType.initiative => l.counterInitiative,
  CounterType.ring => l.counterRing,
  CounterType.dayNight => l.counterDayNight,
};

class _Tile extends StatelessWidget {
  const _Tile({
    required this.selected,
    required this.child,
    required this.onTap,
    this.height = 64,
    this.enabled = true,
    this.semantics,
  });
  final bool selected;
  final bool enabled;
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final String? semantics;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: semantics,
    excludeSemantics: true,
    child: GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: selected ? AppColors.accentSoftBg : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            border: Border.all(color: selected ? AppColors.accent : AppColors.line, width: selected ? 2 : 1),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: selected ? AppColors.accentSoftFg : AppColors.text),
            child: child,
          ),
        ),
      ),
    ),
  );
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({required this.player, required this.index, required this.onTap, this.starter = false});
  final PlayerConfig player;
  final int index;
  final VoidCallback onTap;
  final bool starter;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: player.color.tint,
                border: Border.all(color: player.color.color, width: 2),
              ),
              child: Center(child: FaIcon(player.color.glyph.icon, size: 16, color: player.color.color)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.name, style: AppType.label.copyWith(fontSize: 18)),
                  Text(
                    player.deck == null ? l.noDeck : l.deckIs(player.deck!),
                    style: AppType.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            if (starter) const FaIcon(FontAwesomeIcons.flag, size: 14, color: AppColors.accent),
            ReorderableDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: FaIcon(FontAwesomeIcons.gripLines, size: 16, color: AppColors.iconIdle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
