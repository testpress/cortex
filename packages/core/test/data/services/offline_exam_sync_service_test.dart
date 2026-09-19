import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/data/data.dart';
import 'package:core/data/services/offline_exam_sync_service.dart';
import 'package:drift/drift.dart' as drift;

@GenerateNiceMocks([
  MockSpec<DataSource>(as: #MockMockitoDataSource),
  MockSpec<SentryService>(as: #MockSentryService),
])
import 'offline_exam_sync_service_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockMockitoDataSource mockApi;
  late MockSentryService mockSentry;
  late OfflineExamSyncService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockApi = MockMockitoDataSource();
    mockSentry = MockSentryService();
    service = OfflineExamSyncService(db, mockApi, mockSentry);
  });

  tearDown(() async {
    await db.close();
  });

  group('OfflineExamSyncService tests', () {
    final testDownload = OfflineExamDownloadsTableCompanion(
      id: const drift.Value(1),
      examId: const drift.Value('exam_123'),
      title: const drift.Value('AIPMT 2014'),
      contentId: const drift.Value('123'),
      duration: const drift.Value('03:00:00'),
      questionCount: const drift.Value(180),
      questionsJson: const drift.Value('[]'),
      downloadedAt: drift.Value(DateTime.now()),
      status: const drift.Value('PENDING_SYNC'),
    );

    test(
      'Success path: PENDING_SYNC -> SYNCING -> SYNCED, syncedAt is populated and row retained',
      () async {
        // Insert a pending download
        await db.upsertDownload(testDownload);

        // Verify it's initially PENDING_SYNC
        var downloads = await db.getPendingSyncDownloads();
        expect(downloads.length, 1);
        expect(downloads.first.status, 'PENDING_SYNC');
        expect(downloads.first.syncedAt, isNull);

        // Mock API success
        when(
          mockApi.submitOfflineExamAnswers(any, any),
        ).thenAnswer((_) async => {});

        // Trigger sync
        await service.syncPendingExams();

        // Verify API was called
        verify(mockApi.submitOfflineExamAnswers('exam_123', any)).called(1);

        // Verify download status updated to SYNCED and syncedAt is set
        final allDownloads = await db.watchAllOfflineExams().first;
        expect(allDownloads.length, 1);
        expect(allDownloads.first.status, 'SYNCED');
        expect(allDownloads.first.syncedAt, isNotNull);
      },
    );

    test(
      'Payload contains integer chapter_content_id and exam_question_id',
      () async {
        await db.upsertDownload(testDownload);
        await db.upsertAnswer(
          OfflineExamAnswersTableCompanion(
            downloadId: const drift.Value(1),
            questionId: const drift.Value('456'),
            selectedChoices: const drift.Value('["choice_1", "choice_2"]'),
            shortAnswer: const drift.Value('My short answer'),
            review: const drift.Value(true),
            savedAt: drift.Value(DateTime.now()),
          ),
        );

        when(
          mockApi.submitOfflineExamAnswers(any, any),
        ).thenAnswer((_) async => {});

        await service.syncPendingExams();

        final captured = verify(
          mockApi.submitOfflineExamAnswers('exam_123', captureAny),
        ).captured;
        expect(captured.length, 1);

        final payload = captured.first as Map<String, dynamic>;
        final offlineAttempt =
            payload['offline_attempt'] as Map<String, dynamic>;
        expect(offlineAttempt['chapter_content_id'], 123);
        expect(offlineAttempt['chapter_content_id'], isA<int>());

        final offlineAnswers = payload['offline_answers'] as List<dynamic>;
        expect(offlineAnswers.length, 1);

        final answer = offlineAnswers.first as Map<String, dynamic>;
        expect(answer['exam_question_id'], 456);
        expect(answer['exam_question_id'], isA<int>());
        expect(answer['short_text'], 'My short answer');
        expect(answer['review'], isTrue);
      },
    );

    test('Non-numeric questionId is skipped and reported to Sentry', () async {
      await db.upsertDownload(testDownload);
      // Valid numeric question ID
      await db.upsertAnswer(
        OfflineExamAnswersTableCompanion(
          downloadId: const drift.Value(1),
          questionId: const drift.Value('456'),
          savedAt: drift.Value(DateTime.now()),
        ),
      );
      // Invalid non-numeric question ID
      await db.upsertAnswer(
        OfflineExamAnswersTableCompanion(
          downloadId: const drift.Value(1),
          questionId: const drift.Value('invalid_qid'),
          savedAt: drift.Value(DateTime.now()),
        ),
      );

      when(
        mockApi.submitOfflineExamAnswers(any, any),
      ).thenAnswer((_) async => {});

      await service.syncPendingExams();

      verify(
        mockSentry.captureException(any, level: AppErrorLevel.warning),
      ).called(1);

      final captured = verify(
        mockApi.submitOfflineExamAnswers('exam_123', captureAny),
      ).captured;
      final payload = captured.first as Map<String, dynamic>;
      final offlineAnswers = payload['offline_answers'] as List<dynamic>;

      // Only valid answer is included
      expect(offlineAnswers.length, 1);
      expect(offlineAnswers.first['exam_question_id'], 456);
    });

    test(
      'Non-numeric contentId captures error to Sentry once and drops download as permanent failure',
      () async {
        final invalidContentDownload = OfflineExamDownloadsTableCompanion(
          id: const drift.Value(2),
          examId: const drift.Value('exam_123'),
          title: const drift.Value('AIPMT 2014'),
          contentId: const drift.Value('non_numeric_content'),
          duration: const drift.Value('03:00:00'),
          questionCount: const drift.Value(180),
          questionsJson: const drift.Value('[]'),
          downloadedAt: drift.Value(DateTime.now()),
          status: const drift.Value('PENDING_SYNC'),
        );
        await db.upsertDownload(invalidContentDownload);

        await service.syncPendingExams();

        verifyNever(mockApi.submitOfflineExamAnswers(any, any));
        verify(
          mockSentry.captureException(any, level: AppErrorLevel.error),
        ).called(1);

        // Verify permanent failure dropped the corrupt download from DB
        final allDownloads = await db.watchAllOfflineExams().first;
        expect(allDownloads, isEmpty);
      },
    );

    test(
      'Transient failure path: PENDING_SYNC -> SYNCING -> PENDING_SYNC on network error',
      () async {
        // Insert a pending download
        await db.upsertDownload(testDownload);

        // Mock API throws transient error (DioException with 503)
        when(mockApi.submitOfflineExamAnswers(any, any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 503,
            ),
          ),
        );

        // Trigger sync
        await service.syncPendingExams();

        // Verify download reverted back to PENDING_SYNC and not deleted
        final allDownloads = await db.watchAllOfflineExams().first;
        expect(allDownloads.length, 1);
        expect(allDownloads.first.status, 'PENDING_SYNC');
        expect(allDownloads.first.syncedAt, isNull);
      },
    );

    test(
      'Permanent failure path: PENDING_SYNC -> SYNCING -> DELETED on 400 Bad Request',
      () async {
        // Insert a pending download
        await db.upsertDownload(testDownload);

        // Mock API throws permanent error (DioException with 400)
        when(mockApi.submitOfflineExamAnswers(any, any)).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            response: Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 400,
            ),
          ),
        );

        // Trigger sync
        await service.syncPendingExams();

        // Verify download row was deleted from the database
        final allDownloads = await db.watchAllOfflineExams().first;
        expect(allDownloads, isEmpty);
      },
    );

    group('syncExam(int downloadId) tests', () {
      test('returns false when download id is not found', () async {
        final result = await service.syncExam(999);
        expect(result, isFalse);
        verifyNever(mockApi.submitOfflineExamAnswers(any, any));
      });

      test(
        'success path: syncs specific exam, marks SYNCED and returns true',
        () async {
          await db.upsertDownload(testDownload);

          when(
            mockApi.submitOfflineExamAnswers(any, any),
          ).thenAnswer((_) async => {});

          final result = await service.syncExam(1);
          expect(result, isTrue);

          verify(mockApi.submitOfflineExamAnswers('exam_123', any)).called(1);

          final allDownloads = await db.watchAllOfflineExams().first;
          expect(allDownloads.length, 1);
          expect(allDownloads.first.status, 'SYNCED');
          expect(allDownloads.first.syncedAt, isNotNull);
        },
      );

      test(
        'transient failure: reverts to PENDING_SYNC and returns false',
        () async {
          await db.upsertDownload(testDownload);

          when(mockApi.submitOfflineExamAnswers(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 503,
              ),
            ),
          );

          final result = await service.syncExam(1);
          expect(result, isFalse);

          final allDownloads = await db.watchAllOfflineExams().first;
          expect(allDownloads.length, 1);
          expect(allDownloads.first.status, 'PENDING_SYNC');
          expect(allDownloads.first.syncedAt, isNull);
        },
      );

      test(
        'permanent failure: deletes download and returns false on 400',
        () async {
          await db.upsertDownload(testDownload);

          when(mockApi.submitOfflineExamAnswers(any, any)).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              response: Response(
                requestOptions: RequestOptions(path: ''),
                statusCode: 400,
              ),
            ),
          );

          final result = await service.syncExam(1);
          expect(result, isFalse);

          final allDownloads = await db.watchAllOfflineExams().first;
          expect(allDownloads, isEmpty);
        },
      );
    });
  });
}
