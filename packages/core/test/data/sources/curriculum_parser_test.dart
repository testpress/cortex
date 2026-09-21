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

  group('CurriculumParser progressive locked_contents tests', () {
    test(
      'marks lessons present in locked_contents array as isLocked = true, preserves explicit is_locked, and keeps active items unlocked',
      () {
        final rawPayload = {
          'results': {
            'contents': [
              {
                'id': 101,
                'title': 'Lesson 1: Intro',
                'content_type': 'video',
                'active': true,
              },
              {
                'id': 102,
                'title': 'Lesson 2: Advanced',
                'content_type': 'video',
                'active': true,
              },
              {
                'id': 103,
                'title': 'Lesson 3: Masterclass',
                'content_type': 'video',
                'active': true,
                'is_locked': true,
              },
            ],
            'locked_contents': [102],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);
        expect(curriculum.lessons.length, 3);

        final lesson101 = curriculum.lessons.firstWhere((l) => l.id == '101');
        expect(lesson101.isLocked, isFalse);

        final lesson102 = curriculum.lessons.firstWhere((l) => l.id == '102');
        expect(lesson102.isLocked, isTrue);

        final lesson103 = curriculum.lessons.firstWhere((l) => l.id == '103');
        expect(lesson103.isLocked, isTrue);
      },
    );

    test(
      'lesson with no is_locked, isLocked, or active fields and empty locked_contents defaults to isLocked = false',
      () {
        final rawPayload = {
          'results': {
            'contents': [
              {'id': 201, 'title': 'Open Lesson', 'content_type': 'video'},
            ],
            'locked_contents': [],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);
        expect(curriculum.lessons.length, 1);

        final lesson = curriculum.lessons.first;
        expect(lesson.isLocked, isFalse);
      },
    );

    test(
      'lesson with no is_locked, isLocked, or active fields but present in locked_contents sets isLocked = true',
      () {
        final rawPayload = {
          'results': {
            'contents': [
              {
                'id': 202,
                'title': 'Progressively Locked Lesson',
                'content_type': 'video',
              },
            ],
            'locked_contents': [202],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);
        expect(curriculum.lessons.length, 1);

        final lesson = curriculum.lessons.first;
        expect(lesson.isLocked, isTrue);
      },
    );

    test(
      'ended or inactive exam with active = false not in locked_contents sets isLocked = false',
      () {
        final rawPayload = {
          'results': {
            'contents': [
              {
                'id': 301,
                'title': 'Ended GMAT Adaptive Exam',
                'content_type': 'exam',
                'active': false,
                'has_ended': true,
              },
            ],
            'locked_contents': [],
          },
        };

        final curriculum = CurriculumParser.parseFullCurriculum(rawPayload);
        expect(curriculum.lessons.length, 1);

        final lesson = curriculum.lessons.first;
        expect(lesson.isLocked, isFalse);
        expect(lesson.hasEnded, isTrue);
      },
    );
  });
}
