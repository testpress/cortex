import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

class SubjectAnalyticsRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  SubjectAnalyticsRepository({
    required DataSource dataSource,
    required AppDatabase db,
  }) : _dataSource = dataSource,
       _db = db;

  SubjectAnalyticsDto _mapRowToDto(SubjectAnalyticsData row) {
    return SubjectAnalyticsDto(
      id: row.id,
      name: row.name,
      totalQuestionCount: row.totalQuestionCount,
      correctAnswerCount: row.correctAnswerCount,
      incorrectAnswerCount: row.incorrectAnswerCount,
      unansweredCount: row.unansweredCount,
      correctPercentage: row.correctPercentage,
      parentId: row.parentId,
      isLeaf: row.isLeaf,
    );
  }

  Stream<List<SubjectAnalyticsDto>> watchSubjectAnalytics(int? parentId) {
    final query = _db.select(_db.subjectAnalyticsTable);
    if (parentId == null) {
      query.where((t) => t.parentId.isNull());
    } else {
      query.where((t) => t.parentId.equals(parentId));
    }
    return query.watch().map(
      (rows) => rows.map((row) => _mapRowToDto(row)).toList(),
    );
  }

  Stream<SubjectAnalyticsDto?> watchSubjectById(int id) {
    return (_db.select(_db.subjectAnalyticsTable)
          ..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _mapRowToDto(row));
  }

  Future<void> refreshSubjectAnalytics() async {
    try {
      final freshData = await _dataSource.getAnalyticsData();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.subjectAnalyticsTable,
          freshData
              .map(
                (dto) => SubjectAnalyticsTableCompanion(
                  id: Value(dto.id),
                  name: Value(dto.name),
                  totalQuestionCount: Value(dto.totalQuestionCount),
                  correctAnswerCount: Value(dto.correctAnswerCount),
                  incorrectAnswerCount: Value(dto.incorrectAnswerCount),
                  unansweredCount: Value(dto.unansweredCount),
                  correctPercentage: Value(dto.correctPercentage),
                  parentId: Value(dto.parentId),
                  isLeaf: Value(dto.isLeaf),
                ),
              )
              .toList(),
        );
      });
    } catch (e) {
      debugPrint(
        'SubjectAnalyticsRepository: Failed to refresh subject analytics: $e',
      );
    }
  }
}
