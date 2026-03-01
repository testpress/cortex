import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

/// Enum representing the status of content within a chapter.
enum ChapterStatus { running, upcoming, history }

/// Component to display individual lesson or assessment items in the chapter detail.
class ChapterContentItem extends StatelessWidget {
  const ChapterContentItem({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  final dynamic lesson; // Using dynamic for now to support domain models
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
                  color: _getColorForType(
                    context,
                    lesson.type,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: Icon(
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
                      '${_getLabelForType(context, lesson.type)}${lesson.duration != null ? ' · ${lesson.duration}' : ''}',
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

  IconData _getIconForType(dynamic type) {
    // We expect LessonType here
    final typeName = type.toString().split('.').last;
    switch (typeName) {
      case 'video':
        return LucideIcons.playCircle;
      case 'pdf':
        return LucideIcons.fileText;
      case 'assessment':
        return LucideIcons.clipboardCheck;
      case 'test':
        return LucideIcons.award;
      default:
        return LucideIcons.fileText;
    }
  }

  Color _getColorForType(BuildContext context, dynamic type) {
    final design = Design.of(context);
    final typeName = type.toString().split('.').last;
    switch (typeName) {
      case 'video':
        return design.colors.accent1; // Purple
      case 'pdf':
        return design.colors.accent2; // Blue
      case 'assessment':
        return design.colors.accent4; // Green
      case 'test':
        return design.colors.accent3; // Orange
      default:
        return design.colors.textSecondary;
    }
  }

  String _getLabelForType(BuildContext context, dynamic type) {
    final l10n = L10n.of(context);
    final typeName = type.toString().split('.').last;
    switch (typeName) {
      case 'video':
        return l10n.chapterTypeVideo;
      case 'pdf':
        return l10n.chapterTypePdf;
      case 'assessment':
        return l10n.chapterTypeAssessment;
      case 'test':
        return l10n.chapterTypeTest;
      default:
        return l10n.filterLesson;
    }
  }
}
