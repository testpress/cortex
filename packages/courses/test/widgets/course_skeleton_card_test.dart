import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: LocalizationProvider(
        child: Builder(
          builder: (context) {
            final locale = LocalizationProvider.of(context).locale;
            return Localizations(
              locale: locale,
              delegates: LocalizationProvider.delegates,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }

  testWidgets('study skeleton card preserves course card height', (
    tester,
  ) async {
    final course = CourseDto(
      id: '1',
      title: 'Flutter Basics',
      colorIndex: 0,
      chapterCount: 5,
      totalDuration: '10h',
      totalContents: 50,
      progress: 65,
      completedLessons: 65,
      totalLessons: 100,
    );

    await tester.pumpWidget(
      wrap(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 720,
              child: CourseCard(course: course),
            ),
            SizedBox(
              width: 720,
              child: const CourseSkeletonCard(),
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    final courseCardHeight =
        tester.getSize(find.byType(CourseCard).at(0)).height;
    final skeletonCardHeight =
        tester.getSize(find.byType(CourseCard).at(1)).height;

    expect((courseCardHeight - skeletonCardHeight).abs(), lessThan(6.0));
  });
}
