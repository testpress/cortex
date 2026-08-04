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
      contentId: const drift.Value('content_123'),
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
  });
}
