import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../models/paginated_response_dto.dart';
import '../models/live_class_dto.dart';
import '../sources/data_source.dart';

/// Repository for managing live class sessions synchronization and local caching.
class LiveClassesRepository {
  final AppDatabase _db;
  final DataSource _source;

  LiveClassesRepository(this._db, this._source);

  /// Watch all cached live classes from the local database.
  Stream<List<LiveClassDto>> watchLiveClasses() {
    return _db.watchAllLiveClasses().map(
      (rows) => rows.map(_rowToDto).toList(),
    );
  }

  /// Sync live classes page from API and merge/upsert into local Drift database cache.
  Future<PaginatedResponseDto<LiveClassDto>> fetchLiveClasses({
    int page = 1,
    String? status,
    String? ordering = '-start',
    bool clearCache = false,
    String? listRangeFrom,
    String? listRangeTo,
  }) async {
    final response = await _source.getLiveClasses(
      page: page,
      status: status,
      ordering: ordering,
      listRangeFrom: listRangeFrom,
      listRangeTo: listRangeTo,
    );

    final companions = response.results.map(_dtoToCompanion).toList();

    if (clearCache && page == 1) {
      // Clear all items before writing page 1 to invalidate stale local data
      await _db.transaction(() async {
        await _db.delete(_db.liveClassesTable).go();
        await _db.upsertLiveClasses(companions);
      });
    } else {
      await _db.upsertLiveClasses(companions);
    }

    return response;
  }

  Future<List<LiveClassDto>> getTodayLiveClasses({
    String? date,
    String? status,
  }) async {
    final targetDate = date ?? _formatDate(DateTime.now());
    try {
      final response = await _source.getLiveClasses(
        page: 1,
        status: status,
        ordering: 'start',
        listRangeFrom: targetDate,
        listRangeTo: targetDate,
      );

      final companions = response.results.map(_dtoToCompanion).toList();
      if (companions.isNotEmpty) {
        await _db.upsertLiveClasses(companions);
      }

      return response.results;
    } catch (_) {
      // Fallback to local DB cache when offline
      final cachedRows = await _db.select(_db.liveClassesTable).get();
      final cached = cachedRows.map(_rowToDto).toList();

      return cached.where((c) {
        final start = c.startDateTime;
        if (start == null) return false;
        final isDateMatch = _formatDate(start.toLocal()) == targetDate;
        if (!isDateMatch) return false;

        if (status != null && status.isNotEmpty) {
          final expectedStatus = switch (status) {
            'live' => LiveClassStatus.live,
            'completed' => LiveClassStatus.completed,
            'cancelled' => LiveClassStatus.cancelled,
            _ => LiveClassStatus.upcoming,
          };
          return c.status == expectedStatus;
        }

        return true;
      }).toList();
    }
  }

  static LiveClassDto _rowToDto(LiveClassesTableData r) {
    final statusVal = switch (r.status) {
      'live' => LiveClassStatus.live,
      'completed' => LiveClassStatus.completed,
      'cancelled' => LiveClassStatus.cancelled,
      _ => LiveClassStatus.upcoming,
    };
    return LiveClassDto(
      id: r.id,
      title: r.topic,
      topic: r.topic,
      courseName: r.subject,
      subject: r.subject,
      start: r.time,
      time: r.time,
      faculty: r.faculty.isNotEmpty ? r.faculty : null,
      provider: r.faculty.isNotEmpty ? r.faculty : null,
      status: statusVal,
      durationMinutes: r.durationMinutes,
    );
  }

  static LiveClassesTableCompanion _dtoToCompanion(LiveClassDto dto) {
    final statusStr = switch (dto.status) {
      LiveClassStatus.live => 'live',
      LiveClassStatus.completed => 'completed',
      LiveClassStatus.cancelled => 'cancelled',
      _ => 'upcoming',
    };
    return LiveClassesTableCompanion.insert(
      id: dto.id,
      subject: dto.courseName.isNotEmpty ? dto.courseName : dto.subject,
      topic: dto.title.isNotEmpty ? dto.title : dto.topic,
      time: dto.start.isNotEmpty ? dto.start : dto.time,
      faculty: dto.faculty ?? dto.provider ?? '',
      status: statusStr,
      durationMinutes: Value(dto.durationMinutes),
    );
  }

  static String _formatDate(DateTime dt) {
    final year = dt.year.toString().padLeft(4, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
