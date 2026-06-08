import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../../utils/time_formatter.dart';
import '../db/tables/dashboard_tables.dart';

/// Lightweight DTO for a single item in the dashboard feed.
class DashboardContentDto {
  final String id;
  final String title;
  final String? chapterId;
  final String? chapterTitle;
  final DashboardContentType contentType;
  final DashboardSectionType? sectionType;
  final String? totalDuration;
  final String? remainingDuration;
  final String? coverImage;
  final double? progress;

  const DashboardContentDto({
    required this.id,
    required this.title,
    this.chapterId,
    this.chapterTitle,
    required this.contentType,
    this.sectionType,
    this.totalDuration,
    this.remainingDuration,
    this.coverImage,
    this.progress,
  });

  factory DashboardContentDto.fromJson(
    Map<String, dynamic> json, {
    Map<String, String>? chapterMap,
    DashboardSectionType? sectionType,
  }) {
    final chapterId =
        json['chapter_id']?.toString() ?? json['chapter']?.toString();
    return DashboardContentDto(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      chapterId: chapterId,
      chapterTitle: chapterMap?[chapterId],
      contentType: _mapContentType(
        (json['content_type'] ?? json['type'] ?? 'unknown').toString(),
      ),
      totalDuration: json['total_duration'] ?? json['duration'],
      remainingDuration: json['remaining_duration'],
      coverImage: json['cover_image'] ?? json['image'],
      progress: (json['progress'] as num?)?.toDouble(),
      sectionType: sectionType,
    );
  }

  static DashboardContentType _mapContentType(String type) {
    final t = type.toLowerCase();
    if (t.contains('video')) return DashboardContentType.video;
    if (t.contains('pdf')) return DashboardContentType.pdf;
    if (t.contains('notes') || t.contains('html')) {
      return DashboardContentType.notes;
    }
    if (t.contains('test') || t.contains('exam')) {
      return DashboardContentType.test;
    }
    if (t.contains('assessment') || t.contains('quiz')) {
      return DashboardContentType.assessment;
    }
    if (t.contains('live')) return DashboardContentType.liveStream;
    if (t.contains('attachment')) return DashboardContentType.attachment;
    if (t.contains('embed')) return DashboardContentType.embedContent;

    return DashboardContentType.unknown;
  }
}

/// Container for the dashboard contents list.
class DashboardContentsDto {
  final List<DashboardContentDto> items;

  const DashboardContentsDto({required this.items});

  factory DashboardContentsDto.fromJson(
    Map<String, dynamic> json, {
    required DashboardSectionType sectionType,
  }) {
    final results = json['results'] ?? json;

    switch (sectionType) {
      case DashboardSectionType.resumeLearning:
        return _parseResumeLearning(results);
      case DashboardSectionType.recentlyCompleted:
        return _parseRecentlyCompleted(results);
      case DashboardSectionType.whatsNew:
        return _parseWhatsNewFeed(results, sectionType);
    }
  }

