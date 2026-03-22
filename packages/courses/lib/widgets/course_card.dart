import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Course card widget displaying course information and progress.
///
/// Refined to match the reference design with icon box and side-by-side progress.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, this.onTap});

  final CourseDto course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: 'Open course: ${course.title}',
      onTap: onTap ?? () {},
      child: AppFocusable(
        onTap: onTap,
        borderRadius: design.radius.card,
        child: AppCard(
          showShadow: true,
          padding: EdgeInsets.all(design.spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Icon/Image Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: (course.image != null && course.image!.isNotEmpty)
                      ? null
                      : design.shortcutPalette.atIndex(1).background,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(design.radius.md),
                  child: (course.image != null && course.image!.isNotEmpty)
                      ? Image.network(
                          course.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            LucideIcons.bookOpen,
                            color: design.shortcutPalette.atIndex(1).foreground,
                            size: 24,
                          ),
                        )
                      : Icon(
                          LucideIcons.bookOpen,
                          color: design.shortcutPalette.atIndex(1).foreground,
                          size: 24,
                        ),
                ),
              ),
              SizedBox(width: design.spacing.md),

              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText.cardTitle(
                            course.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          color: design.colors.textSecondary.withValues(
                            alpha: 0.3,
                          ),
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: design.spacing.xs),

                    // Metadata
                    AppText.caption(
                      '${L10n.of(context).curriculumChaptersCount(course.chapterCount)} · ${course.totalContents} ${L10n.of(context).labelContentsPlural}',
                      color: design.colors.textSecondary,
                    ),
                    SizedBox(height: design.spacing.md),

                    // Progress Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ProgressStat(
                          value:
                              '${course.completedLessons}/${course.totalLessons}',
                          label: L10n.of(context).labelLessonsPlural,
                        ),
                        _ProgressStat(
                          value: '${course.progress}%',
                          label: L10n.of(context).labelCompleted,
                        ),
                      ],
                    ),
                    SizedBox(height: design.spacing.sm),

                    // Progress Bar (Thin)
                    Semantics(
                      label: 'Course progress',
                      value: '${course.progress}%',
                      child: _ProgressBar(
                        progress: course.progress / 100.0,
                        color: design.colors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressStat extends StatelessWidget {
  const _ProgressStat({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        AppText.cardTitle(value, color: design.colors.textPrimary),
        SizedBox(width: design.spacing.xs),
        AppText.cardCaption(label, color: design.colors.textSecondary),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: design.colors.border.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(design.radius.full),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(design.radius.full),
          ),
        ),
      ),
    );
  }
}
