import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/sounds.dart';
import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../match/domain/game_controller.dart';
import '../monetization/ad_banner.dart';

enum ToolTab { dice, coin, planar, picker, timer }

final _rng = Random();

/// Abre as ferramentas como sheet sobre a partida (sem anúncio).
Future<void> showToolsSheet(BuildContext context, {ToolTab tab = ToolTab.dice}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => SizedBox(
    height: MediaQuery.sizeOf(context).height * 0.85,
    child: ToolsPanel(initial: tab),
  ),
);

/// Rola um d20 direto (toque longo no hub), resultado legível dos dois lados.
Future<void> showD20Roll(BuildContext context) async {
  final v = _rng.nextInt(20) + 1;
  await showDialog<void>(
    context: context,
    builder: (ctx) => GestureDetector(
      onTap: () => Navigator.pop(ctx),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: _BigResult(text: '$v', caption: 'd20'),
        ),
      ),
    ),
  );
}

/// Resultado grande no centro e repetido girado 180° para o outro lado da mesa.
class _BigResult extends StatelessWidget {
  const _BigResult({required this.text, this.caption, this.size = 140});
  final String text;
  final String? caption;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget one() => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: AppType.lifeXL.copyWith(
            fontSize: size,
            color: AppColors.text,
            shadows: [Shadow(color: AppColors.accent.withValues(alpha: 0.4), blurRadius: 36)],
          ),
        ),
        if (caption != null) Text(caption!, style: AppType.overline.copyWith(color: AppColors.textMuted)),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotatedBox(quarterTurns: 2, child: one()),
        const SizedBox(height: 16),
        one(),
      ],
    );
  }
}

class ToolsPanel extends ConsumerStatefulWidget {
  const ToolsPanel({super.key, this.initial = ToolTab.dice, this.showBanner = false});
  final ToolTab initial;

  /// Banner só quando aberta pela Home, nunca dentro da partida.
  final bool showBanner;

  @override
  ConsumerState<ToolsPanel> createState() => _ToolsPanelState();
}

class _ToolsPanelState extends ConsumerState<ToolsPanel> {
  late ToolTab _tab = widget.initial;
  int _sides = 20;
  int _count = 1;
  String _result = '–';
  String _detail = '';
  final List<String> _recent = [];
  bool _rolling = false;
  Timer? _anim;

  // sorteio
  int _pickN = 4;

  // timer
  int _timerTotal = 60;
  int _timerLeft = 60;
  Timer? _timer;
  bool _timerRunning = false;

