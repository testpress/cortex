import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../sources/data_source.dart';
import '../models/answer_dto.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../../network/dio_provider.dart';
import '../sources/http_data_source.dart';
import 'sentry_service.dart';

part 'offline_exam_sync_service.g.dart';

class OfflineExamSyncService {
  final AppDatabase _db;
  final DataSource _api;
  final SentryService _sentryService;

  OfflineExamSyncService(this._db, this._api, this._sentryService);

  /// Background sync executor. Iterates pending exams, constructs payloads,
  /// pushes to backend, and marks them as synced by deleting them.
  Future<void> syncPendingExams() async {
    final pendingDownloads = await _db.getPendingSyncDownloads();
    for (final download in pendingDownloads) {
      try {
        // Set status to SYNCING before we start the network call
        await _db.upsertDownload(
          download
              .toCompanion(false)
              .copyWith(status: const drift.Value('SYNCING')),
        );

        final items = await _db.getAnswersForDownload(download.id);

        final List<Map<String, dynamic>> offlineAnswers = [];

        for (final item in items) {
          List<dynamic> selectedOptions = [];
          if (item.selectedChoices != null &&
              item.selectedChoices!.isNotEmpty) {
            try {
              final decoded = jsonDecode(item.selectedChoices!);
              if (decoded is List) {
                selectedOptions = decoded;
              }
            } catch (e, stackTrace) {
              _sentryService.captureException(
                e,
                stackTrace: stackTrace,
                level: AppErrorLevel.warning,
              );
            }
          }

          final answerPayload = AnswerDto(
            questionId: item.questionId,
            selectedOptions: selectedOptions,
            review: item.review,
            shortText: item.shortAnswer,
          );

          final jsonAns = answerPayload.toJson();
          jsonAns['question_id'] = item.questionId;
          offlineAnswers.add(jsonAns);
        }

        final payload = {
          "offline_attempt": {
            "started_on":
                (download.startedAt ?? download.completedAt ?? DateTime.now())
                    .toUtc()
                    .toIso8601String(),
            "completed_on": download.completedAt?.toUtc().toIso8601String(),
          },
          "offline_answers": offlineAnswers,
        };

        await _api.submitOfflineExamAnswers(download.examId, payload);

        // Mark as successfully synced — retain the row so the user can
        // see the "Submitted" state in the downloads list.
        await _db.upsertDownload(
          download
              .toCompanion(false)
              .copyWith(
                status: const drift.Value('SYNCED'),
                syncedAt: drift.Value(DateTime.now().toUtc()),
              ),
        );
      } catch (e, stackTrace) {
        debugPrint("Sync failed for offline exam ${download.id}: $e");
        _sentryService.captureException(
          e,
          stackTrace: stackTrace,
          level: AppErrorLevel.error,
        );

        bool isPermanentFailure = false;
        if (e is DioException) {
          final statusCode = e.response?.statusCode;
          // Permanent failure handling: 4xx errors (except 401 Auth, 408 Timeout, 429 Rate Limit)
          if (statusCode != null && statusCode >= 400 && statusCode < 500) {
            if (statusCode != 401 && statusCode != 408 && statusCode != 429) {
              isPermanentFailure = true;
            }
          }
        }

        if (isPermanentFailure) {
          debugPrint(
            "Permanent failure. Dropping sync for exam ${download.id}.",
          );
          await _db.deleteDownload(download.id);
        } else {
          // Revert back to PENDING_SYNC for retry on next network connection
          await _db.upsertDownload(
            download
                .toCompanion(false)
                .copyWith(status: const drift.Value('PENDING_SYNC')),
          );
        }
      }
    }
  }
}

@Riverpod(keepAlive: true)
Future<OfflineExamSyncService> offlineExamSyncService(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dio = ref.watch(dioProvider);
  final dataSource = HttpDataSource(dio: dio);
  final sentryService = ref.watch(sentryServiceProvider);
  return OfflineExamSyncService(db, dataSource, sentryService);
}
