import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/courses.dart';

void main() {
  final testCourse = CourseDto(
    id: 'course-1',
    title: 'Test Course',
    colorIndex: 0,
    chapterCount: 2,
    totalContents: 10,
    progress: 0,
    completedLessons: 0,
  );

  final testChapters = [
    ChapterDto(
      id: 'chapter-1',
      courseId: 'course-1',
      title: 'Chapter 1 Title',
      lessonCount: 2,
      assessmentCount: 1,
      orderIndex: 1,
      isLeaf: true,
    ),
  ];

  Widget wrap(Widget child, {List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: DesignProvider(
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
      ),
    );
  }

  group('ChaptersListPage filtering chip visibility tests', () {
    testWidgets(
        'when showExamTab is false, Assessments and Tests chips are visible',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const ChaptersListPage(courseId: 'course-1'),
          overrides: [
            courseDetailProvider('course-1')
                .overrideWith((ref) => Stream.value(testCourse)),
            subChaptersProvider('course-1', null)
                .overrideWith((ref) => Stream.value(testChapters)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify the course title and chapter are rendered
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Chapter 1 Title'), findsOneWidget);

      // Verify filter chips
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Videos'), findsOneWidget);
      expect(find.text('PDFs'), findsOneWidget);
      expect(find.text('Attachments'), findsOneWidget);
      expect(find.text('Assessments'), findsOneWidget);
      expect(find.text('Tests'), findsOneWidget);
    }, skip: AppConfig.showExamTab);

    testWidgets(
        'when showExamTab is true, Assessments and Tests chips are hidden',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const ChaptersListPage(courseId: 'course-1'),
          overrides: [
            courseDetailProvider('course-1')
                .overrideWith((ref) => Stream.value(testCourse)),
            subChaptersProvider('course-1', null)
                .overrideWith((ref) => Stream.value(testChapters)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify page is rendered
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Chapter 1 Title'), findsOneWidget);

      // Verify filter chips: All, Videos, Notes, Attachments should exist
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Videos'), findsOneWidget);
      expect(find.text('PDFs'), findsOneWidget);
      expect(find.text('Attachments'), findsOneWidget);

      // Assessments and Tests chips should NOT exist
      expect(find.text('Assessments'), findsNothing);
      expect(find.text('Tests'), findsNothing);
    }, skip: !AppConfig.showExamTab);
  });

  group('ChaptersListPage refresh behavior', () {
    testWidgets('refresh preserves cache and does not flash skeleton',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const ChaptersListPage(courseId: 'course-1'),
          overrides: [
            courseDetailProvider('course-1')
                .overrideWith((ref) => Stream.value(testCourse)),
            subChaptersProvider('course-1', null)
                .overrideWith((ref) => Stream.value(testChapters)),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Verify the course title and chapter are rendered initially
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Chapter 1 Title'), findsOneWidget);

      // Trigger refresh by dragging down
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 300));
      await tester.pump();

      // During refresh, data should still be visible, and no skeleton should appear
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Chapter 1 Title'), findsOneWidget);

      // Let it settle
      await tester.pumpAndSettle();
    });
  });
}
