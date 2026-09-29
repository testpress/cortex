import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/video_lesson_viewer.dart';
import 'package:courses/widgets/lesson_detail/custom_video_player.dart';

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

  const testLesson = LessonDto(
    id: '101',
    chapterId: '10',
    title: 'Test Video Lesson',
    type: LessonType.video,
    progressStatus: LessonProgressStatus.notStarted,
    orderIndex: 0,
    duration: '10 min',
    isLocked: false,
  );

  group('VideoLessonViewer Doubt Tab Gating', () {
    testWidgets('hides Ask Doubt tab when helpdeskEnabled is false',
        (tester) async {
      final disabledSettings = InstituteSettings.fromJson({
        'is_helpdesk_enabled': false,
      });

      await tester.pumpWidget(
        wrap(
          const VideoLessonViewer(lesson: testLesson),
          overrides: [
            instituteSettingsProvider.overrideWith((ref) => disabledSettings),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Ask Doubt'), findsNothing);
    });

    testWidgets('shows Ask Doubt tab when helpdeskEnabled is true',
        (tester) async {
      final enabledSettings = InstituteSettings.fromJson({
        'is_helpdesk_enabled': true,
      });

      await tester.pumpWidget(
        wrap(
          const VideoLessonViewer(lesson: testLesson),
          overrides: [
            instituteSettingsProvider.overrideWith((ref) => enabledSettings),
          ],
        ),
      );
      await tester.pump();

      expect(find.text('Ask Doubt'), findsOneWidget);
    });
  });

  group('VideoLessonViewer Transcoding Processing', () {
    testWidgets(
        'shows VideoProcessingView when isTranscodingProcessing is true',
        (tester) async {
      const processingLesson = LessonDto(
        id: '102',
        chapterId: '10',
        title: 'Processing Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.notStarted,
        orderIndex: 1,
        duration: '10 min',
        isLocked: false,
        transcodingStatus: 'Processing',
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(const VideoLessonViewer(lesson: processingLesson)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Video is Being Processed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('VideoLessonViewer Initial Position Parsing', () {
    testWidgets(
        'calculates initial position correctly for formatted time string',
        (tester) async {
      final enabledSettings = InstituteSettings.fromJson({
        'is_helpdesk_enabled': true,
      });
      const lessonWithTimestamp = LessonDto(
        id: '103',
        chapterId: '10',
        title: 'Timestamp Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.inProgress,
        orderIndex: 0,
        duration: '10 min',
        isLocked: false,
        lastWatchedDuration: '00:02:05',
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: lessonWithTimestamp),
            overrides: [
              instituteSettingsProvider.overrideWith((ref) => enabledSettings),
            ],
          ),
        ),
      );
      await tester.pump();

      final playerFinder = find.byType(CustomVideoPlayer);
      expect(playerFinder, findsOneWidget);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      expect(player.initialPosition, equals(125.0));
    });

    testWidgets(
        'calculates initial position correctly for decimal seconds string',
        (tester) async {
      final enabledSettings = InstituteSettings.fromJson({
        'is_helpdesk_enabled': true,
      });
      const lessonWithDecimal = LessonDto(
        id: '104',
        chapterId: '10',
        title: 'Decimal Video Lesson',
        type: LessonType.video,
        progressStatus: LessonProgressStatus.inProgress,
        orderIndex: 0,
        duration: '10 min',
        isLocked: false,
        lastWatchedDuration: '125.4',
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: lessonWithDecimal),
            overrides: [
              instituteSettingsProvider.overrideWith((ref) => enabledSettings),
            ],
          ),
        ),
      );
      await tester.pump();

      final playerFinder = find.byType(CustomVideoPlayer);
      expect(playerFinder, findsOneWidget);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      expect(player.initialPosition, equals(125.4));
    });
  });

  group('VideoLessonViewer Remember Playback Speed Prompt', () {
    testWidgets(
        'shows remember speed banner when speed changes to non-1x and not previously dismissed',
        (tester) async {
      final notifier = FakePlaybackSettingsNotifier(
        PlaybackSettings(
          quality: VideoQuality.auto,
          autoPlayNext: false,
          rememberPlaybackSpeed: false,
          globalPlaybackSpeed: null,
        ),
      );
      final promptNotifier = FakePlaybackSpeedPromptDismissed(false);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider.overrideWith(() => notifier),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => promptNotifier),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Remember 1.5X for future videos?'), findsNothing);

      // Trigger playback speed change on CustomVideoPlayer
      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      player.onPlaybackSpeedChanged?.call(1.5);

      await tester.pumpAndSettle();

      expect(find.text('Remember 1.5X for future videos?'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is Semantics &&
              w.container == true &&
              w.properties.label == 'Remember 1.5X for future videos?',
        ),
        findsOneWidget,
      );
      expect(find.text('Yes'), findsOneWidget);
      expect(find.text('No'), findsOneWidget);

      // Tap 'No'
      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(find.text('Remember 1.5X for future videos?'), findsNothing);
      expect(promptNotifier.dismissed, isTrue);
    });

    testWidgets('does not show banner if previously dismissed', (tester) async {
      final promptNotifier = FakePlaybackSpeedPromptDismissed(true);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider
                  .overrideWith(() => FakePlaybackSettingsNotifier(
                        PlaybackSettings(
                          quality: VideoQuality.auto,
                          autoPlayNext: false,
                          rememberPlaybackSpeed: false,
                          globalPlaybackSpeed: null,
                        ),
                      )),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => promptNotifier),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      player.onPlaybackSpeedChanged?.call(2.0);

      await tester.pumpAndSettle();

      expect(find.text('Remember 2X for future videos?'), findsNothing);
    });

    testWidgets('does not show banner when speed is 1.0x', (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider
                  .overrideWith(() => FakePlaybackSettingsNotifier(
                        PlaybackSettings(
                          quality: VideoQuality.auto,
                          autoPlayNext: false,
                          rememberPlaybackSpeed: false,
                          globalPlaybackSpeed: null,
                        ),
                      )),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => FakePlaybackSpeedPromptDismissed(false)),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      player.onPlaybackSpeedChanged?.call(1.0);

      await tester.pumpAndSettle();

      expect(find.textContaining('Remember'), findsNothing);
    });

    testWidgets(
        'accepting prompt enables rememberPlaybackSpeed and saves exact speed without setting dismissal flag',
        (tester) async {
      final notifier = FakePlaybackSettingsNotifier(
        PlaybackSettings(
          quality: VideoQuality.auto,
          autoPlayNext: false,
          rememberPlaybackSpeed: false,
          globalPlaybackSpeed: null,
        ),
      );
      final promptNotifier = FakePlaybackSpeedPromptDismissed(false);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider.overrideWith(() => notifier),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => promptNotifier),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      player.onPlaybackSpeedChanged?.call(1.75);

      await tester.pumpAndSettle();

      expect(find.text('Remember 1.75X for future videos?'), findsOneWidget);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(find.text('Remember 1.75X for future videos?'), findsNothing);
      expect(promptNotifier.dismissed, isNull);
      expect(notifier.savedRememberPlaybackSpeed, isTrue);
      expect(notifier.savedGlobalPlaybackSpeed, equals(1.75));
    });

    testWidgets('rapid speed changes update the speed displayed in the prompt',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider
                  .overrideWith(() => FakePlaybackSettingsNotifier(
                        PlaybackSettings(
                          quality: VideoQuality.auto,
                          autoPlayNext: false,
                          rememberPlaybackSpeed: false,
                          globalPlaybackSpeed: null,
                        ),
                      )),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => FakePlaybackSpeedPromptDismissed(false)),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);

      player.onPlaybackSpeedChanged?.call(1.5);
      await tester.pumpAndSettle();
      expect(find.text('Remember 1.5X for future videos?'), findsOneWidget);

      player.onPlaybackSpeedChanged?.call(2.0);
      await tester.pumpAndSettle();
      expect(find.text('Remember 2X for future videos?'), findsOneWidget);
    });

    testWidgets(
        'silently updates speed and shows no prompt when rememberPlaybackSpeed is ON',
        (tester) async {
      final notifier = FakePlaybackSettingsNotifier(
        PlaybackSettings(
          quality: VideoQuality.auto,
          autoPlayNext: false,
          rememberPlaybackSpeed: true,
          globalPlaybackSpeed: 1.5,
        ),
      );

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider.overrideWith(() => notifier),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => FakePlaybackSpeedPromptDismissed(false)),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);

      player.onPlaybackSpeedChanged?.call(2.0);
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Remember 2X for future videos?'), findsNothing);
      expect(notifier.savedGlobalPlaybackSpeed, equals(2.0));
    });

    testWidgets(
        'shows prompt when speed changes if rememberPlaybackSpeed was manually re-toggled OFF after prior dismissal',
        (tester) async {
      final notifier = FakePlaybackSettingsNotifier(
        PlaybackSettings(
          quality: VideoQuality.auto,
          autoPlayNext: false,
          rememberPlaybackSpeed: false,
          globalPlaybackSpeed: null,
        ),
      );
      final promptNotifier = FakePlaybackSpeedPromptDismissed(true);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 800)),
          child: wrap(
            const VideoLessonViewer(lesson: testLesson),
            overrides: [
              playbackSettingsNotifierProvider.overrideWith(() => notifier),
              playbackSpeedPromptDismissedProvider
                  .overrideWith(() => promptNotifier),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Simulate user manually toggling setting in settings screen
      final container = ProviderScope.containerOf(
          tester.element(find.byType(VideoLessonViewer)));
      await container.read(playbackSettingsNotifierProvider.future);
      await container
          .read(playbackSettingsNotifierProvider.notifier)
          .updateRememberPlaybackSpeed(false);
      await tester.pumpAndSettle();

      final playerFinder = find.byType(CustomVideoPlayer);
      final player = tester.widget<CustomVideoPlayer>(playerFinder);
      player.onPlaybackSpeedChanged?.call(1.75);
      await tester.pumpAndSettle();

      expect(find.text('Remember 1.75X for future videos?'), findsOneWidget);
    });
  });
}