  @override
  void dispose() {
    _anim?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  /// Anima por ~500 ms e fixa o resultado final.
  void _roll(String Function() make, {String Function()? detail}) {
    if (_rolling) return;
    ref.read(soundProvider).play(Sfx.dice);
    _rolling = true;
    var n = 0;
    _anim?.cancel();
    _anim = Timer.periodic(const Duration(milliseconds: 70), (t) {
      n++;
      if (n >= 7) {
        t.cancel();
        _rolling = false;
        final r = make();
        setState(() {
          _result = r;
          _detail = detail?.call() ?? '';
          _recent.insert(0, r);
          if (_recent.length > 5) _recent.removeLast();
        });
      } else {
        setState(() => _result = make());
      }
    });
  }

  void _rollDice() {
    final rolls = <int>[];
    _roll(() {
      rolls
        ..clear()
        ..addAll([for (var i = 0; i < _count; i++) _rng.nextInt(_sides) + 1]);
      return '${rolls.fold<int>(0, (a, b) => a + b)}';
    }, detail: () => _count > 1 ? rolls.join(' + ') : '');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final tabs = {
      ToolTab.dice: (l.toolDice, FontAwesomeIcons.diceD20),
      ToolTab.coin: (l.toolCoin, FontAwesomeIcons.coins),
      ToolTab.planar: (l.toolPlanar, FontAwesomeIcons.globe),
      ToolTab.picker: (l.toolPicker, FontAwesomeIcons.bullseye),
      ToolTab.timer: (l.toolTimer, FontAwesomeIcons.stopwatch),
    };
    return Column(
      children: [
        SizedBox(
          height: 64,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.screenH, vertical: 8),
            children: [
              for (final e in tabs.entries)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: _tab == e.key,
                    onSelected: (_) => setState(() {
                      _tab = e.key;
                      _result = '–';
                      _detail = '';
                    }),
                    avatar: FaIcon(e.value.$2, size: 14),
                    label: Text(e.value.$1),
                    showCheckmark: false,
                    selectedColor: AppColors.accentSoftBg,
                    side: BorderSide(color: _tab == e.key ? AppColors.accent : AppColors.line),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(padding: const EdgeInsets.all(AppSpace.screenH), child: _body(l)),
        ),
        if (_recent.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(_recent.join('  ·  '), style: AppType.caption.copyWith(color: AppColors.textMuted)),
          ),
        if (widget.showBanner) const AdBanner(),
      ],
    );
  }

  Widget _body(AppL10n l) {
    switch (_tab) {
      case ToolTab.dice:
        return Column(
          children: [
            _BigResult(text: _result, caption: _detail.isEmpty ? 'd$_sides × $_count' : '$_detail  (d$_sides)'),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final s in const [4, 6, 8, 10, 12, 20, 100])
                  ChoiceChip(
                    label: Text('d$s', style: AppType.label),
                    selected: _sides == s,
                    showCheckmark: false,
                    selectedColor: AppColors.toolSelectedBg,
                    side: BorderSide(color: _sides == s ? AppColors.energy : AppColors.line),
                    onSelected: (_) => setState(() => _sides = s),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _count > 1 ? () => setState(() => _count--) : null,
                  icon: const FaIcon(FontAwesomeIcons.minus),
                ),
                Text('$_count ${l.diceCount}', style: AppType.label),
                IconButton(
                  onPressed: _count < 6 ? () => setState(() => _count++) : null,
                  icon: const FaIcon(FontAwesomeIcons.plus),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: _rollDice, child: Text(l.roll)),
          ],
        );
      case ToolTab.coin:
        return Column(
          children: [
            _BigResult(text: _result, size: 96),
            const SizedBox(height: 20),
            FilledButton(onPressed: () => _roll(() => _rng.nextBool() ? l.heads : l.tails), child: Text(l.flip)),
          ],
        );
      case ToolTab.planar:
        // Dado planar: 1 face de caos, 1 de planeswalk, 4 em branco.
        return Column(
          children: [
            _BigResult(text: _result, size: 80),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _roll(() {
                final v = _rng.nextInt(6);
                return v == 0 ? l.planarChaos : (v == 1 ? l.planarWalk : l.planarBlank);
              }),
              child: Text(l.roll),
            ),
          ],
        );
      case ToolTab.picker:
        final game = ref.watch(matchControllerProvider).game;
        final names = game?.config.players.map((p) => p.name).toList();
        final n = names?.length ?? _pickN;
        return Column(
          children: [
            _BigResult(text: _result, size: 72),
            const SizedBox(height: 20),
            if (names == null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _pickN > 2 ? () => setState(() => _pickN--) : null,
                    icon: const FaIcon(FontAwesomeIcons.minus),
                  ),
                  Text('$_pickN', style: AppType.counterLarge),
                  IconButton(
                    onPressed: _pickN < 4 ? () => setState(() => _pickN++) : null,
                    icon: const FaIcon(FontAwesomeIcons.plus),
                  ),
                ],
              ),
            FilledButton(
              onPressed: () => _roll(() => names != null ? names[_rng.nextInt(n)] : '${_rng.nextInt(n) + 1}'),
              child: Text(l.pickPlayer),
            ),
          ],
        );
      case ToolTab.timer:
        return Column(
          children: [
            _BigResult(text: '${_timerLeft ~/ 60}:${(_timerLeft % 60).toString().padLeft(2, '0')}', size: 96),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              children: [
                for (final s in const [60, 90, 120, 180, 300])
                  ChoiceChip(
                    label: Text('${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}'),
                    selected: _timerTotal == s,
                    showCheckmark: false,
                    onSelected: (_) => setState(() {
                      _timer?.cancel();
                      _timerRunning = false;
                      _timerTotal = s;
                      _timerLeft = s;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _toggleTimer, child: Text(_timerRunning ? l.pauseTimer : l.start)),
          ],
        );
    }
  }

  void _toggleTimer() {
    if (_timerRunning) {
      _timer?.cancel();
      setState(() => _timerRunning = false);
      return;
    }
    if (_timerLeft == 0) _timerLeft = _timerTotal;
    setState(() => _timerRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timerLeft <= 1) {
        t.cancel();
        setState(() {
          _timerLeft = 0;
          _timerRunning = false;
        });
        ref.read(soundProvider).play(Sfx.eliminated);
      } else {
        setState(() => _timerLeft--);
      }
    });
  }
}
