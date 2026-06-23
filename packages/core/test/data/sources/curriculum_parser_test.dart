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

        // Verify that only lesson-2 exists in the returned lessons
        expect(curriculum.lessons.length, 1);
        final parsedLesson = curriculum.lessons.first;
        expect(parsedLesson.id, 'lesson-2');
        expect(parsedLesson.hasAttempts, true);
        expect(parsedLesson.progressStatus, LessonProgressStatus.completed);
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

        // Only lesson-2 (completed) should be returned
        expect(curriculum.lessons.length, 1);
        final parsedLesson = curriculum.lessons.first;
        expect(parsedLesson.id, 'lesson-2');
        expect(parsedLesson.hasAttempts, true);
        expect(parsedLesson.progressStatus, LessonProgressStatus.completed);
      },
    );
  });
}
