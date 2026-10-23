import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:drift/native.dart';
import 'package:exams/repositories/exam_repository.dart';

class FakeDataSource extends Fake implements DataSource {
  final List<AttemptDto> attempts;
  final List<QuestionDto> questions;
  final SectionDto? endedSectionResult;
  final SectionDto? startedSectionResult;

  FakeDataSource({
    this.attempts = const [],
    this.questions = const [],
    this.endedSectionResult,
    this.startedSectionResult,
  });

  @override
  Future<List<AttemptDto>> getAttempts(String attemptsUrl) async => attempts;

  @override
  Future<List<QuestionDto>> getQuestions(String attemptId) async => questions;

  @override
  Future<AttemptDto> sendHeartbeat(String attemptId) async => attempts.first;

  @override
  Future<SectionDto> endSection(String attemptId, String sectionOrder) async =>
      endedSectionResult ??
      const SectionDto(
        id: '0',
        name: 'RA',
        state: 'Completed',
        order: 0,
        infoId: '53219',
      );

  @override
  Future<SectionDto> startSection(
    String attemptId,
    String sectionOrder,
  ) async =>
      startedSectionResult ??
      const SectionDto(
        id: '1',
        name: 'QA',
        state: 'Running',
        order: 1,
        infoId: '53220',
      );
}

class FakeSentryService extends Fake implements SentryService {
  @override
  Future<void> captureException(
    dynamic exception, {
    Map<String, dynamic>? contexts,
    AppErrorLevel? level,
    dynamic stackTrace,
    Map<String, String>? tags,
  }) async {}
}

