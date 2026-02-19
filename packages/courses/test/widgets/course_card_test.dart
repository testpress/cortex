import 'package:data/data.dart';
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
      subjectColor: '#4F46E5',
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

    testWidgets('action button is accessible', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Find the button with correct label
      final buttonFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Continue',
      );

      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('card composes primitives correctly', (tester) async {
      await tester.pumpWidget(wrap(CourseCard(course: testCourse)));
      await tester.pumpAndSettle();

      // Verify composition: AppCard contains AppText and AppButton
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byType(AppText), findsWidgets); // Multiple AppText instances
    });

    testWidgets('not started course shows Start button', (tester) async {
      final notStartedCourse = CourseDto(
        id: '2',
        title: 'Advanced Flutter',
        subjectColor: '#4F46E5',
        chapterCount: 3,
        totalDuration: '6h',
        progress: 0,
        completedLessons: 0,
        totalLessons: 50,
      );

      await tester.pumpWidget(wrap(CourseCard(course: notStartedCourse)));
      await tester.pumpAndSettle();

      // Find the button with "Start" label
      final buttonFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Start',
      );

      expect(buttonFinder, findsOneWidget);
    });
  });
}
