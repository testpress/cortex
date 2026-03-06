import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';

class EnrolledCoursesSection extends StatelessWidget {
  const EnrolledCoursesSection({
    super.key,
    required this.courses,
  });

  final List<CourseDto> courses;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                AppText.title(
                  l10n.profileActiveCoursesTitle,
                  color: design.colors.textPrimary,
                ),
                AppText.labelSmall(
                  l10n.viewAllAction,
                  color: design.colors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: design.spacing.md),
          SizedBox(
            height: 120, // Calculated height based on Study tab's padding and typography
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: design.spacing.md),
              itemBuilder: (context, index) {
                return _ActiveCourseCard(course: courses[index]);
              },
            ),
          ),
        ],
      );
    }
  }

class _ActiveCourseCard extends StatelessWidget {
  const _ActiveCourseCard({required this.course});
  final CourseDto course;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final colors = design.shortcutPalette.atIndex(1); // Blue theme for courses

    return SizedBox(
      width: 260, // Standard width for horizontal course cards
      child: AppCard(
        showShadow: true,
        padding: EdgeInsets.all(design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48, // Sizing from Study Tab
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(design.radius.md),
                  ),
                  child: Icon(
                    LucideIcons.bookOpen,
                    color: colors.foreground,
                    size: design.iconSize.display,
                  ),
                ),
                SizedBox(width: design.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText.label(
                              course.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            size: design.iconSize.sm,
                            color: design.colors.textSecondary.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ],
                      ),
                      AppText.caption(
                        '${course.chapterCount} chapters · ${course.totalDuration}',
                        color: design.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: _ProgressBar(
                    progress: course.progress / 100.0,
                    color: design.colors.success,
                  ),
                ),
                SizedBox(width: design.spacing.md),
                AppText.caption(
                  '${course.progress}%',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
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
