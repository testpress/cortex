import 'dart:async';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:core/data/data.dart';
import 'package:core/data/repositories/user_repository.dart';

class FakeDownloadsService extends Fake implements DownloadsService {
  final StreamController<bg.TaskUpdate> attachmentUpdatesController =
      StreamController<bg.TaskUpdate>.broadcast();

  final List<String> pausedTaskIds = [];
  final List<String> resumedTaskIds = [];
  final List<String> watermarkedPdfCalls = [];
  Set<String> activeTaskIds = {};

  @override
  Stream<List<DownloadItem>> get downloadsStream => const Stream.empty();

  @override
  Stream<bg.TaskUpdate> get attachmentUpdates =>
      attachmentUpdatesController.stream;

  @override
  Future<List<DownloadItem>> getActiveVideoDownloads() async => [];

  @override
  Future<Set<String>> getActiveAttachmentTaskIds() async => activeTaskIds;

  @override
  Future<bool> verifyAttachmentExists(String url) async => false;

  @override
  Future<void> requestNotificationPermission() async {}

  @override
  Future<void> pauseAttachmentDownload(String taskId) async {
    pausedTaskIds.add(taskId);
  }

  @override
  Future<void> resumeAttachmentDownload(String taskId, String url) async {
    resumedTaskIds.add(taskId);
  }

  @override
  Future<(String, int, String)> downloadWatermarkedPdf({
    required String url,
    required String title,
    required bool applyWatermark,
    String? taskId,
    String? watermarkText,
    void Function(int progressPercent)? onProgress,
  }) async {
    watermarkedPdfCalls.add(taskId ?? url);
    return (taskId ?? 'task_pdf', 1024, '/path/to/watermarked.pdf');
  }
}

class FakeSentryService extends Fake implements SentryService {
  @override
  Future<void> captureException(
    dynamic exception, {
    dynamic stackTrace,
    dynamic hint,
    dynamic level,
    Map<String, dynamic>? contexts,
    Map<String, String>? tags,
  }) async {}
}

class FakeUserRepository extends Fake implements UserRepository {
  @override
  Future<UsersTableData?> getCurrentProfile() async => null;
}

void main() {
  late AppDatabase db;
  late FakeDownloadsService service;
  late FakeUserRepository userRepo;
  late FakeSentryService sentry;
  late DownloadsRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    service = FakeDownloadsService();
    userRepo = FakeUserRepository();
    sentry = FakeSentryService();
    repository = DownloadsRepository(db, service, userRepo, sentry);
  });

  tearDown(() async {
    await service.attachmentUpdatesController.close();
    await db.close();
  });

  group('DownloadsRepository — Pause, Resume & Cold Start Reconciliation', () {
    test('pauseDownload sets status to paused for attachment', () async {
      final item = DownloadItem(
        id: 'att_1',
        title: 'Document 1',
        course: 'Test Course',
        chapter: 'Chapter 1',
        sizeInBytes: 1024,
        downloadedDate: '2026-09-10',
        type: DownloadType.attachment,
        status: DownloadStatus.downloading,
        progress: 45,
        taskId: 'task_att_1',
        contentUrl: 'https://example.com/doc.pdf',
      );

      await repository.upsertDownload(item);

      await repository.pauseDownload('att_1');

      final updated = await repository.getDownload('att_1');
      expect(updated?.status, DownloadStatus.paused);
      expect(service.pausedTaskIds, contains('task_att_1'));
    });

    test(
      'resumeDownload sets status to downloading and calls service',
      () async {
        final item = DownloadItem(
          id: 'att_2',
          title: 'Document 2',
          course: 'Test Course',
          chapter: 'Chapter 1',
          sizeInBytes: 2048,
          downloadedDate: '2026-09-10',
          type: DownloadType.attachment,
          status: DownloadStatus.paused,
          progress: 60,
          taskId: 'task_att_2',
          contentUrl: 'https://example.com/doc2.pdf',
        );

        await repository.upsertDownload(item);

        await repository.resumeDownload('att_2');

        final updated = await repository.getDownload('att_2');
        expect(updated?.status, DownloadStatus.downloading);
        expect(service.resumedTaskIds, contains('task_att_2'));
      },
    );

    test(
      'synchronize reconciles stuck downloading tasks to paused if not active in OS',
      () async {
        // Inactive task in OS
        service.activeTaskIds = {'other_task'};

        final stuckItem = DownloadItem(
          id: 'att_stuck',
          title: 'Stuck Doc',
          course: 'Test Course',
          chapter: 'Chapter 1',
          sizeInBytes: 5000,
          downloadedDate: '2026-09-10',
          type: DownloadType.attachment,
          status: DownloadStatus.downloading,
          progress: 30,
          taskId: 'task_stuck',
          contentUrl: 'https://example.com/stuck.pdf',
        );

        await repository.upsertDownload(stuckItem);

        await repository.synchronize();

        final reconciled = await repository.getDownload('att_stuck');
        expect(reconciled?.status, DownloadStatus.paused);
        expect(reconciled?.progress, 30);
      },
    );

    test(
      'synchronize keeps downloading status if task is active in OS',
      () async {
        service.activeTaskIds = {'task_active'};

        final activeItem = DownloadItem(
          id: 'att_active',
          title: 'Active Doc',
          course: 'Test Course',
          chapter: 'Chapter 1',
          sizeInBytes: 5000,
          downloadedDate: '2026-09-10',
          type: DownloadType.attachment,
          status: DownloadStatus.downloading,
          progress: 50,
          taskId: 'task_active',
          contentUrl: 'https://example.com/active.pdf',
        );

        await repository.upsertDownload(activeItem);

        await repository.synchronize();

        final itemAfterSync = await repository.getDownload('att_active');
        expect(itemAfterSync?.status, DownloadStatus.downloading);
      },
    );

    test(
      'startWatermarkedPdfDownload persists isWatermarked immediately on initial insert',
      () async {
        final item = DownloadItem(
          id: 'pdf_init',
          title: 'Initial PDF',
          course: 'Course',
          chapter: 'Chapter',
          sizeInBytes: 0,
          downloadedDate: '2026-09-10',
          type: DownloadType.attachment,
          status: DownloadStatus.downloading,
          progress: 0,
          fileType: 'PDF',
          contentUrl: 'https://example.com/init.pdf',
        );

        await repository.startWatermarkedPdfDownload(
          item,
          'https://example.com/init.pdf',
          applyWatermark: true,
        );

        final inserted = await repository.getDownload('pdf_init');
        expect(inserted?.isWatermarked, isTrue);
        expect(inserted?.fileType, 'PDF');
      },
    );

    test(
      'resumeDownload for paused PDF re-triggers watermark pipeline with preserved watermark intent',
      () async {
        final pausedPdf = DownloadItem(
          id: 'pdf_resumed',
          title: 'Watermarked Doc',
          course: 'Test Course',
          chapter: 'Chapter 1',
          sizeInBytes: 1024,
          downloadedDate: '2026-09-10',
          type: DownloadType.attachment,
          status: DownloadStatus.paused,
          progress: 40,
          fileType: 'PDF',
          taskId: 'task_pdf_resume',
          contentUrl: 'https://example.com/pdf.pdf',
          isWatermarked: true,
        );

        await repository.upsertDownload(pausedPdf);

        await repository.resumeDownload('pdf_resumed');

        expect(service.watermarkedPdfCalls, contains('task_pdf_resume'));
      },
    );
  });
}
