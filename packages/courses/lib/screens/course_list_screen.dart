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
    return AppShell(
      child: Column(
        children: [
          const AppHeader(title: 'Cortex', subtitle: 'Course Library'),
          Expanded(
            child: AppScroll(
              children: [
                ...mockCourses.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
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
