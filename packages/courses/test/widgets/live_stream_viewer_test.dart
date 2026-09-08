import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:courses/repositories/course_repository.dart';
import 'package:courses/widgets/lesson_detail/live_stream_viewer.dart';
import 'package:courses/widgets/lesson_detail/fermion_lobby_view.dart';

class FakeCourseRepository extends Fake implements CourseRepository {
  int refreshLessonCallCount = 0;
  String? lastRefreshedLessonId;

  @override
  Future<LessonDto> refreshLesson(String lessonId) async {
    refreshLessonCallCount++;
    lastRefreshedLessonId = lessonId;
    return LessonDto(
      id: lessonId,
      chapterId: '10',
      title: 'Refreshed Lesson',
      type: LessonType.liveStream,
      progressStatus: LessonProgressStatus.notStarted,
      orderIndex: 0,
      duration: '60 min',
      isLocked: false,
    );
  }
}

void main() {
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

  final testFermionRunningLesson = LessonDto(
    id: '1',
    chapterId: '10',
    title: 'Fermion Live Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 0,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'https://fermion.embed/1',
    liveStreamProvider: 'Fermion',
    streamStatus: 'running',
    start: '2026-08-10T11:38:00Z',
  );

  final testFermionScheduledLesson = LessonDto(
    id: '2',
    chapterId: '10',
    title: 'Scheduled Fermion Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 1,
    duration: '60 min',
    isLocked: false,
    liveStreamProvider: 'Fermion',
    streamStatus: 'scheduled',
    isScheduled: true,
    scheduledMessage: 'This content will be unlocked soon.',
  );

  final testTpStreamsRunningLesson = LessonDto(
    id: '3',
    chapterId: '10',
    title: 'TpStreams Session',
    type: LessonType.liveStream,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 2,
    duration: '60 min',
    isLocked: false,
    contentUrl: 'tp-asset-123',
    liveStreamProvider: 'TpStreams',
    streamStatus: 'running',
  );

  group('LiveStreamViewer Gating & Routing', () {
    testWidgets('renders FermionLobbyView for running Fermion session',
        (tester) async {
      await tester
          .pumpWidget(wrap(LiveStreamViewer(lesson: testFermionRunningLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(FermionLobbyView), findsOneWidget);
      expect(find.text('Attend Class'), findsOneWidget);
    });

    testWidgets('renders ScheduledMessageView for scheduled Fermion session',
        (tester) async {
      await tester.pumpWidget(
          wrap(LiveStreamViewer(lesson: testFermionScheduledLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(ScheduledMessageView), findsOneWidget);
      expect(find.text('This content will be unlocked soon.'), findsOneWidget);
      expect(find.byType(FermionLobbyView), findsNothing);

      // Unmount widget to cancel periodic polling timer cleanly
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('renders inline player for TpStreams session', (tester) async {
      await tester.pumpWidget(
          wrap(LiveStreamViewer(lesson: testTpStreamsRunningLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(FermionLobbyView), findsNothing);
      expect(find.byType(ScheduledMessageView), findsNothing);
    });
  });

  group('LiveStreamViewer Polling', () {
    testWidgets('polls refreshLesson every 5 seconds while scheduled',
        (tester) async {
      final fakeRepo = FakeCourseRepository();
      await tester.pumpWidget(
        wrap(
          LiveStreamViewer(lesson: testFermionScheduledLesson),
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      expect(fakeRepo.refreshLessonCallCount, 0);

      // Advance clock by 5 seconds to trigger first periodic poll
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);
      expect(fakeRepo.lastRefreshedLessonId, '2');

      // Advance clock by another 5 seconds to trigger second poll
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 2);

      // Clean up timer by unmounting widget
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('cancels polling timer when isScheduled becomes false',
        (tester) async {
      final fakeRepo = FakeCourseRepository();
      final scheduledViewer =
          LiveStreamViewer(lesson: testFermionScheduledLesson);
      final runningViewer = LiveStreamViewer(lesson: testFermionRunningLesson);

      await tester.pumpWidget(
        wrap(
          scheduledViewer,
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);

      // Update widget with non-scheduled lesson
      await tester.pumpWidget(
        wrap(
          runningViewer,
          overrides: [
            courseRepositoryProvider.overrideWith((ref) async => fakeRepo),
          ],
        ),
      );
      await tester.pump();

      // Advance time by 5 more seconds; no new refresh call should occur
      await tester.pump(const Duration(seconds: 5));
      expect(fakeRepo.refreshLessonCallCount, 1);
    });
  });

  group('FermionLobbyView Metadata and Semantics', () {
    testWidgets('groups duration and start time inside semantic container',
        (tester) async {
      await tester
          .pumpWidget(wrap(FermionLobbyView(lesson: testFermionRunningLesson)));
      await tester.pumpAndSettle();

      // Find by semantics label on the grouped metadata card
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label != null &&
            widget.properties.label!.contains('Session details:') &&
            widget.properties.label!.contains('Duration: 60 minutes'),
      );

      expect(semanticsFinder, findsOneWidget);
    });
  });
}
