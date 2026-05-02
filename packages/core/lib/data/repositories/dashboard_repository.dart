import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../data.dart';

part 'dashboard_repository.g.dart';

class DashboardRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  DashboardRepository({
    required DataSource dataSource,
    required AppDatabase db,
  })  : _dataSource = dataSource,
        _db = db;

  Stream<List<DashboardBannerDto>> watchHeroBanners() async* {
    // 1. Trigger background refresh from network
    // We don't await this because we want to yield cached data immediately
    _refreshBanners();

    // 2. Emit data from DB (will update when _refreshBanners completes)
    yield* _db.watchDashboardBanners().map((rows) {
      return rows.map((row) => DashboardBannerDto(
        id: row.id,
        imageUrl: row.imageUrl,
        title: row.title,
        link: row.link,
        description: row.description,
        bgColor: row.bgColor,
        textColor: row.textColor,
        tag: row.tag,
      )).toList();
    });
  }

  Future<void> _refreshBanners() async {
    try {
      final freshBanners = await _dataSource.getDashboardBanners();
      await _db.upsertDashboardBanners(freshBanners.map((dto) => DashboardBannersTableCompanion(
        id: Value(dto.id),
        imageUrl: Value(dto.imageUrl),
        title: Value(dto.title),
        link: Value(dto.link),
        description: Value(dto.description),
        bgColor: Value(dto.bgColor),
        textColor: Value(dto.textColor),
        tag: Value(dto.tag),
      )).toList());
    } catch (e) {
      debugPrint('DEBUG: Failed to fetch dashboard banners: $e');
    }
  }

  Stream<List<LearnerDto>> watchLearners() async* {
    _refreshLearners();

    yield* _db.watchLearners().map((rows) {
      return rows.map((row) => LearnerDto(
        id: row.id,
        rank: row.rank,
        name: row.name,
        avatar: row.avatar,
        points: row.points,
        coursesCompleted: row.coursesCompleted,
        streakDays: row.streakDays,
      )).toList();
    });
  }

  Future<void> _refreshLearners() async {
    try {
      final freshLearners = await _dataSource.getLearners();
      await _db.wipeAndInsertLearners(freshLearners.map((dto) => LearnersTableCompanion(
        id: Value(dto.id),
        rank: Value(dto.rank),
        name: Value(dto.name),
        avatar: Value(dto.avatar),
        points: Value(dto.points),
        coursesCompleted: Value(dto.coursesCompleted),
        streakDays: Value(dto.streakDays),
      )).toList());
    } catch (e) {
      debugPrint('DEBUG: Failed to fetch top learners: $e');
    }
  }
}

@riverpod
Future<DashboardRepository> dashboardRepository(DashboardRepositoryRef ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return DashboardRepository(
    dataSource: dataSource,
    db: db,
  );
}
