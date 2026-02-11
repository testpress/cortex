import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';

void main() {
  group('CourseCard Accessibility', () {
    final testCourse = Course(
      id: '1',
      title: 'Flutter Basics',
      description: 'Learn Flutter fundamentals',
      progress: 0.65,
    );

    testWidgets('course title is accessible', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CourseCard(course: testCourse),
        ),
      );

      // Verify title is rendered
      expect(find.text('Flutter Basics'), findsOneWidget);
    });

    testWidgets('progress indicator exposes value semantics', (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CourseCard(course: testCourse),
        ),
      );

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
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CourseCard(course: testCourse),
        ),
      );

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
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CourseCard(course: testCourse),
        ),
      );

      // Verify composition: AppCard contains AppText and AppButton
      expect(find.byType(AppCard), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byType(AppText), findsWidgets); // Multiple AppText instances
    });

    testWidgets('not started course shows Start button', (tester) async {
      final notStartedCourse = Course(
        id: '2',
        title: 'Advanced Flutter',
        description: 'Advanced concepts',
        progress: 0.0,
      );

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: CourseCard(course: notStartedCourse),
        ),
      );

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
