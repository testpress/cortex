import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/data.dart';
import 'package:core/network/file_downloader.dart';
import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:exams/repositories/exam_repository.dart';
import 'package:exams/repositories/offline_exam_repository.dart';

class FakeDataSource extends Fake implements DataSource {}

class FakeFileDownloader extends Fake implements FileDownloader {}

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
  late FakeDataSource fakeApi;
  late FakeFileDownloader fakeFileDownloader;
  late FakeSentryService fakeSentry;
  late OfflineExamRepository repository;

  const contentId = 'test_content_123';
  final testExam = ExamDto(
    id: 'exam_123',
    title: 'Offline Test Exam',
    duration: '01:00:00',
    questionCount: 10,
    attemptsUrl: 'https://example.com/attempts',
  );

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    fakeApi = FakeDataSource();
    fakeFileDownloader = FakeFileDownloader();
    fakeSentry = FakeSentryService();

    repository = OfflineExamRepository(
      db: db,
      api: fakeApi,
      fileDownloader: fakeFileDownloader,
      sentryService: fakeSentry,
      contentId: contentId,
    );
  });

  tearDown(() async {
    repository.reset();
    await db.close();
  });

  group('OfflineExamRepository startExam synced state guard', () {
    test(
      'startStandaloneExam on a download with status SYNCED emits error with offlineExamAlreadySynced',
      () async {
        await db.upsertDownload(
          OfflineExamDownloadsTableCompanion(
            id: const drift.Value(1),
            contentId: const drift.Value(contentId),
            examId: const drift.Value('exam_123'),
            title: const drift.Value('Offline Test Exam'),
            duration: const drift.Value('01:00:00'),
            questionCount: const drift.Value(10),
            questionsJson: const drift.Value('[]'),
            status: const drift.Value('SYNCED'),
            downloadedAt: drift.Value(DateTime.now()),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );

        final states = <ExamAttemptState>[];
        final sub = repository.stateStream.listen(states.add);

        await repository.startStandaloneExam(testExam);
        await pumpEventQueue();

        expect(repository.state.status, ExamAttemptStatus.error);
        expect(
          repository.state.errorMessage,
          ExamErrorCodes.offlineExamAlreadySynced,
        );
        expect(states.map((s) => s.status), [
          ExamAttemptStatus.loading,
          ExamAttemptStatus.error,
        ]);
        expect(
          states.last.errorMessage,
          ExamErrorCodes.offlineExamAlreadySynced,
        );

        await sub.cancel();
      },
    );

    test(
      'startCourseLinkedExam on a download with status SYNCED emits error with offlineExamAlreadySynced',
      () async {
        await db.upsertDownload(
          OfflineExamDownloadsTableCompanion(
            id: const drift.Value(1),
            contentId: const drift.Value(contentId),
            examId: const drift.Value('exam_123'),
            title: const drift.Value('Offline Test Exam'),
            duration: const drift.Value('01:00:00'),
            questionCount: const drift.Value(10),
            questionsJson: const drift.Value('[]'),
            status: const drift.Value('SYNCED'),
            downloadedAt: drift.Value(DateTime.now()),
            syncedAt: drift.Value(DateTime.now()),
          ),
        );

        await repository.startCourseLinkedExam(
          testExam,
          'https://example.com/attempts',
        );

        expect(repository.state.status, ExamAttemptStatus.error);
        expect(
          repository.state.errorMessage,
          ExamErrorCodes.offlineExamAlreadySynced,
        );
      },
    );

    test(
      'startStandaloneExam when no download exists emits error with offlineDataNotFound',
      () async {
        await repository.startStandaloneExam(testExam);

        expect(repository.state.status, ExamAttemptStatus.error);
        expect(
          repository.state.errorMessage,
          ExamErrorCodes.offlineDataNotFound,
        );
      },
    );
  });
}
