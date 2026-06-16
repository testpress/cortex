import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

    // Exact colors from reference
    final typeTheme = switch (lesson.type) {
      LessonType.video ||
      LessonType.liveStream ||
      LessonType.embedContent =>
        design.study.video,
      LessonType.pdf ||
      LessonType.notes ||
      LessonType.attachment =>
        design.study.pdf,
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
      clipBehavior: Clip.hardEdge,
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Skeleton.replace(
                    width: 140,
                    height: 80,
                    replacement: DecoratedBox(
                      decoration: BoxDecoration(
                        color: design.colors.skeleton,
                      ),
                    ),
                    child: Container(
                      width: 140,
                      height: 80,
                      decoration: BoxDecoration(
                        color:
                            lesson.image != null ? null : typeTheme.background,
                      ),
                      child: lesson.image != null
                          ? CachedNetworkImage(
                              imageUrl: lesson.image!,
                              width: 140,
                              memCacheWidth: 280,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: design.colors.skeleton,
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(icon,
                                    size: 24, color: typeTheme.foreground),
                              ),
                            )
                          : Center(
                              child: Icon(icon,
                                  size: 24, color: typeTheme.foreground),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          if (!isSkeleton) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                if (lesson.type != LessonType.liveStream)
                                  LessonStatusBadge(
                                      status: lesson.progressStatus),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Navigation Indicator
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 14, right: 16),
                        child: Icon(
                          LucideIcons.chevronRight,
                          color: design.colors.textSecondary
                              .withValues(alpha: 0.5),
                          size: 20,
                        ),
                      ),
                    ],
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