  static DashboardContentsDto _parseRecentlyCompleted(
    Map<String, dynamic> results,
  ) {
    final chaptersList = (results['chapters'] ?? []) as List;
    final chapterMap = {
      for (var chapter in chaptersList)
        chapter['id'].toString(): chapter['name']?.toString() ?? '',
    };

    final contentsList = (results['chapter_contents'] ?? []) as List;
    final items = contentsList.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      map['progress'] = 100.0; // Mark as completed
      return DashboardContentDto.fromJson(
        map,
        chapterMap: chapterMap,
        sectionType: DashboardSectionType.recentlyCompleted,
      );
    }).toList();

    return DashboardContentsDto(items: items);
  }

  static DashboardContentsDto _parseWhatsNewFeed(
    Map<String, dynamic> results,
    DashboardSectionType sectionType,
  ) {
    final chaptersList = (results['chapters'] ?? []) as List;
    final chapterMap = {
      for (var chapter in chaptersList)
        chapter['id'].toString(): chapter['name']?.toString() ?? '',
    };

    final contentsList =
        (results['chapter_contents'] ?? results['contents'] ?? []) as List;
    final items = contentsList
        .map(
          (e) => DashboardContentDto.fromJson(
            e as Map<String, dynamic>,
            chapterMap: chapterMap,
            sectionType: sectionType,
          ),
        )
        .toList();

    return DashboardContentsDto(items: items);
  }

  static DashboardContentsDto _parseResumeLearning(
    Map<String, dynamic> results,
  ) {
    final chaptersList = (results['chapters'] ?? []) as List;
    final chapterMap = {
      for (var chapter in chaptersList)
        chapter['id'].toString(): chapter['name']?.toString() ?? '',
    };

    final contentMap = {
      for (var c in (results['chapter_contents'] ?? []))
        c['id'].toString(): Map<String, dynamic>.from(c as Map),
    };

    final videoProgressMap = <String, double>{};
    final videoDurationMap = <String, String>{};
    final videoRemainingDurationMap = <String, String>{};
    for (var v in (results['user_videos'] ?? [])) {
      final totalSeconds =
          (v['video_content']?['duration'] as num?)?.toDouble() ??
          (v['duration'] as num?)?.toDouble() ??
          0.0;
      final lastPosition =
          double.tryParse(v['last_position']?.toString() ?? '0') ?? 0.0;
      final watched =
          double.tryParse(v['watched_duration']?.toString() ?? '0') ?? 0.0;
      final effectiveProgress = math.max(lastPosition, watched);

      if (totalSeconds > 0) {
        final videoEntryId = v['id'].toString();
        final calculatedProgress = (effectiveProgress / totalSeconds) * 100;
        videoProgressMap[videoEntryId] = calculatedProgress.clamp(0.0, 100.0);
        videoDurationMap[videoEntryId] =
            TimeFormatter.formatDuration(totalSeconds.toInt().toString()) ?? '';

        final remainingSeconds = math.max(
          0,
          (totalSeconds - effectiveProgress).toInt(),
        );
        videoRemainingDurationMap[videoEntryId] =
            TimeFormatter.formatDuration(remainingSeconds.toString()) ?? '';
      }
    }

    final assessmentMap = {
      for (var a in (results['assessments'] ?? [])) a['id'].toString(): a,
    };

    final attempts = (results['chapter_content_attempts'] ?? []) as List;
    final items = <DashboardContentDto>[];
    final seenContentIds = <String>{};

    for (var attempt in attempts) {
      final contentId = attempt['chapter_content_id']?.toString();
      if (contentId == null || seenContentIds.contains(contentId)) continue;

      final map = contentMap[contentId];
      if (map == null) continue;

      final type = (map['content_type'] ?? '').toString().toLowerCase();
      double? progress;
      String? totalDuration;
      String? remainingDuration;

      if (type == 'video') {
        final userVideoId = attempt['user_video_id']?.toString();
        if (userVideoId != null && videoProgressMap.containsKey(userVideoId)) {
          progress = videoProgressMap[userVideoId];
          totalDuration = videoDurationMap[userVideoId];
          remainingDuration = videoRemainingDurationMap[userVideoId];
        } else {
          continue;
        }
      } else if (type == 'exam' || type == 'test') {
        final assessmentId = attempt['assessment_id']?.toString();
        if (assessmentId != null && assessmentMap.containsKey(assessmentId)) {
          progress = 0.0;
          final assessment = assessmentMap[assessmentId];
          final exam = assessment?['exam'];
          final remainingTime = assessment?['remaining_time']?.toString();
          totalDuration = TimeFormatter.formatDuration(
            exam?['duration']?.toString(),
          );
          remainingDuration = TimeFormatter.formatDuration(remainingTime);
        } else {
          continue;
        }
      } else {
        continue;
      }

      seenContentIds.add(contentId);
      map['progress'] = progress;
      if (totalDuration != null) map['total_duration'] = totalDuration;
      if (remainingDuration != null) {
        map['remaining_duration'] = remainingDuration;
      }

      items.add(
        DashboardContentDto.fromJson(
          map,
          chapterMap: chapterMap,
          sectionType: DashboardSectionType.resumeLearning,
        ),
      );
    }

    return DashboardContentsDto(items: items);
  }
}

class DashboardBannerDto {
  final String id;
  final String imageUrl;
  final String? title;
  final String? link;
  final int? bgColor; // ARGB
  final int? textColor; // ARGB
  final String? description;
  final String? tag;

  const DashboardBannerDto({
    required this.id,
    required this.imageUrl,
    this.title,
    this.link,
    this.bgColor,
    this.textColor,
    this.description,
    this.tag,
  });

  static DashboardBannerDto? fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final imageUrl = json['image'] as String?;

    if (id == null || imageUrl == null) return null;

    return DashboardBannerDto(
      id: id,
      imageUrl: imageUrl,
      title: json['title'] as String?,
      link: json['url'] as String?,
      description: json['description'] as String?,
      bgColor: json['bgColor'] as int?,
      textColor: json['textColor'] as int?,
      tag: json['tag'] as String?,
    );
  }
}

enum LeaderboardTimeline { allTime, thisWeek, thisMonth }

extension LeaderboardTimelineExtension on LeaderboardTimeline {
  String? get timelineQuery {
    switch (this) {
      case LeaderboardTimeline.allTime:
        return null;
      case LeaderboardTimeline.thisWeek:
        return 'this_week';
      case LeaderboardTimeline.thisMonth:
        return 'this_month';
    }
  }
}

@immutable
class LearnerDto {
  final String id;
  final int rank;
  final String name;
  final String avatar;
  final double points;
  final int coursesCompleted;
  final int streakDays;
  final bool isCurrentUser;

  const LearnerDto({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.coursesCompleted,
    required this.streakDays,
    this.isCurrentUser = false,
  });

  factory LearnerDto.fromJson(Map<String, dynamic> json, int rank) {
    return LearnerDto(
      id: json['id']?.toString() ?? '',
      rank: rank,
      name: json['user']?['display_name'] ?? '',
      avatar: json['user']?['medium_image'] ?? '',
      points: double.tryParse(json['trophies_count']?.toString() ?? '0') ?? 0.0,
      coursesCompleted: json['courses_completed']?.toInt() ?? 0,
      streakDays: json['streak_days']?.toInt() ?? 0,
    );
  }

  LearnerDto copyWith({
    String? id,
    int? rank,
    String? name,
    String? avatar,
    double? points,
    int? coursesCompleted,
    int? streakDays,
    bool? isCurrentUser,
  }) {
    return LearnerDto(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      streakDays: streakDays ?? this.streakDays,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}
