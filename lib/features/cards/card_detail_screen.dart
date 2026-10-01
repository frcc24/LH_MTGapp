import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/section_header.dart';
import 'cards_screen.dart';
import 'scryfall.dart';

const _legalFormats = ['standard', 'pioneer', 'modern', 'legacy', 'vintage', 'commander', 'pauper', 'brawl'];

class CardDetailScreen extends ConsumerStatefulWidget {
  const CardDetailScreen({super.key, required this.id, this.card});
  final String id;
  final ScryCard? card;

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  ScryCard? _card;
  bool _error = false;
  int _face = 0;

  @override
  void initState() {
    super.initState();
    _card = widget.card;
    if (_card == null) _load();
  }

  Future<void> _load() async {
    setState(() => _error = false);
    try {
      final c = await ref.read(scryfallProvider).byId(widget.id);
      if (mounted) setState(() => _card = c);
    } on DioException {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final c = _card;
    return Scaffold(
      appBar: AppBar(title: Text(c?.name ?? l.cards)),
      body: SafeArea(
        child: c == null
            ? Center(
                child: _error
                    ? FilledButton(onPressed: _load, child: Text(l.retry))
                    : const CircularProgressIndicator(color: AppColors.accent),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, 32),
                    children: [
                      _image(c),
                      if (c.faces.length > 1)
                        Center(
                          child: TextButton.icon(
                            onPressed: () => setState(() => _face = (_face + 1) % c.faces.length),
                            icon: const FaIcon(FontAwesomeIcons.rotate, size: 14),
                            label: Text(l.flipCard),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text(c.faces[_face].name, style: AppType.title)),
                          ManaCost(c.faces[_face].manaCost, size: 24),
                        ],
                      ),
                      Text(c.faces[_face].typeLine, style: AppType.body.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 12),
                      Text(c.faces[_face].oracleText, style: AppType.bodyLarge),
                      SectionHeader(l.legality),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final f in _legalFormats) _LegalChip(format: f, status: c.legalities[f] ?? 'not_legal'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        onPressed: () => launchUrl(Uri.parse(scryfallLink(c)), mode: LaunchMode.externalApplication),
                        icon: const FaIcon(FontAwesomeIcons.arrowUpRightFromSquare, size: 14),
                        label: Text(l.viewOnScryfall),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(l.scryfallCredit, style: AppType.caption.copyWith(color: AppColors.textMuted)),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  /// Imagem inteira, sem corte, sem filtro, sem nada por cima. Cantos de 4,75% como a carta física.
  Widget _image(ScryCard c) {
    final url = c.faces[_face].imageUrl;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: AspectRatio(
          aspectRatio: 488 / 680,
          child: url == null
              ? const ColoredBox(color: AppColors.elevated)
              : LayoutBuilder(
                  builder: (_, box) => ClipRRect(
                    borderRadius: BorderRadius.circular(box.maxWidth * 0.0475),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const ColoredBox(color: AppColors.elevated),
                      errorWidget: (_, _, _) => const Center(child: FaIcon(FontAwesomeIcons.image)),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _LegalChip extends StatelessWidget {
  const _LegalChip({required this.format, required this.status});
  final String format;
  final String status;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final (icon, color, text) = switch (status) {
      'legal' => (FontAwesomeIcons.check, AppColors.gain, l.legal),
      'restricted' => (FontAwesomeIcons.triangleExclamation, AppColors.accent, l.restricted),
      'banned' => (FontAwesomeIcons.ban, AppColors.loss, l.banned),
      _ => (FontAwesomeIcons.xmark, AppColors.textFaint, l.notLegal),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color),
          const SizedBox(width: 8),
          Text(
            '${format[0].toUpperCase()}${format.substring(1)} · $text',
            style: AppType.labelSmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
