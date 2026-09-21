import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Component to display individual lesson or assessment items in the chapter detail.
class ChapterContentItem extends StatelessWidget {
  const ChapterContentItem({
    super.key,
    required this.lesson,
    required this.onTap,
    this.isSkeleton = false,
  });

  final LessonDto lesson;
  final VoidCallback onTap;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final typeTheme = switch (lesson.type) {
      LessonType.video ||
      LessonType.liveStream ||
      LessonType.videoConference ||
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
    final icon = _getIconForType(lesson.type);
    final isCompleted = lesson.progressStatus == LessonProgressStatus.completed;
    final activeOnTap = isSkeleton
        ? null
        : () {
            if (lesson.hasEnded) {
              AppToast.show(
                context,
                message: L10n.of(context).contentAccessEnded,
                isError: true,
              );
              return;
            }
            onTap();
          };

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.sm),
      child: Container(
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          boxShadow: design.shadows.surfaceSoft,
        ),
        child: AppSemantics.button(
          label: L10n.of(context).openDetailedLesson(lesson.title),
          onTap: activeOnTap ?? () {},
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
                    SizedBox(
                      width: 140,
                      child: Stack(
                        fit: StackFit.expand,
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
                                decoration: BoxDecoration(
                                  color: lesson.image?.isNotEmpty == true
                                      ? null
                                      : typeTheme.background,
                                ),
                                child: lesson.image?.isNotEmpty == true
                                    ? CachedNetworkImage(
                                        imageUrl: lesson.image!,
                                        width: 140,
                                        memCacheWidth: 280,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          color: design.colors.skeleton,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Center(
                                          child: Icon(
                                            icon,
                                            size: design.iconSize.display,
                                            color: typeTheme.foreground,
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          icon,
                                          size: design.iconSize.display,
                                          color: typeTheme.foreground,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: AppSemantics.progressValue(
                                value: 1.0,
                                label: L10n.of(context).examCompletedLabel,
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
                                      size: design.iconSize.xs,
                                      color: design.colors.onSuccess,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText.cardTitle(
                              lesson.title,
                              color: design.colors.textPrimary,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: design.spacing.xs),
                            AppText.cardSubtitle(
                              _buildSubtitle(context),
                              color: design.colors.textSecondary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: design.spacing.md),
                      child: Center(
                        child: Icon(
                          lesson.hasEnded
                              ? LucideIcons.lock
                              : LucideIcons.chevronRight,
                          size: design.iconSize.action,
                          color: design.colors.textSecondary
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
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

    if (lesson.hasEnded) {
      final dateStr =
          lesson.end != null ? TimeFormatter.formatDate(lesson.end!) : null;
      if (dateStr != null && dateStr.isNotEmpty) {
        return L10n.of(context).accessExpiredOn(dateStr);
      }
      return L10n.of(context).accessExpired;
    }

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
      case LessonType.videoConference:
        return LucideIcons.video;
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

  String _getLabelForType(BuildContext context, LessonType type) {
    final l10n = L10n.of(context);
    switch (type) {
      case LessonType.video:
        return l10n.chapterTypeVideo;
      case LessonType.liveStream:
      case LessonType.videoConference:
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
