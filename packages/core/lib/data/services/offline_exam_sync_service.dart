import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../sources/data_source.dart';
import '../models/answer_dto.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../../network/dio_provider.dart';
import '../sources/http_data_source.dart';

part 'offline_exam_sync_service.g.dart';

class OfflineExamSyncService {
  final AppDatabase _db;
  final DataSource _api;

  OfflineExamSyncService(this._db, this._api);

  /// Background sync executor. Iterates pending exams, constructs payloads,
  /// pushes to backend, and marks them as synced by deleting them.
  Future<void> syncPendingExams() async {
    final pendingDownloads = await _db.getPendingSyncDownloads();
    for (final download in pendingDownloads) {
      try {
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
            } catch (e) {
              // Ignore failure
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

        // Mark as successfully synced in local DB by deleting the download and answers
        await _db.deleteDownload(download.id);
      } catch (e) {
        debugPrint("Sync failed for offline exam ${download.id}: $e");
        if (e is DioException) {
          final statusCode = e.response?.statusCode;
          // Permanent failure handling: 4xx errors (except 401 Auth, 408 Timeout, 429 Rate Limit)
          if (statusCode != null && statusCode >= 400 && statusCode < 500) {
            if (statusCode != 401 && statusCode != 408 && statusCode != 429) {
              debugPrint(
                "Permanent failure ($statusCode). Dropping sync for exam ${download.id}.",
              );
              await _db.deleteDownload(download.id);
            }
          }
        }
        // Other failures (like 5xx, or network issues) will remain in queue and retry next time
      }
    }
  }
}

@Riverpod(keepAlive: true)
Future<OfflineExamSyncService> offlineExamSyncService(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dio = ref.watch(dioProvider);
  final dataSource = HttpDataSource(dio: dio);
  return OfflineExamSyncService(db, dataSource);
}
