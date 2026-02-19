import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../data/mock_courses.dart';
import '../widgets/course_card.dart';

/// Course library screen displaying available courses.
///
/// This is the main screen of the courses module, showing a scrollable
/// list of course cards with progress indicators.
class CourseListScreen extends StatelessWidget {
  const CourseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppShell(
      child: Column(
        children: [
          AppHeader(
            title: L10n.of(context).courseLibraryTitle,
            subtitle: L10n.of(context).courseLibrarySubtitle,
          ),
          Expanded(
            child: AppScroll(
              children: [
                ...mockCourses.map(
                  (course) => Padding(
                    padding: EdgeInsets.only(bottom: design.spacing.md),
                    child: CourseCard(course: course),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
