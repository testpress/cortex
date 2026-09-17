import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/dashboard_dto.dart';
import 'package:core/data/models/lesson_dto.dart';

void main() {
  group('DashboardContentDto', () {
    test('mapContentType maps string types correctly to LessonType', () {
      expect(DashboardContentDto.mapContentType('video'), LessonType.video);
      expect(
        DashboardContentDto.mapContentType('PDF_DOCUMENT'),
        LessonType.pdf,
      );
      expect(
        DashboardContentDto.mapContentType('html_notes'),
        LessonType.notes,
      );
      expect(DashboardContentDto.mapContentType('notes'), LessonType.notes);
      expect(
        DashboardContentDto.mapContentType('online_test'),
        LessonType.test,
      );
      expect(DashboardContentDto.mapContentType('exam'), LessonType.test);
      expect(
        DashboardContentDto.mapContentType('assessment'),
        LessonType.assessment,
      );
      expect(
        DashboardContentDto.mapContentType('quick_quiz'),
        LessonType.assessment,
      );
      expect(
        DashboardContentDto.mapContentType('live_stream'),
        LessonType.liveStream,
      );
      expect(
        DashboardContentDto.mapContentType('attachment_file'),
        LessonType.attachment,
      );
      expect(
        DashboardContentDto.mapContentType('embed_widget'),
        LessonType.embedContent,
      );
      expect(
        DashboardContentDto.mapContentType('unknown_xyz'),
        LessonType.unknown,
      );
    });

    group('toLessonDto', () {
      test('maps fields correctly to LessonDto', () {
        final content = DashboardContentDto(
          id: 'lesson-123',
          title: 'Introduction to Flutter',
          contentType: LessonType.video,
          chapterId: 'chap-456',
          chapterTitle: 'Flutter Basics',
          totalDuration: '15 min',
          remainingDuration: '5 min',
          progress: 50.0,
        );

        final lesson = content.toLessonDto();

        expect(lesson.id, 'lesson-123');
        expect(lesson.title, 'Introduction to Flutter');
        expect(lesson.type, LessonType.video);
        expect(lesson.chapterId, 'chap-456');
        expect(lesson.chapterTitle, 'Flutter Basics');
        expect(lesson.duration, '15 min');
        expect(lesson.isLocked, isFalse);
        expect(lesson.orderIndex, 0);
        expect(lesson.progressStatus, LessonProgressStatus.inProgress);
      });

      test('handles null chapterId and duration gracefully', () {
        final content = DashboardContentDto(
          id: 'lesson-999',
          title: 'Orphan Lesson',
          contentType: LessonType.pdf,
        );

        final lesson = content.toLessonDto();

        expect(lesson.id, 'lesson-999');
        expect(lesson.chapterId, '');
        expect(lesson.chapterTitle, isNull);
        expect(lesson.duration, '');
        expect(lesson.progressStatus, LessonProgressStatus.notStarted);
      });

      test('maps progress status accurately based on percentage', () {
        // null progress -> notStarted
        final nullProgress = DashboardContentDto(
          id: '1',
          title: 'T',
          contentType: LessonType.notes,
          progress: null,
        );
        expect(
          nullProgress.toLessonDto().progressStatus,
          LessonProgressStatus.notStarted,
        );

        // 0.0 progress -> notStarted
        final zeroProgress = DashboardContentDto(
          id: '2',
          title: 'T',
          contentType: LessonType.notes,
          progress: 0.0,
        );
        expect(
          zeroProgress.toLessonDto().progressStatus,
          LessonProgressStatus.notStarted,
        );

        // 50.0 progress -> inProgress
        final midProgress = DashboardContentDto(
          id: '3',
          title: 'T',
          contentType: LessonType.notes,
          progress: 50.0,
        );
        expect(
          midProgress.toLessonDto().progressStatus,
          LessonProgressStatus.inProgress,
        );

        // 100.0 progress -> completed
        final completeProgress = DashboardContentDto(
          id: '4',
          title: 'T',
          contentType: LessonType.notes,
          progress: 100.0,
        );
        expect(
          completeProgress.toLessonDto().progressStatus,
          LessonProgressStatus.completed,
        );

        // > 100.0 progress -> completed
        final overProgress = DashboardContentDto(
          id: '5',
          title: 'T',
          contentType: LessonType.notes,
          progress: 110.0,
        );
        expect(
          overProgress.toLessonDto().progressStatus,
          LessonProgressStatus.completed,
        );
      });
    });
  });
}
