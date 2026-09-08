import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_detail/video_lesson_viewer.dart';

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
}
