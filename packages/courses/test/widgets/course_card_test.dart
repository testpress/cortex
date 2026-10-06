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
      totalContents: 50,
      progress: 65,
      completedLessons: 65,
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
        totalContents: 30,
        progress: 0,
        completedLessons: 0,
      );

      await tester.pumpWidget(wrap(CourseCard(course: notStartedCourse)));
      await tester.pumpAndSettle();

      // Verify title and navigation icon
      expect(find.text('Advanced Flutter'), findsOneWidget);
      expect(find.byIcon(LucideIcons.chevronRight), findsOneWidget);
    });

    testWidgets(
        'course requiring registration renders action button and hides progress bar',
        (
      tester,
    ) async {
      final lockedCourse = CourseDto(
        id: '768',
        title: 'IBPS RRB PO XV PRELIMS',
        colorIndex: 0,
        chapterCount: 1,
        totalContents: 10,
        progress: 0,
        externalContentLink: 'https://example.com/sso/register/768',
        externalLinkLabel: 'REQUEST PACKAGE',
      );

      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CourseCard(
            course: lockedCourse,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title and action button
      expect(find.text('IBPS RRB PO XV PRELIMS'), findsOneWidget);
      expect(find.text('REQUEST PACKAGE'), findsOneWidget);
      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.variant, AppButtonVariant.secondary);

      // Verify progress semantics are not rendered
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == 'Course progress',
      );
      expect(semanticsFinder, findsNothing);

      // Tap button and verify callback
      await tester.tap(find.text('REQUEST PACKAGE'));
      expect(tapped, isTrue);
    });

    testWidgets('pending approval course renders secondary action button', (
      tester,
    ) async {
      final pendingCourse = CourseDto(
        id: '768',
        title: 'IBPS RRB PO XV PRELIMS',
        colorIndex: 0,
        chapterCount: 1,
        totalContents: 10,
        progress: 0,
        externalContentLink: 'https://example.com/sso/register/768',
        externalLinkLabel: 'RESUBMIT',
      );

      await tester.pumpWidget(
        wrap(
          CourseCard(
            course: pendingCourse,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('RESUBMIT'), findsOneWidget);
      final appButton = tester.widget<AppButton>(find.byType(AppButton));
      expect(appButton.variant, AppButtonVariant.secondary);
    });
  });
}
