import 'package:core/data/data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LessonDto.fromJson — progressStatus derivation', () {
    /// Minimal valid JSON for a lesson with no attempts.
    /// [contentType] must be a string that matches the parser's contains() checks:
    /// 'exam', 'video', 'live', 'notes', etc.
    Map<String, dynamic> lessonJson({
      int attemptsCount = 0,
      int pausedAttemptsCount = 0,
      String? state,
      String contentType = 'exam',
    }) => {
      'id': '1',
      'title': 'Sample Lesson',
      'content_type': contentType,
      'active': true,
      'attempts_count': attemptsCount,
      'paused_attempts_count': pausedAttemptsCount,
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

    test(
      'exam with only paused attempts is NOT marked completed and hasAttempts is false',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 1, pausedAttemptsCount: 1),
        );

        expect(dto.progressStatus, LessonProgressStatus.notStarted);
        expect(dto.hasAttempts, false);
      },
    );

    test(
      'exam with mixed paused and completed attempts is marked completed and hasAttempts is true',
      () {
        final dto = LessonDto.fromJson(
          lessonJson(attemptsCount: 2, pausedAttemptsCount: 1),
        );

        expect(dto.progressStatus, LessonProgressStatus.completed);
        expect(dto.hasAttempts, true);
      },
    );

    test(
      'mergeWith does not re-promote a paused-only exam after fromJson re-parse',
      () {
        // fromJson sees attempts_count=1, paused_attempts_count=1 (paused-only)
        final fresh = LessonDto.fromJson({
          'id': '1',
          'content_type': 'exam',
          'active': true,
          'attempts_count': 1,
          'paused_attempts_count': 1,
        });
        // Sync sets authoritative notStarted
        final synced = fresh.copyWith(
          hasAttempts: false,
          progressStatus: LessonProgressStatus.notStarted,
        );
        // Next refreshLessons re-parses and merges
        final merged = fresh.mergeWith(synced);
        expect(merged.hasAttempts, false);
        expect(merged.progressStatus, LessonProgressStatus.notStarted);
      },
    );
  });
}
