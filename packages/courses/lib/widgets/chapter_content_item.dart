import 'package:core/core.dart';
import 'package:core/utils/time_formatter.dart';
import 'package:flutter/widgets.dart';
import '../models/course_content.dart';

/// Component to display individual lesson or assessment items in the chapter detail.
class ChapterContentItem extends StatelessWidget {
  const ChapterContentItem({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Get icon based on lesson type
    final icon = _getIconForType(lesson.type);

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.xs),
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: AppCard(
          padding: EdgeInsets.all(design.spacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: lesson.image != null
                      ? null
                      : _getColorForType(
                          context,
                          lesson.type,
                        ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: lesson.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(design.radius.md),
                          child: Image.network(
                            lesson.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              icon,
                              size: 20,
                              color: _getColorForType(context, lesson.type),
                            ),
                          ),
                        )
                      : Icon(
                          icon,
                          size: 20,
                          color: _getColorForType(context, lesson.type),
                        ),
                ),
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              Icon(
                LucideIcons.chevronRight,
                size: 20,
                color: design.colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildSubtitle(BuildContext context) {
    final typeLabel = _getLabelForType(context, lesson.type);
    final duration = TimeFormatter.formatDuration(lesson.duration);

    if (duration == null || duration.isEmpty) {
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
