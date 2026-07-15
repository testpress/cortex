import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class ProductExpandableCourseCard extends StatefulWidget {
  final ProductCourseDto course;

  const ProductExpandableCourseCard({super.key, required this.course});

  @override
  State<ProductExpandableCourseCard> createState() =>
      _ProductExpandableCourseCardState();
}

class _ProductExpandableCourseCardState
    extends State<ProductExpandableCourseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final course = widget.course;

    final List<String> stats = [];
    if (course.chaptersCount > 0) stats.add('${course.chaptersCount} Chapters');
    if (course.videosCount > 0) stats.add('${course.videosCount} Videos');
    if (course.examsCount > 0) stats.add('${course.examsCount} Exams');
    if (course.attachmentsCount > 0) {
      stats.add('${course.attachmentsCount} Attachments');
    }
    if (course.htmlContentsCount > 0) {
      stats.add('${course.htmlContentsCount} Notes');
    }

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border.all(color: design.colors.border),
        borderRadius: BorderRadius.circular(design.spacing.sm),
      ),
      margin: EdgeInsets.only(bottom: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSemantics.button(
            label: widget.course.title,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(design.spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText.cardTitle(widget.course.title),
                    ),
                    Icon(
                      _isExpanded
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: EdgeInsets.only(
                left: design.spacing.md,
                right: design.spacing.md,
                bottom: design.spacing.md,
              ),
              child: stats.isNotEmpty
                  ? Wrap(
                      spacing: design.spacing.md,
                      runSpacing: design.spacing.xs,
                      children: stats
                          .map((stat) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(LucideIcons.checkCircle2,
                                      size: design.iconSize.sm,
                                      color: design.colors.primary),
                                  SizedBox(width: design.spacing.xs),
                                  AppText.cardSubtitle(stat),
                                ],
                              ))
                          .toList(),
                    )
                  : AppText.cardCaption('No content available'),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: design.motion.fast,
          ),
        ],
      ),
    );
  }
}
