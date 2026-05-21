import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'lesson_status_badge.dart';

/// A list item for a lesson or content type in the filtered view.
///
/// Matches the reference implementation's shadow, padding, and typography.
class LessonListItem extends StatelessWidget {
  const LessonListItem({
    super.key,
    required this.lesson,
    this.onTap,
    this.isSkeleton = false,
  });

  final LessonDto lesson;
  final VoidCallback? onTap;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    const double iconSize = 40;

    // Exact colors from reference
    final typeTheme = switch (lesson.type) {
      LessonType.video || LessonType.liveStream || LessonType.embedContent => design.study.video,
      LessonType.pdf || LessonType.notes || LessonType.attachment => design.study.pdf,
      LessonType.assessment => design.study.assessment,
      LessonType.test => design.study.test,
      LessonType.unknown => design.study.video,
    };

    final icon = switch (lesson.type) {
      LessonType.video => LucideIcons.playCircle,
      LessonType.liveStream => LucideIcons.radio,
      LessonType.embedContent => LucideIcons.code,
      LessonType.notes => LucideIcons.bookOpen,
      LessonType.attachment => LucideIcons.paperclip,
      LessonType.pdf => LucideIcons.fileText,
      LessonType.assessment => LucideIcons.clipboardCheck,
      LessonType.test => LucideIcons.award,
      LessonType.unknown => LucideIcons.helpCircle,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Skeletonizer(
        enabled: isSkeleton,
        ignoreContainers: true,
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
        ),
        child: AppSemantics.button(
          label: 'Open lesson: ${lesson.title}',
          onTap: isSkeleton ? () {} : (onTap ?? () {}),
          child: AppFocusable(
            onTap: isSkeleton ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton.replace(
                  width: iconSize,
                  height: iconSize,
                  replacement: DecoratedBox(
                    decoration: BoxDecoration(
                      color: design.colors.skeleton,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: lesson.image != null ? null : typeTheme.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: lesson.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                lesson.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(icon, size: 20, color: typeTheme.foreground),
                              ),
                            )
                          : Icon(icon, size: 20, color: typeTheme.foreground),
                    ),
                  ),
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
                      AppText.cardSubtitle(
                        lesson.chapterTitle ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          if (lesson.duration.isNotEmpty)
                            AppText.cardCaption(lesson.duration),
                          if (lesson.type != LessonType.liveStream) ...[
                            if (lesson.duration.isNotEmpty) const SizedBox(width: 8),
                            LessonStatusBadge(status: lesson.progressStatus),
                          ],
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
    ),
  );
}
}
