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
      (rows) => rows.map((r) {
        final statusVal = switch (r.status) {
          'live' => LiveClassStatus.live,
          'completed' => LiveClassStatus.completed,
          'cancelled' => LiveClassStatus.cancelled,
          _ => LiveClassStatus.upcoming,
        };
        return LiveClassDto(
          id: r.id,
          subject: r.subject,
          topic: r.topic,
          time: r.time,
          faculty: r.faculty,
          status: statusVal,
        );
      }).toList(),
    );
  }

  /// Sync live classes page from API and merge/upsert into local Drift database cache.
  Future<PaginatedResponseDto<LiveClassDto>> fetchLiveClasses({
    int page = 1,
    String? status,
    bool clearCache = false,
  }) async {
    final response = await _source.getLiveClasses(
      page: page,
      status: status,
      ordering: '-start',
    );

    final companions = response.results.map((dto) {
      final statusStr = switch (dto.status) {
        LiveClassStatus.live => 'live',
        LiveClassStatus.completed => 'completed',
        LiveClassStatus.cancelled => 'cancelled',
        _ => 'upcoming',
      };
      return LiveClassesTableCompanion.insert(
        id: dto.id,
        subject: dto.subject,
        topic: dto.topic,
        time: dto.time,
        faculty: dto.faculty,
        status: statusStr,
      );
    }).toList();

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
}