class FakePlaybackSpeedPromptDismissed extends PlaybackSpeedPromptDismissed {
  FakePlaybackSpeedPromptDismissed([this._initial = false]);
  bool _initial;
  bool? dismissed;

  @override
  bool build() => _initial;

  @override
  Future<void> dismiss() async {
    dismissed = true;
    _initial = true;
    state = true;
  }

  @override
  Future<void> reset() async {
    dismissed = false;
    _initial = false;
    state = false;
  }
}

class FakePlaybackSettingsNotifier extends PlaybackSettingsNotifier {
  FakePlaybackSettingsNotifier(PlaybackSettings initial) : _current = initial;
  PlaybackSettings _current;

  bool? savedRememberPlaybackSpeed;
  double? savedGlobalPlaybackSpeed;

  @override
  Future<PlaybackSettings> build() async => _current;

  @override
  Future<void> updateRememberPlaybackSpeed(bool enabled) async {
    savedRememberPlaybackSpeed = enabled;
    await ref.read(playbackSpeedPromptDismissedProvider.notifier).reset();
    _current = _current.copyWith(
      rememberPlaybackSpeed: enabled,
    );
    state = AsyncValue.data(_current);
  }

  @override
  Future<void> enableRememberPlaybackSpeedAndSave(double speed) async {
    savedRememberPlaybackSpeed = true;
    savedGlobalPlaybackSpeed = speed;
    _current = _current.copyWith(
      rememberPlaybackSpeed: true,
      globalPlaybackSpeed: speed,
    );
    state = AsyncValue.data(_current);
  }

  @override
  Future<void> updateGlobalPlaybackSpeed(double speed) async {
    savedGlobalPlaybackSpeed = speed;
    _current = _current.copyWith(globalPlaybackSpeed: speed);
    state = AsyncValue.data(_current);
  }
}
