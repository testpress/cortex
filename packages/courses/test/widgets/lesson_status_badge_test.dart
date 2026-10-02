import 'package:core/data/data.dart';
import 'package:courses/widgets/lesson_status_badge.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LessonStatusBadge.shouldShow', () {
    test('returns false for liveStream regardless of status', () {
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.completed,
          type: LessonType.liveStream,
        ),
        isFalse,
      );
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.inProgress,
          type: LessonType.liveStream,
        ),
        isFalse,
      );
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.notStarted,
          type: LessonType.liveStream,
        ),
        isFalse,
      );
    });

    test('returns false for notStarted status', () {
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.notStarted,
          type: LessonType.video,
        ),
        isFalse,
      );
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.notStarted,
        ),
        isFalse,
      );
    });

    test('returns true for completed and inProgress when not liveStream', () {
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.completed,
          type: LessonType.video,
        ),
        isTrue,
      );
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.inProgress,
          type: LessonType.pdf,
        ),
        isTrue,
      );
      expect(
        LessonStatusBadge.shouldShow(
          status: LessonProgressStatus.inProgress,
        ),
        isTrue,
      );
    });
  });
}
