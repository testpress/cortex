import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../data.dart';

part 'dashboard_repository.g.dart';

class DashboardRepository {
  final DataSource _dataSource;
  final AppDatabase _db;

  DashboardRepository({required DataSource dataSource, required AppDatabase db})
    : _dataSource = dataSource,
      _db = db;

  Stream<List<DashboardBannerDto>> watchHeroBanners() async* {
    // Emit data from DB (updated by explicit sync calls)
    yield* _db.watchDashboardBanners().map((rows) {
      return rows
          .map(
            (row) => DashboardBannerDto(
              id: row.id,
              imageUrl: row.imageUrl,
              title: row.title,
              link: row.link,
              description: row.description,
              bgColor: row.bgColor,
              textColor: row.textColor,
              tag: row.tag,
            ),
          )
          .toList();
    });
  }

  Future<void> refreshDashboard() async {
    try {
      final freshDashboard = await _dataSource.getDashboard();

      await _db.transaction(() async {
        // 1. Refresh Banners
        await _db.upsertDashboardBanners(
          freshDashboard.bannerAds
              .map(
                (dto) => DashboardBannersTableCompanion(
                  id: Value(dto.id),
                  imageUrl: Value(dto.imageUrl),
                  title: Value(dto.title),
                  link: Value(dto.link),
                  description: Value(dto.description),
                  bgColor: Value(dto.bgColor),
                  textColor: Value(dto.textColor),
                  tag: Value(dto.tag),
                ),
              )
              .toList(),
        );

        // 2. Refresh What's New
        final whatsNewChapters = {
          for (var c in freshDashboard.whatsNew.chapters) c.id: c.name,
        };
        final whatsNewCompanions = freshDashboard.whatsNew.chapterContents
            .asMap()
            .entries
            .map((entry) {
              final index = entry.key;
              final item = entry.value;
              return DashboardContentData(
                lessonId: item.id,
                sectionType: DashboardSectionType.whatsNew,
                lessonType: DashboardContentDto.mapContentType(
                  item.contentType,
                ),
                title: item.title,
                displayOrder: index,
                chapterId: item.chapterId,
                chapterTitle: whatsNewChapters[item.chapterId],
                coverImage: item.coverImageMedium,
              ).toCompanion(true);
            })
            .toList();
        await _db.wipeAndInsertDashboardSection(
          DashboardSectionType.whatsNew,
          whatsNewCompanions,
        );

        // 3. Refresh Resume Learning
        final resumeChapters = {
          for (var c in freshDashboard.resumeLearning.chapters) c.id: c.name,
        };
        final resumeCourses = {
          for (var c in freshDashboard.resumeLearning.courses) c.id: c.title,
        };
        final resumeContents = {
          for (var c in freshDashboard.resumeLearning.chapterContents) c.id: c,
        };
        final resumeVideos = {
          for (var v in freshDashboard.resumeLearning.userVideos) v.id: v,
        };

        final resumeCompanions = <DashboardContentsTableCompanion>[];
        var displayOrder = 0;
        for (final attempt in freshDashboard.resumeLearning.contentAttempts) {
          final contentId = attempt.chapterContentId;
          final cc = resumeContents[contentId];
          if (cc == null) continue;

          final type = attempt.contentType.toLowerCase();
          double? progress;
          String? totalDuration;
          String? remainingDuration;

          // Note: Only videos and exams/tests have resumable progress (like last_position or remaining_time).
          // Other content types (PDF, notes, attachments) are skipped in the "Resume Learning" feed,
          // matching the behavior of the legacy flat-feed parsing.
          if (type == 'video') {
            final userVideoId = attempt.userVideoId;
            final uv = resumeVideos[userVideoId];
            if (uv != null) {
              progress = uv.watchedPercentage;
              totalDuration = uv.videoContent?.duration;
              remainingDuration = uv.remainingDuration;
            } else {
              continue;
            }
          } else if (type == 'exam' || type == 'test' || type == 'assessment') {
            progress = 0.0;
            remainingDuration = attempt.remainingTime;
          } else {
            continue;
          }

          resumeCompanions.add(
            DashboardContentData(
              lessonId: contentId,
              sectionType: DashboardSectionType.resumeLearning,
              lessonType: DashboardContentDto.mapContentType(cc.contentType),
              title: cc.title,
              displayOrder: displayOrder++,
              chapterId: cc.chapterId,
              chapterTitle:
                  resumeChapters[cc.chapterId] ??
                  resumeCourses[attempt.courseId],
              totalDuration: totalDuration,
              remainingDuration: remainingDuration,
              coverImage: cc.coverImageMedium,
              progress: progress,
            ).toCompanion(true),
          );
        }
        await _db.wipeAndInsertDashboardSection(
          DashboardSectionType.resumeLearning,
          resumeCompanions,
        );

        // 4. Refresh Completed Learning
        final completedChapters = {
          for (var c in freshDashboard.completedLearning.chapters) c.id: c.name,
        };
        final completedCourses = {
          for (var c in freshDashboard.completedLearning.courses) c.id: c.title,
        };
        final completedContents = {
          for (var c in freshDashboard.completedLearning.chapterContents)
            c.id: c,
        };
        final completedVideos = {
          for (var v in freshDashboard.completedLearning.userVideos) v.id: v,
        };

        final completedCompanions = <DashboardContentsTableCompanion>[];
        displayOrder = 0;
        for (final attempt
            in freshDashboard.completedLearning.contentAttempts) {
          final contentId = attempt.chapterContentId;
          final cc = completedContents[contentId];
          if (cc == null) continue;

          final type = attempt.contentType.toLowerCase();
          double? progress;
          String? totalDuration;
          String? remainingDuration;

          if (type == 'video') {
            final userVideoId = attempt.userVideoId;
            final uv = completedVideos[userVideoId];
            if (uv != null) {
              progress = uv.watchedPercentage;
              totalDuration = uv.videoContent?.duration;
              remainingDuration = uv.remainingDuration;
            } else {
              continue;
            }
          } else if (type == 'exam' || type == 'test' || type == 'assessment') {
            progress = 100.0;
            remainingDuration = attempt.remainingTime;
          } else {
            // Other types like PDF/notes/attachments do not have attempt-based partial progress
            // but can be marked as fully completed.
            progress = 100.0;
          }

          completedCompanions.add(
            DashboardContentData(
              lessonId: contentId,
              sectionType: DashboardSectionType.completedLearning,
              lessonType: DashboardContentDto.mapContentType(cc.contentType),
              title: cc.title,
              displayOrder: displayOrder++,
              chapterId: cc.chapterId,
              chapterTitle:
                  completedChapters[cc.chapterId] ??
                  completedCourses[attempt.courseId],
              totalDuration: totalDuration,
              remainingDuration: remainingDuration,
              coverImage: cc.coverImageMedium,
              progress: progress,
            ).toCompanion(true),
          );
        }
        await _db.wipeAndInsertDashboardSection(
          DashboardSectionType.completedLearning,
          completedCompanions,
        );

        // 5. Refresh Leaderboard (reuses weekly companion mapper from LeaderboardRepository)
        final leaderboardCompanions = freshDashboard.leaderboard
            .map((dto) => dto.toWeeklyCompanion(1))
            .toList();

        await _db.saveLeaderboardPage(
          timeline: LeaderboardTimeline.thisWeek,
          page: 1,
          rows: leaderboardCompanions,
        );
      });
    } catch (e) {
      debugPrint('Failed to refresh unified dashboard: $e');
    }
  }

