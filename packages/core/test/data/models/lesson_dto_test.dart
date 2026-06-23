import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LessonDto.fromJson — progressStatus derivation', () {
    /// Minimal valid JSON for a lesson with no attempts.
    /// [contentType] must be a string that matches the parser's contains() checks:
    /// 'exam', 'video', 'live', 'notes', etc.
    Map<String, dynamic> lessonJson({
      int attemptsCount = 0,
      String? state,
      String contentType = 'exam',
    }) => {
      'id': '1',
      'title': 'Sample Lesson',
      'content_type': contentType,
      'active': true,
      'attempts_count': attemptsCount,
      // ignore: use_null_aware_elements
      if (state != null) 'state': state,
    };

    test(
      'exam with attempts_count > 0 and no explicit state is marked completed',
      () {
        final dto = LessonDto.fromJson(lessonJson(attemptsCount: 1));

        expect(dto.progressStatus, LessonProgressStatus.completed);
        expect(dto.hasAttempts, true);
      },
    );

    test('exam with attempts_count == 0 keeps notStarted status', () {
      final dto = LessonDto.fromJson(lessonJson(attemptsCount: 0));

      expect(dto.progressStatus, LessonProgressStatus.notStarted);
      expect(dto.hasAttempts, false);
    });

    test(
      'exam with attempts_count > 0 and explicit state=completed remains completed',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, state: 'completed'),
        );

        expect(dto.progressStatus, LessonProgressStatus.completed);
      },
    );

    test('video with attempts_count > 0 is NOT promoted to completed '
        '— only non-video types use the attempts_count override', () {
      final dto = LessonDto.fromJson(
        lessonJson(attemptsCount: 5, contentType: 'video'),
      );

      // Video lessons must not be promoted by attempts_count.
      expect(dto.progressStatus, isNot(LessonProgressStatus.completed));
    });

    test(
      'live-stream with attempts_count > 0 is NOT promoted to completed',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, contentType: 'live'),
        );

        expect(dto.progressStatus, isNot(LessonProgressStatus.completed));
      },
    );

    test('exam with attempts_count > 0 is treated as completed on initial load '
        'even when attempt may be paused — sync layer corrects this later', () {
      // Documents the intentional trade-off: optimistic completed on first
      // parse; CurriculumParser overrides with the real state on sync.
      final dto = LessonDto.fromJson(lessonJson(attemptsCount: 1));

      expect(dto.progressStatus, LessonProgressStatus.completed);
    });
  });
}
