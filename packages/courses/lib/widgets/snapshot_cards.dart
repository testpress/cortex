import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:data/models/live_class_dto.dart';
import 'package:data/models/assignment_dto.dart';
import 'package:data/models/test_dto.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({super.key, required this.classItem, this.onTap});

  final LiveClassDto classItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isLive = classItem.status == LiveClassStatus.live;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isLive
                  ? design.colors.primary.withValues(alpha: 0.1)
                  : design.colors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isLive ? LucideIcons.video : LucideIcons.calendar,
                size: 20,
                color: isLive
                    ? design.colors.primary
                    : design.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText.title(
                        classItem.subject,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626), // red-600
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const AppText.label(
                          "LIVE",
                          color: Color(0xFFFFFFFF),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                  ],
                ),
                if (classItem.topic.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: AppText.body(
                      classItem.topic,
                      color: design.colors.textSecondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    AppText.bodySmall(
                      classItem.faculty,
                      color: design.colors.textTertiary,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppText.bodySmall(
                        "•",
                        color: design.colors.textTertiary,
                      ),
                    ),
                    AppText.bodySmall(
                      classItem.time,
                      color: design.colors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Icon(LucideIcons.chevronRight, size: 20, color: design.colors.border),
        ],
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({super.key, required this.assignment, this.onTap});

  final AssignmentDto assignment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isOverdue = assignment.status == AssignmentStatus.overdue;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isOverdue
                      ? const Color(0xFFFEE2E2)
                      : design.colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isOverdue ? LucideIcons.alertCircle : LucideIcons.fileText,
                    size: 20,
                    color: isOverdue
                        ? const Color(0xFFDC2626)
                        : design.colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.title(
                      assignment.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (assignment.description != null)
                      AppText.bodySmall(
                        assignment.description!,
                        color: design.colors.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              SizedBox(width: design.spacing.sm),
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: design.colors.border,
              ),
            ],
          ),
          SizedBox(height: design.spacing.md),
          Row(
            children: [
              SizedBox(
                width: 40 + design.spacing.md.toDouble(),
              ), // Alignment with text
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: AppText.bodySmall(
                              assignment.subject,
                              color: design.colors.textTertiary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: AppText.bodySmall(
                              "•",
                              color: design.colors.textTertiary,
                            ),
                          ),
                          AppText.bodySmall(
                            "Due ${assignment.dueTime}",
                            color: design.colors.textTertiary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _SegmentedProgressBar(
                      progress: assignment.progress,
                      color: isOverdue
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFD97706), // red-600 or amber-600
                    ),
                    const SizedBox(width: 4),
                    AppText.bodySmall(
                      "${assignment.progress}%",
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar({required this.progress, required this.color});

  final int progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      children: List.generate(4, (index) {
        final threshold = (index + 1) * 25;
        final isFilled = progress >= threshold;
        return Container(
          width: 12,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: isFilled ? color : design.colors.border.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

class TestCard extends StatelessWidget {
  const TestCard({super.key, required this.test, this.onTap});

  final TestDto test;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: design.colors.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                LucideIcons.fileText,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText.title(
                        test.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (test.isImportant)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDC2626), // red-600
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const AppText.label(
                          "IMPORTANT",
                          color: Color(0xFFFFFFFF),
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                  ],
                ),
                AppText.bodySmall(
                  "${test.type.name.toUpperCase()} TEST",
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    AppText.bodySmall(
                      test.time,
                      color: design.colors.textTertiary,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: AppText.bodySmall(
                        "•",
                        color: design.colors.textTertiary,
                      ),
                    ),
                    AppText.bodySmall(
                      test.duration,
                      color: design.colors.textTertiary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: design.spacing.sm),
          Icon(LucideIcons.chevronRight, size: 20, color: design.colors.border),
        ],
      ),
    );
  }
}