  /// Watch the "What's New" feed.
  Stream<List<DashboardContentDto>> watchWhatsNewFeed() async* {
    yield* _db.watchDashboardSection(DashboardSectionType.whatsNew).map((rows) {
      return rows
          .map(
            (data) => DashboardContentDto(
              id: data.lessonId,
              title: data.title,
              chapterId: data.chapterId,
              chapterTitle: data.chapterTitle,
              contentType: data.lessonType,
              totalDuration: data.totalDuration,
              remainingDuration: data.remainingDuration,
              coverImage: data.coverImage,
              progress: data.progress,
              sectionType: data.sectionType,
            ),
          )
          .toList();
    });
  }

  /// Watch the "Resume Learning" feed.
  Stream<List<DashboardContentDto>> watchResumeLearningFeed() async* {
    yield* _db.watchDashboardSection(DashboardSectionType.resumeLearning).map((
      rows,
    ) {
      return rows
          .map(
            (data) => DashboardContentDto(
              id: data.lessonId,
              title: data.title,
              chapterId: data.chapterId,
              chapterTitle: data.chapterTitle,
              contentType: data.lessonType,
              totalDuration: data.totalDuration,
              remainingDuration: data.remainingDuration,
              coverImage: data.coverImage,
              progress: data.progress,
              sectionType: data.sectionType,
            ),
          )
          .toList();
    });
  }

  /// Watch the "Recently Completed" feed (renamed to Completed Learning).
  Stream<List<DashboardContentDto>> watchRecentlyCompletedFeed() async* {
    yield* _db
        .watchDashboardSection(DashboardSectionType.completedLearning)
        .map((rows) {
          return rows
              .map(
                (data) => DashboardContentDto(
                  id: data.lessonId,
                  title: data.title,
                  chapterId: data.chapterId,
                  chapterTitle: data.chapterTitle,
                  contentType: data.lessonType,
                  totalDuration: data.totalDuration,
                  remainingDuration: data.remainingDuration,
                  coverImage: data.coverImage,
                  progress: data.progress,
                  sectionType: data.sectionType,
                ),
              )
              .toList();
        });
  }
}

@riverpod
Future<DashboardRepository> dashboardRepository(
  DashboardRepositoryRef ref,
) async {
  final db = await ref.watch(appDatabaseProvider.future);
  final dataSource = ref.watch(dataSourceProvider);
  return DashboardRepository(dataSource: dataSource, db: db);
}
