import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/today_schedule.dart';
import 'shared.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.item});
  final ClassItem item;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SnapshotCard(
      icon: ContentIcon(status: item.status),
      isCompleted: item.status == ClassStatus.completed,
      title: item.topic ?? item.subject,
      titleSuffix: item.status == ClassStatus.live
          ? PillBadge(
              label: L10n.of(context).liveLabel,
              color: design.colors.success,
            )
          : null,
      subtitles: [if (item.topic != null) item.subject],
      chevronSize: 20,
      bottomAction: AppText.caption(
        '${item.faculty} · ${item.time}',
        color: design.colors.textTertiary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
