import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';

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

  group('CourseCard Accessibility', () {
    // CourseDto with 65% progress
    final testCourse = CourseDto(
      id: '1',
      title: 'Flutter Basics',
      colorIndex: 0,
      chapterCount: 5,
      totalDuration: '10h',
      progress: 65,
      completedLessons: 65,
      totalLessons: 100,
    );

    testWidgets('course title is accessible', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Verify title is rendered
      expect(find.text('Flutter Basics'), findsOneWidget);
    });

    testWidgets('progress indicator exposes value semantics', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Find the Semantics widget with progress value
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Course progress' &&
            widget.properties.value == '65%',
      );

      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('navigation icon is accessible', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Find the chevron right icon
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
    });

    testWidgets('card composes primitives correctly', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Verify composition: AppCard contains AppText
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(AppText), findsWidgets); // Multiple AppText instances
    });

    testWidgets('not started course shows navigation indicator', (
      tester,
    ) async {
      final notStartedCourse = CourseDto(
        id: '2',
        title: 'Advanced Flutter',
        colorIndex: 0,
        chapterCount: 3,
        totalDuration: '6h',
        progress: 0,
        completedLessons: 0,
        totalLessons: 50,
      );

      await tester.pumpWidget(wrap(CourseCard(course: notStartedCourse)));
      await tester.pumpAndSettle();

      // Verify title and navigation icon
      expect(find.text('Advanced Flutter'), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
    });
  });
}
