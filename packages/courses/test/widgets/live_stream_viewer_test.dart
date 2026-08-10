import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:courses/courses.dart';
import 'package:courses/widgets/lesson_detail/live_stream_viewer.dart';
import 'package:courses/widgets/lesson_detail/fermion_lobby_view.dart';

void main() {
  Widget wrap(Widget child) {
    return ProviderScope(
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

  final testFermionRunningLesson = Lesson(
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

  final testFermionScheduledLesson = Lesson(
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

  final testTpStreamsRunningLesson = Lesson(
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
    });

    testWidgets('renders inline player for TpStreams session', (tester) async {
      await tester.pumpWidget(
          wrap(LiveStreamViewer(lesson: testTpStreamsRunningLesson)));
      await tester.pumpAndSettle();

      expect(find.byType(FermionLobbyView), findsNothing);
      expect(find.byType(ScheduledMessageView), findsNothing);
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
