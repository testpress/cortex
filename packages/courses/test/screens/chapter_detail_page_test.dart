import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courses/courses.dart';
import 'package:courses/providers/chapter_detail_provider.dart';

void main() {
  final testLessons = [
    const LessonDto(
      id: 'lesson-1',
      chapterId: 'chapter-1',
      title: 'Running Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      orderIndex: 0,
      duration: '00:10:00',
      isLocked: false,
      isRunning: true,
      isUpcoming: false,
      hasAttempts: false,
    ),
    const LessonDto(
      id: 'lesson-2',
      chapterId: 'chapter-1',
      title: 'Upcoming Lesson',
      type: LessonType.video,
      progressStatus: LessonProgressStatus.notStarted,
      orderIndex: 1,
      duration: '00:15:00',
      isLocked: false,
      isRunning: false,
      isUpcoming: true,
      hasAttempts: false,
    ),
  ];

  final testChapter = ChapterDto(
    id: 'chapter-1',
    courseId: 'course-1',
    title: 'Chapter 1 Title',
    lessonCount: 2,
    assessmentCount: 0,
    orderIndex: 1,
    isLeaf: true,
    lessons: testLessons,
  );

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

  group('ChapterDetailPage tab switching and skeleton tests', () {
    testWidgets(
        'switching tabs when lessons exist does NOT show skeleton loaders',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const ChapterDetailPage(
            courseId: 'course-1',
            chapterId: 'chapter-1',
          ),
          overrides: [
            chapterDetailProvider('course-1', 'chapter-1').overrideWith(
                (ref) => Stream.value((testChapter, 'Test Course'))),
            chapterDetailControllerProvider
                .overrideWith(() => _MockSyncingController()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Initial state: 'All' filter shows both lessons
      expect(find.text('Running Lesson'), findsOneWidget);
      expect(find.text('Upcoming Lesson'), findsOneWidget);

      // Tap 'Running' filter tab
      await tester.tap(find.text('Running'));
      await tester.pumpAndSettle();

      // Should show only Running Lesson immediately, no skeleton
      expect(find.text('Running Lesson'), findsOneWidget);
      expect(find.text('Upcoming Lesson'), findsNothing);
      expect(find.text('Loading lesson title text content'), findsNothing);

      // Tap 'Upcoming' filter tab
      await tester.tap(find.text('Upcoming'));
      await tester.pumpAndSettle();

      // Should show only Upcoming Lesson immediately, no skeleton
      expect(find.text('Upcoming Lesson'), findsOneWidget);
      expect(find.text('Running Lesson'), findsNothing);
      expect(find.text('Loading lesson title text content'), findsNothing);

      // Tap 'History' filter tab (empty)
      await tester.tap(find.text('History'));
      await tester.pumpAndSettle();

      // Should show empty state without any skeleton loaders
      expect(find.text('Loading lesson title text content'), findsNothing);
      expect(find.text('No content available'), findsOneWidget);
    });

    testWidgets(
        'leaving and re-entering ChapterDetailPage resets filter to All',
        (tester) async {
      final host = ValueNotifier<String?>('chapter-1');

      await tester.pumpWidget(
        wrap(
          ValueListenableBuilder<String?>(
            valueListenable: host,
            builder: (context, chapterId, _) {
              if (chapterId == null) {
                return const SizedBox.shrink();
              }
              return ChapterDetailPage(
                key: ValueKey(chapterId),
                courseId: 'course-1',
                chapterId: chapterId,
              );
            },
          ),
          overrides: [
            chapterDetailProvider('course-1', 'chapter-1').overrideWith(
                (ref) => Stream.value((testChapter, 'Test Course'))),
            chapterDetailProvider('course-1', 'chapter-2')
                .overrideWith((ref) => Stream.value((
                      testChapter.copyWith(
                        id: 'chapter-2',
                        title: 'Chapter 2 Title',
                      ),
                      'Test Course',
                    ))),
            chapterDetailControllerProvider
                .overrideWith(() => _MockSyncingController()),
          ],
        ),
      );

      await tester.pumpAndSettle();

      // Initial state shows both lessons
      expect(find.text('Running Lesson'), findsOneWidget);
      expect(find.text('Upcoming Lesson'), findsOneWidget);

      // Select 'Upcoming' tab
      await tester.tap(find.text('Upcoming'));
      await tester.pumpAndSettle();

      // Only upcoming lesson is shown
      expect(find.text('Upcoming Lesson'), findsOneWidget);
      expect(find.text('Running Lesson'), findsNothing);

      // Navigate away (unmount ChapterDetailPage)
      host.value = null;
      await tester.pumpAndSettle();

      // Navigate to Chapter 2
      host.value = 'chapter-2';
      await tester.pumpAndSettle();

      // On Chapter 2, autoDispose reset filter to 'All', showing both lessons
      expect(find.textContaining('Chapter 2 Title'), findsOneWidget);
      expect(find.text('Running Lesson'), findsOneWidget);
      expect(find.text('Upcoming Lesson'), findsOneWidget);
    });

    test(
        'chapterStatusFilterProvider auto-disposes and resets on the same container',
        () async {
      final container = ProviderContainer();
      final sub = container.listen(chapterStatusFilterProvider, (_, __) {});

      expect(
          container.read(chapterStatusFilterProvider), ChapterStatusFilter.all);

      container.read(chapterStatusFilterProvider.notifier).state =
          ChapterStatusFilter.upcoming;
      expect(container.read(chapterStatusFilterProvider),
          ChapterStatusFilter.upcoming);

      sub.close();
      // Allow the autoDispose microtask scheduled by Riverpod to execute
      await Future(() {});

      // Reading again on the same container must return the initial state 'all'
      expect(
          container.read(chapterStatusFilterProvider), ChapterStatusFilter.all);
      container.dispose();
    });
  });
}

class _MockSyncingController extends ChapterDetailController {
  @override
  bool build() => true; // Simulate background sync in progress
}
