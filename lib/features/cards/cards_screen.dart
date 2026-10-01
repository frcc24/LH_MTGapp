import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/links.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/mana_token.dart';
import 'scryfall.dart';

/// Custo da carta ({2}{G}{G}) em símbolos de mana de verdade.
class ManaCost extends StatelessWidget {
  const ManaCost(this.cost, {super.key, this.size = 20});
  final String cost;
  final double size;

  @override
  Widget build(BuildContext context) {
    final symbols = RegExp(r'\{([^}]+)\}').allMatches(cost).map((m) => m.group(1)!).toList();
    return Wrap(spacing: 3, children: [for (final s in symbols) ManaSymbol(s, size: size)]);
  }
}

enum _Status { idle, loading, loaded, empty, error }

class CardsScreen extends ConsumerStatefulWidget {
  const CardsScreen({super.key});

  @override
  ConsumerState<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends ConsumerState<CardsScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  Timer? _debounce;
  _Status _status = _Status.idle;
  final Set<String> _colors = {};
  String? _type;
  int? _maxMv;
  List<ScryCard> _cards = [];
  String? _next;
  int _total = 0;
  List<String> _suggestions = [];
  int _seq = 0;

  static const _types = ['creature', 'instant', 'sorcery', 'artifact', 'enchantment', 'land', 'planeswalker'];

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 400) _more();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  bool get _hasQuery => _ctrl.text.trim().length >= 2 || _colors.isNotEmpty || _type != null || _maxMv != null;

  void _schedule() {
    _debounce?.cancel();
    if (!_hasQuery) {
      setState(() => _status = _Status.idle);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), _search);
  }

  Future<void> _search() async {
    final seq = ++_seq;
    setState(() => _status = _Status.loading);
    try {
      final c = ref.read(scryfallProvider);
      final page = await c.search(buildQuery(name: _ctrl.text, colors: _colors, type: _type, maxMv: _maxMv));
      if (seq != _seq || !mounted) return;
      var sugg = <String>[];
      if (page.cards.isEmpty && _ctrl.text.trim().length >= 2) {
        try {
          sugg = (await c.autocomplete(_ctrl.text.trim())).take(5).toList();
        } catch (_) {}
      }
      if (seq != _seq || !mounted) return;
      setState(() {
        _cards = page.cards;
        _next = page.nextPage;
        _total = page.total;
        _suggestions = sugg;
        _status = page.cards.isEmpty ? _Status.empty : _Status.loaded;
      });
    } on DioException {
      if (seq == _seq && mounted) setState(() => _status = _Status.error);
    }
  }

  Future<void> _more() async {
    if (_next == null || _status != _Status.loaded) return;
    final n = _next!;
    _next = null;
    try {
      final page = await ref.read(scryfallProvider).search('', nextPage: n);
      if (!mounted) return;
      setState(() {
        _cards = [..._cards, ...page.cards];
        _next = page.nextPage;
      });
    } on DioException {
      _next = n;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final typeNames = {
      'creature': l.typeCreature,
      'instant': l.typeInstant,
      'sorcery': l.typeSorcery,
      'artifact': l.typeArtifact,
      'enchantment': l.typeEnchantment,
      'land': l.typeLand,
      'planeswalker': l.typePlaneswalker,
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.cards)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, 8),
                  child: TextField(
                    controller: _ctrl,
                    onChanged: (_) => _schedule(),
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: l.searchCardHint,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(14),
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 16),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
                    children: [
                      for (final c in ManaColor.values)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(
                                () => _colors.contains(c.symbol.toLowerCase())
                                    ? _colors.remove(c.symbol.toLowerCase())
                                    : _colors.add(c.symbol.toLowerCase()),
                              );
                              _schedule();
                            },
                            child: Opacity(
                              opacity: _colors.isEmpty || _colors.contains(c.symbol.toLowerCase()) ? 1 : 0.35,
                              child: Padding(padding: const EdgeInsets.all(6), child: ManaToken(c, size: 32)),
                            ),
                          ),
                        ),
                      for (final t in _types)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(typeNames[t]!),
                            selected: _type == t,
                            showCheckmark: false,
                            onSelected: (v) {
                              setState(() => _type = v ? t : null);
                              _schedule();
                            },
                          ),
                        ),
                      ChoiceChip(
                        label: Text(_maxMv == null ? l.manaValueAny : l.manaValueMax(_maxMv!)),
                        selected: _maxMv != null,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() => _maxMv = _maxMv == null ? 3 : (_maxMv! >= 7 ? null : _maxMv! + 1));
                          _schedule();
                        },
                      ),
                    ],
                  ),
                ),
                if (_status == _Status.loading) const LinearProgressIndicator(minHeight: 3, color: AppColors.accent),
                Expanded(child: _body(l)),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: null,
                    child: Text(l.scryfallCredit, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _state(FaIconData icon, String title, String sub, {Widget? action}) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 40, color: AppColors.iconIdle),
          const SizedBox(height: 16),
          Text(title, style: AppType.title, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
            sub,
            style: AppType.body.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: 16), action],
        ],
      ),
    ),
  );

  Widget _body(AppL10n l) {
    switch (_status) {
      case _Status.idle:
        return _state(FontAwesomeIcons.clone, l.cardsIdleTitle, l.cardsIdleSub);
      case _Status.error:
        return _state(
          FontAwesomeIcons.wifi,
          l.networkErrorTitle,
          l.networkErrorSub,
          action: FilledButton(onPressed: _search, child: Text(l.retry)),
        );
      case _Status.empty:
        return _state(
          FontAwesomeIcons.magnifyingGlass,
          l.noResults,
          l.noResultsSub,
          action: _suggestions.isEmpty
              ? null
              : Wrap(
                  spacing: 8,
                  children: [
                    for (final s in _suggestions)
                      ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _ctrl.text = s;
                          _search();
                        },
                      ),
                  ],
                ),
        );
      case _Status.loading || _Status.loaded:
        if (_cards.isEmpty) return ListView(children: [for (var i = 0; i < 6; i++) const _Skeleton()]);
        return ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH),
          itemCount: _cards.length + 1,
          itemBuilder: (_, i) {
            if (i == 0)
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(l.resultsCount(_total), style: AppType.caption.copyWith(color: AppColors.textMuted)),
              );
            final c = _cards[i - 1];
            return _CardTile(
              card: c,
              onTap: () => context.push('/cards/${c.id}', extra: c),
            );
          },
        );
    }
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton();
  @override
  Widget build(BuildContext context) => Container(
    height: 76,
    margin: const EdgeInsets.symmetric(horizontal: AppSpace.screenH, vertical: 5),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.tile)),
  );
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.onTap});
  final ScryCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final f = card.front;
    return Semantics(
      button: true,
      label: '${card.name}, ${f.typeLine}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.tile),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 60,
                child: f.smallUrl == null
                    ? const ColoredBox(color: AppColors.elevated)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: CachedNetworkImage(
                          imageUrl: f.smallUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => const ColoredBox(color: AppColors.elevated),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(card.name, style: AppType.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(
                      f.typeLine,
                      style: AppType.caption.copyWith(color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ManaCost(f.manaCost, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

String scryfallLink(ScryCard c) => c.scryfallUri.isEmpty ? Links.scryfall : c.scryfallUri;