void main() {
  late AppDatabase db;
  late FakeSentryService fakeSentry;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    fakeSentry = FakeSentryService();
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'OnlineExamRepository filters questions by section.infoId on resume when sectional lock is active',
    () async {
      const activeSectionInfoId = '53220';
      const completedSectionInfoId = '53219';

      final attempt = AttemptDto(
        id: 1162936,
        state: 'Running',
        remainingTime: '0:20:00',
        sections: [
          const SectionDto(
            id: '0',
            name: 'RA',
            state: 'Completed',
            duration: '0:25:00',
            order: 0,
            infoId: completedSectionInfoId,
          ),
          const SectionDto(
            id: '1',
            name: 'QA',
            state: 'Running',
            duration: '0:20:00',
            order: 1,
            infoId: activeSectionInfoId,
          ),
        ],
      );

      final List<QuestionDto> questions = [
        const QuestionDto(
          id: 'q1',
          text: 'Question 1',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 0,
          sectionId: completedSectionInfoId,
        ),
        const QuestionDto(
          id: 'q2',
          text: 'Question 2',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 1,
          sectionId: activeSectionInfoId,
        ),
      ];

      final fakeApi = FakeDataSource(attempts: [attempt], questions: questions);

      final repository = OnlineExamRepository(
        dataSource: fakeApi,
        dbFuture: Future.value(db),
        sentryService: fakeSentry,
      );

      final exam = ExamDto(
        id: 'exam_1',
        title: 'RRB Test',
        duration: '0:45:00',
        questionCount: 2,
        attemptsUrl: 'https://example.com/attempts/',
        pausedAttemptsCount: 1,
      );

      await repository.startCourseLinkedExam(
        exam,
        'https://example.com/attempts/',
      );

      final state = repository.state;
      expect(state.status, ExamAttemptStatus.inProgress);
      // Verify that the active section's question was kept and not dropped
      expect(state.questions.length, 1);
      expect(state.questions.first.id, 'q2');
      expect(state.questions.first.sectionId, activeSectionInfoId);
    },
  );

  test(
    'OnlineExamRepository switches section and filters questions by nextSection.infoId',
    () async {
      const firstSectionInfoId = '53219';
      const secondSectionInfoId = '53220';

      final attempt = AttemptDto(
        id: 1162936,
        state: 'Running',
        remainingTime: '0:25:00',
        sections: [
          const SectionDto(
            id: '0',
            name: 'RA',
            state: 'Running',
            duration: '0:25:00',
            order: 0,
            infoId: firstSectionInfoId,
          ),
          const SectionDto(
            id: '1',
            name: 'QA',
            state: 'Not Started',
            duration: '0:20:00',
            order: 1,
            infoId: secondSectionInfoId,
          ),
        ],
      );

      final List<QuestionDto> questions = [
        const QuestionDto(
          id: 'q1',
          text: 'Question 1',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 0,
          sectionId: firstSectionInfoId,
        ),
        const QuestionDto(
          id: 'q2',
          text: 'Question 2',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 1,
          sectionId: secondSectionInfoId,
        ),
      ];

      final fakeApi = FakeDataSource(attempts: [attempt], questions: questions);

      final repository = OnlineExamRepository(
        dataSource: fakeApi,
        dbFuture: Future.value(db),
        sentryService: fakeSentry,
      );

      final exam = ExamDto(
        id: 'exam_1',
        title: 'RRB Test',
        duration: '0:45:00',
        questionCount: 2,
        attemptsUrl: 'https://example.com/attempts/',
        pausedAttemptsCount: 1,
      );

      await repository.startCourseLinkedExam(
        exam,
        'https://example.com/attempts/',
      );
      expect(repository.state.questions.length, 1);
      expect(repository.state.questions.first.id, 'q1');

      // Now switch to section index 1 (QA)
      await repository.switchSection(1);
      expect(repository.state.questions.length, 1);
      expect(repository.state.questions.first.id, 'q2');
      expect(repository.state.questions.first.sectionId, secondSectionInfoId);
    },
  );

  test(
    'OnlineExamRepository avoids ID collision between section index and infoId',
    () async {
      final attempt = AttemptDto(
        id: 1162936,
        state: 'Running',
        remainingTime: '0:20:00',
        sections: [
          const SectionDto(
            id: '0',
            name: 'Section A',
            state: 'Completed',
            duration: '0:25:00',
            order: 0,
            infoId: '1',
          ),
          const SectionDto(
            id: '1',
            name: 'Section B',
            state: 'Running',
            duration: '0:20:00',
            order: 1,
            infoId: '2',
          ),
        ],
      );

      final List<QuestionDto> questions = [
        const QuestionDto(
          id: 'q1',
          text: 'Question for Section A',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 0,
          sectionId: '1',
        ),
        const QuestionDto(
          id: 'q2',
          text: 'Question for Section B',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 1,
          sectionId: '2',
        ),
      ];

      final fakeApi = FakeDataSource(attempts: [attempt], questions: questions);

      final repository = OnlineExamRepository(
        dataSource: fakeApi,
        dbFuture: Future.value(db),
        sentryService: fakeSentry,
      );

      final exam = ExamDto(
        id: 'exam_1',
        title: 'RRB Test',
        duration: '0:45:00',
        questionCount: 2,
        attemptsUrl: 'https://example.com/attempts/',
        pausedAttemptsCount: 1,
      );

      await repository.startCourseLinkedExam(
        exam,
        'https://example.com/attempts/',
      );

      final state = repository.state;
      expect(state.status, ExamAttemptStatus.inProgress);
      expect(state.questions.length, 1);
      expect(state.questions.first.id, 'q2');
    },
  );

  test(
    'OnlineExamRepository falls back to section.id when infoId is null',
    () async {
      final attempt = AttemptDto(
        id: 1162936,
        state: 'Running',
        remainingTime: '0:20:00',
        sections: [
          const SectionDto(
            id: 'sec_alpha',
            name: 'Alpha',
            state: 'Running',
            duration: '0:25:00',
            order: 0,
            infoId: null,
          ),
          const SectionDto(
            id: 'sec_beta',
            name: 'Beta',
            state: 'Not Started',
            duration: '0:20:00',
            order: 1,
            infoId: null,
          ),
        ],
      );

      final List<QuestionDto> questions = [
        const QuestionDto(
          id: 'q1',
          text: 'Alpha Question',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 0,
          sectionId: 'sec_alpha',
        ),
        const QuestionDto(
          id: 'q2',
          text: 'Beta Question',
          type: 'MCQ',
          options: [],
          answerUrl: '',
          order: 1,
          sectionId: 'sec_beta',
        ),
      ];

      final fakeApi = FakeDataSource(attempts: [attempt], questions: questions);

      final repository = OnlineExamRepository(
        dataSource: fakeApi,
        dbFuture: Future.value(db),
        sentryService: fakeSentry,
      );

      final exam = ExamDto(
        id: 'exam_1',
        title: 'Fallback Test',
        duration: '0:45:00',
        questionCount: 2,
        attemptsUrl: 'https://example.com/attempts/',
        pausedAttemptsCount: 1,
      );

      await repository.startCourseLinkedExam(
        exam,
        'https://example.com/attempts/',
      );
      expect(repository.state.questions.length, 1);
      expect(repository.state.questions.first.id, 'q1');
    },
  );
}
