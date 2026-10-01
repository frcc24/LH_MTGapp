import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/section_header.dart';
import '../match/domain/formats.dart';
import '../match/domain/game_controller.dart';
import '../match/domain/models.dart';
import '../monetization/pro_state.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppL10n.of(context);
    final list = ref.watch(historyProvider);
    final pro = ref.watch(isProProvider);

    final byFormat = <String, int>{};
    final wins = <String, int>{};
    final played = <String, int>{};
    var totalMin = 0;
    for (final r in list) {
      byFormat[r.formatId] = (byFormat[r.formatId] ?? 0) + 1;
      totalMin += r.duration.inMinutes;
      for (final p in r.players) {
        played[p.name] = (played[p.name] ?? 0) + 1;
      }
      for (final w in r.winnerNames) {
        wins[w] = (wins[w] ?? 0) + 1;
      }
    }
    final topFormat = byFormat.entries.isEmpty
        ? null
        : (byFormat.entries.toList()..sort((a, b) => b.value.compareTo(a.value))).first.key;

    Widget stat(String v, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.tile),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(v, style: AppType.lifeS.copyWith(fontSize: 30), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(label, style: AppType.caption.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );

    Widget bars(Map<String, int> data, {String Function(String)? name}) {
      final max = data.values.fold<int>(1, (a, b) => a > b ? a : b);
      final entries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      return Column(
        children: [
          for (final e in entries.take(6))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 96,
                    child: Text(name?.call(e.key) ?? e.key, style: AppType.labelSmall, overflow: TextOverflow.ellipsis),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: e.value / max,
                        minHeight: 12,
                        backgroundColor: AppColors.elevated,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    child: Text('${e.value}', textAlign: TextAlign.end, style: AppType.counter.copyWith(fontSize: 16)),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.history),
        actions: [
          if (list.isNotEmpty)
            IconButton(
              tooltip: l.clearHistory,
              icon: const FaIcon(FontAwesomeIcons.trashCan, size: 18),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l.clearHistory),
                    content: Text(l.clearHistoryAsk),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                      FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.delete)),
                    ],
                  ),
                );
                if (ok == true) ref.read(historyProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: SafeArea(
        child: list.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.clockRotateLeft, size: 40, color: AppColors.iconIdle),
                      const SizedBox(height: 16),
                      Text(l.historyNone, style: AppType.title, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(
                        l.historyNoneSub,
                        style: AppType.body.copyWith(color: AppColors.textMuted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(onPressed: () => context.go('/setup'), child: Text(l.newMatch)),
                    ],
                  ),
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(AppSpace.screenH, 0, AppSpace.screenH, 24),
                    children: [
                      Row(
                        children: [
                          stat('${list.length}', l.statMatches),
                          const SizedBox(width: 10),
                          stat('${totalMin ~/ list.length} min', l.statAvg),
                          const SizedBox(width: 10),
                          stat(
                            topFormat == null
                                ? '—'
                                : (topFormat == 'custom' ? l.formatCustom : formatById(topFormat).name),
                            l.statTopFormat,
                          ),
                        ],
                      ),
                      SectionHeader(l.byFormat),
                      bars(byFormat, name: (id) => id == 'custom' ? l.formatCustom : formatById(id).name),
                      SectionHeader(l.byPlayer),
                      bars({for (final e in played.entries) e.key: wins[e.key] ?? 0}),
                      SectionHeader(l.recentMatches),
                      for (final r in list.take(30)) _MatchTile(r),
                      if (!pro)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            l.historyFreeLimit(FreeLimits.history),
                            style: AppType.caption.copyWith(color: AppColors.textMuted),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile(this.r);
  final MatchRecord r;

  @override
  Widget build(BuildContext context) {
    final l = AppL10n.of(context);
    final f = r.formatId == 'custom' ? l.formatCustom : formatById(r.formatId).name;
    final d = r.endedAt;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.tile),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          FaIcon(
            FontAwesomeIcons.crown,
            size: 14,
            color: r.winnerNames.isEmpty ? AppColors.disabled : AppColors.accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.winnerNames.isEmpty ? l.matchOver : r.winnerNames.join(' + '), style: AppType.label),
                Text(
                  '$f · ${l.playersCount(r.players.length)} · ${r.duration.inMinutes} min · ${l.roundN(r.rounds)}',
                  style: AppType.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Text(
            '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}',
            style: AppType.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
