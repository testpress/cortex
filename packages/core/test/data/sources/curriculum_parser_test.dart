import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/sources/curriculum_parser.dart';
import 'package:core/data/models/lesson_dto.dart';

void main() {
  group('CurriculumParser attempts sync tests', () {
    test(
      'ignores chapter_contents attempts_count and derives completion strictly from actual content_attempts',
      () {
        final rawPayload = {
          'results': {
            'chapter_contents': [
              {
                'id': 'lesson-1',
                'title': 'Lesson 1',
                'content_type': 'Exam',
                'attempts_count':
                    5, // has attempts in metadata list but no actual attempt record
              },
              {
                'id': 'lesson-2',
                'title': 'Lesson 2',
                'content_type': 'Exam',
                'attempts_count':
                    0, // 0 in metadata list but has actual attempt record
              },
              {
                'id': 'lesson-3',
                'title': 'Lesson 3',
                'content_type': 'Exam',
                'attempts_count': 0, // 0 in metadata list and no attempt record
              },
            ],
            'content_attempts': [
              {
                'id': 'attempt-101',
                'chapter_content_id': 'lesson-2',
                'assessment': {
                  'id': 'assess-101',
                  'state': '1', // completed attempt
                },
              },
            ],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);

        // Verify that all 3 lessons are returned, but only lesson-2 has attempts
        expect(curriculum.lessons.length, 3);
        final lesson2 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-2',
        );
        expect(lesson2.id, 'lesson-2');
        expect(lesson2.hasAttempts, true);
        expect(lesson2.progressStatus, LessonProgressStatus.completed);

        final lesson1 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-1',
        );
        expect(lesson1.hasAttempts, false);
        expect(lesson1.progressStatus, LessonProgressStatus.notStarted);
      },
    );

    test(
      'filters out in-progress attempts and only counts completed attempts',
      () {
        final rawPayload = {
          'results': {
            'chapter_contents': [
              {
                'id': 'lesson-1',
                'title': 'Lesson 1',
                'content_type': 'Exam',
                'attempts_count': 0,
              },
              {
                'id': 'lesson-2',
                'title': 'Lesson 2',
                'content_type': 'Exam',
                'attempts_count': 0,
              },
            ],
            'content_attempts': [
              {
                'id': 'attempt-102',
                'chapter_content_id': 'lesson-1',
                'assessment': {
                  'id': 'assess-102',
                  'state': '0', // in-progress attempt
                },
              },
              {
                'id': 'attempt-103',
                'chapter_content_id': 'lesson-2',
                'attempt': {
                  'id': 'att-103',
                  'state': 'completed', // completed attempt in different format
                },
              },
            ],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);

        // Both lessons are returned, but only lesson-2 is completed
        expect(curriculum.lessons.length, 2);

        final lesson1 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-1',
        );
        expect(
          lesson1.hasAttempts,
          false,
        ); // in-progress attempt is treated as not completed
        expect(lesson1.progressStatus, LessonProgressStatus.notStarted);

        final lesson2 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-2',
        );
        expect(lesson2.hasAttempts, true);
        expect(lesson2.progressStatus, LessonProgressStatus.completed);
      },
    );
  });
}
