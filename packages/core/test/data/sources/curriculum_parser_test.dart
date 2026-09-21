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
      'handles in-progress attempts with hasAttempts=true and progressStatus=inProgress, while completed attempts have progressStatus=completed',
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

        // Both lessons are returned with hasAttempts=true, but progressStatus differs
        expect(curriculum.lessons.length, 2);

        final lesson1 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-1',
        );
        expect(
          lesson1.hasAttempts,
          true,
        ); // in-progress attempt is tracked in attempts / history
        expect(lesson1.progressStatus, LessonProgressStatus.inProgress);

        final lesson2 = curriculum.lessons.firstWhere(
          (l) => l.id == 'lesson-2',
        );
        expect(lesson2.id, 'lesson-2');
        expect(lesson2.hasAttempts, true);
        expect(lesson2.progressStatus, LessonProgressStatus.completed);
      },
    );
  });

  group('CurriculumParser locked_contents progressive lock tests', () {
    test(
      'marks lessons as locked or unlocked based on results.locked_contents',
      () {
        final payload = {
          'count': 3,
          'results': {
            'contents': [
              {
                'id': 101,
                'title': 'Lesson 1 (Unlocked)',
                'content_type': 'Exam',
                'active': true,
              },
              {
                'id': 102,
                'title': 'Lesson 2 (Locked)',
                'content_type': 'Exam',
                'active': true,
              },
              {
                'id': 103,
                'title': 'Lesson 3 (Locked)',
                'content_type': 'Video',
                'active': true,
              },
            ],
            'locked_contents': [102, 103],
          },
        };

        final lessons = CurriculumParser.mapLessons(payload);
        expect(lessons.length, 3);

        final l1 = lessons.firstWhere((l) => l.id == '101');
        final l2 = lessons.firstWhere((l) => l.id == '102');
        final l3 = lessons.firstWhere((l) => l.id == '103');

        expect(l1.isLocked, false);
        expect(l2.isLocked, true);
        expect(l3.isLocked, true);
      },
    );

    test('retains individual is_locked when locked_contents is omitted', () {
      final payload = {
        'results': {
          'contents': [
            {
              'id': 201,
              'title': 'Lesson With Explicit Lock',
              'content_type': 'Exam',
              'is_locked': true,
            },
            {
              'id': 202,
              'title': 'Lesson Unlocked',
              'content_type': 'Exam',
              'is_locked': false,
            },
          ],
        },
      };

      final lessons = CurriculumParser.mapLessons(payload);
      expect(lessons.firstWhere((l) => l.id == '201').isLocked, true);
      expect(lessons.firstWhere((l) => l.id == '202').isLocked, false);
    });
  });
}
