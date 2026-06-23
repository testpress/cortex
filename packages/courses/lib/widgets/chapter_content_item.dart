import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/course_content.dart';

/// Component to display individual lesson or assessment items in the chapter detail.
class ChapterContentItem extends StatelessWidget {
  const ChapterContentItem({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isSkeleton = false,
  });

  final Lesson lesson;
  final VoidCallback onTap;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final icon = _getIconForType(lesson.type);
    final activeOnTap = isSkeleton ? null : onTap;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          boxShadow: design.shadows.surfaceSoft,
        ),
        child: AppFocusable(
          onTap: activeOnTap,
          borderRadius: BorderRadius.circular(design.radius.md),
          child: Skeletonizer(
            enabled: isSkeleton,
            ignoreContainers: true,
            effect: ShimmerEffect(
              baseColor: design.colors.skeleton,
              highlightColor: design.colors.onSkeleton,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(design.radius.md),
                          bottomLeft: Radius.circular(design.radius.md),
                        ),
                        child: Skeleton.replace(
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
                              color: lesson.image?.isNotEmpty == true
                                  ? null
                                  : _getColorForType(context, lesson.type)
                                      .withValues(alpha: 0.1),
                            ),
                            child: lesson.image?.isNotEmpty == true
                                ? CachedNetworkImage(
                                    imageUrl: lesson.image!,
                                    width: 140,
                                    height: 80,
                                    memCacheWidth: 280,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: design.colors.skeleton,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                      child: Icon(
                                        icon,
                                        size: 24,
                                        color: _getColorForType(
                                            context, lesson.type),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      icon,
                                      size: 24,
                                      color: _getColorForType(
                                          context, lesson.type),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      if (lesson.hasAttempts &&
                          (lesson.type == LessonType.test ||
                              lesson.type == LessonType.assessment))
                        Positioned(
                          top: -6,
                          right: -6,
                          child: AppSemantics.progressValue(
                            value: 1.0,
                            label: 'Exam completed',
                            child: Container(
                              width: design.iconSize.md,
                              height: design.iconSize.md,
                              decoration: BoxDecoration(
                                color: design.colors.accent4,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: design.colors.card,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  LucideIcons.check,
                                  size: 11,
                                  color: design.colors.onSuccess,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
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
                            color: design.colors.textPrimary,
                          ),
                          const SizedBox(height: 2),
                          AppText.cardSubtitle(
                            _buildSubtitle(context),
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Icon(
                        LucideIcons.chevronRight,
                        size: 20,
                        color:
                            design.colors.textSecondary.withValues(alpha: 0.5),
                      ),
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

  String _buildSubtitle(BuildContext context) {
    final typeLabel = _getLabelForType(context, lesson.type);
    final duration = TimeFormatter.formatDuration(lesson.duration);

    if (duration == null ||
        duration.isEmpty ||
        lesson.type == LessonType.test) {
      return typeLabel;
    }

    return '$typeLabel · $duration';
  }

  IconData _getIconForType(LessonType type) {
    switch (type) {
      case LessonType.video:
        return LucideIcons.playCircle;
      case LessonType.liveStream:
        return LucideIcons.radio;
      case LessonType.embedContent:
        return LucideIcons.code;
      case LessonType.notes:
        return LucideIcons.bookOpen;
      case LessonType.attachment:
        return LucideIcons.paperclip;
      case LessonType.pdf:
        return LucideIcons.fileText;
      case LessonType.assessment:
        return LucideIcons.clipboardCheck;
      case LessonType.test:
        return LucideIcons.award;
      case LessonType.unknown:
        return LucideIcons.helpCircle;
    }
  }

  Color _getColorForType(BuildContext context, LessonType type) {
    final design = Design.of(context);
    switch (type) {
      case LessonType.video || LessonType.liveStream || LessonType.embedContent:
        return design.colors.accent1; // Purple
      case LessonType.pdf || LessonType.notes || LessonType.attachment:
        return design.colors.accent2; // Blue
      case LessonType.assessment:
        return design.colors.accent4; // Green
      case LessonType.test:
        return design.colors.accent3; // Orange
      case LessonType.unknown:
        return design.colors.textSecondary;
    }
  }

  String _getLabelForType(BuildContext context, LessonType type) {
    final l10n = L10n.of(context);
    switch (type) {
      case LessonType.video:
        return l10n.chapterTypeVideo;
      case LessonType.liveStream:
        return l10n.chapterTypeLiveStream;
      case LessonType.embedContent:
        return l10n.chapterTypeEmbed;
      case LessonType.notes:
        return l10n.chapterTypeNotes;
      case LessonType.attachment:
        return l10n.chapterTypeAttachment;
      case LessonType.pdf:
        return l10n.chapterTypePdf;
      case LessonType.assessment:
        return l10n.chapterTypeAssessment;
      case LessonType.test:
        return l10n.chapterTypeTest;
      case LessonType.unknown:
        return l10n.chapterTypeUnknown;
    }
  }
}
