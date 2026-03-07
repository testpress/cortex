import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../models/today_schedule.dart';
import 'shared.dart';

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({super.key, required this.item});
  final Assignment item;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isOverdue = item.status == AssignmentStatus.overdue;
    final filledColor = isOverdue ? design.colors.error : design.colors.warning;
    final emptyColor = design.colors.divider;

    return SnapshotCard(
      icon: AssignmentIcon(status: item.status),
      title: item.title,
      subtitles: [if (item.description != null) item.description!],
      chevronSize: 16,
      bottomAction: Row(
        children: [
          Expanded(
            child: AppText.cardCaption(
              '${item.subject} · Due ${item.dueTime}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.progress != null && item.progress! > 0) ...[
            const SizedBox(width: 8),
            Row(
              children: [
                ...List.generate(4, (i) {
                  final isFilled = item.progress! >= ((i + 1) / 4);
                  return Container(
                    width: 12,
                    height: 4,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: isFilled ? filledColor : emptyColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
                const SizedBox(width: 4),
                AppText.cardCaption(
                  '${(item.progress! * 100).toInt()}%',
                  color: design.colors.textSecondary,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
