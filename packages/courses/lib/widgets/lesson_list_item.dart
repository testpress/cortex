import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/widgets.dart';
import 'lesson_status_badge.dart';

/// A list item for a lesson or content type in the filtered view.
///
/// Matches the reference implementation's shadow, padding, and typography.
class LessonListItem extends StatelessWidget {
  const LessonListItem({super.key, required this.lesson, this.onTap});

  final LessonDto lesson;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Exact colors from reference
    final typeTheme = switch (lesson.type) {
      LessonType.video => design.study.video,
      LessonType.pdf => design.study.pdf,
      LessonType.assessment => design.study.assessment,
      LessonType.test => design.study.test,
    };

    final icon = switch (lesson.type) {
      LessonType.video => LucideIcons.playCircle,
      LessonType.pdf => LucideIcons.fileText,
      LessonType.assessment => LucideIcons.clipboardCheck,
      LessonType.test => LucideIcons.award,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: AppSemantics.button(
        label: 'Open lesson: ${lesson.title}',
        onTap: onTap ?? () {},
        child: AppFocusable(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson Type Icon (md: 40x40)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: typeTheme.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: typeTheme.foreground),
                ),
                const SizedBox(width: 12),

                // Title and Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.cardTitle(
                        lesson.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // text-[14px] leading-[20px] font-medium (Chapter Title)
                      AppText.cardSubtitle(lesson.chapterTitle ?? ''),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          AppText.cardCaption(lesson.duration),
                          const SizedBox(width: 8),
                          LessonStatusBadge(status: lesson.progressStatus),
                        ],
                      ),
                    ],
                  ),
                ),

                // Navigation Indicator
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(
                    LucideIcons.chevronRight,
                    color: design.colors.textSecondary.withValues(alpha: 0.5),
                    size: 20,
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
