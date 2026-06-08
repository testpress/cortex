import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:core/data/data.dart';

part 'subject_analytics_repository.g.dart';

class SubjectAnalyticsRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  SubjectAnalyticsRepository({
    required DataSource dataSource,
    required AppDatabase db,
  })  : _dataSource = dataSource,
        _db = db;

  SubjectAnalyticsDto _mapRowToDto(SubjectAnalyticsData row) {
    return SubjectAnalyticsDto(
      id: row.id,
      name: row.name,
      total: row.total,
      correct: row.correct,
      incorrect: row.incorrect,
      unanswered: row.unanswered,
      correctPercentage: row.correctPercentage,
      parent: row.parent,
      leaf: row.leaf,
    );
  }

  Stream<List<SubjectAnalyticsDto>> watchSubjectAnalytics(int? parentId) {
    final query = _db.select(_db.subjectAnalyticsTable);
    if (parentId == null) {
      query.where((t) => t.parent.isNull());
    } else {
      query.where((t) => t.parent.equals(parentId));
    }
    return query.watch().map((rows) => rows.map((row) => _mapRowToDto(row)).toList());
  }

  Stream<SubjectAnalyticsDto?> watchSubjectById(int id) {
    return (_db.select(_db.subjectAnalyticsTable)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : _mapRowToDto(row));
  }

  Future<void> refreshSubjectAnalytics(String analyticsUrl) async {
    try {
      final freshData = await _dataSource.getAnalyticsData(analyticsUrl);
      
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.subjectAnalyticsTable,
          freshData.map((dto) => SubjectAnalyticsTableCompanion(
            id: Value(dto.id),
            name: Value(dto.name),
            total: Value(dto.total),
            correct: Value(dto.correct),
            incorrect: Value(dto.incorrect),
            unanswered: Value(dto.unanswered),
            correctPercentage: Value(dto.correctPercentage),
            parent: Value(dto.parent),
            leaf: Value(dto.leaf),
            analyticsUrl: Value(analyticsUrl),
          )).toList(),
        );
      });
    } catch (e) {
      debugPrint('SubjectAnalyticsRepository: Failed to refresh subject analytics: $e');
    }
  }
}

@Riverpod(keepAlive: true)
Future<SubjectAnalyticsRepository> subjectAnalyticsRepository(SubjectAnalyticsRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return SubjectAnalyticsRepository(
    dataSource: dataSource,
    db: db,
  );
}
