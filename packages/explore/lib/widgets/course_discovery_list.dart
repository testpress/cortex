import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'discovery_course_card.dart';
import '../explore_constants.dart';

class CourseDiscoveryList extends StatelessWidget {
  const CourseDiscoveryList({
    super.key,
    required this.title,
    required this.courses,
    this.showViewAll = true,
  });

  final String title;
  final List<DiscoveryCourseDto> courses;
  final bool showViewAll;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (courses.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.labelBold(
                title.toUpperCase(),
                style: const TextStyle(
                  letterSpacing: ExploreConstants.sectionHeaderLetterSpacing,
                ),
              ),
              if (showViewAll)
                GestureDetector(
                  onTap: () => context.go('/study'),
                  child: AppText.labelBold(
                    l10n.viewAllAction,
                    color: design.colors.textPrimary,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: design.spacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          child: Row(
            children: [
              for (final course in courses)
                Padding(
                  padding: EdgeInsets.only(right: design.spacing.md),
                  child: SizedBox(
                    width: ExploreConstants.cardWidth,
                    child: DiscoveryCourseCard(course: course),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
