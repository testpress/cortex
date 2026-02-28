import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/today_schedule.dart';
import 'shared.dart';

class TestCard extends StatelessWidget {
  const TestCard({super.key, required this.item});
  final Test item;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final design = Design.of(context);

    return SnapshotCard(
      icon: const TestIcon(),
      title: item.title,
      titleSuffix: item.isImportant
          ? PillBadge(label: l10n.importantLabel, color: design.colors.error)
          : null,
      subtitles: [
        if (item.type != null)
          l10n.testTypeLabel(item.type!.name.toUpperCase()),
      ],
      chevronSize: 16,
      bottomAction: AppText.cardCaption(
        '${item.time} · ${item.duration}',
        color: design.colors.textTertiary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
