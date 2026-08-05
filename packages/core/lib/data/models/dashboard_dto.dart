import 'package:flutter/foundation.dart';
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
      contentType: mapContentType(
        (json['content_type'] ?? json['type'] ?? 'unknown').toString(),
      ),
      totalDuration: json['total_duration'] ?? json['duration'],
      remainingDuration: json['remaining_duration'],
      coverImage: json['cover_image'] ?? json['image'],
      progress: (json['progress'] as num?)?.toDouble(),
      sectionType: sectionType,
    );
  }

  static DashboardContentType mapContentType(String type) {
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
  final bool isCurrentUser;

  const LearnerDto({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    this.isCurrentUser = false,
  });

  factory LearnerDto.fromJson(Map<String, dynamic> json, int rank) {
    return LearnerDto(
      id: json['id']?.toString() ?? '',
      rank: rank,
      name: json['user']?['display_name'] ?? '',
      avatar: json['user']?['medium_image'] ?? '',
      points: double.tryParse(json['trophies_count']?.toString() ?? '0') ?? 0.0,
    );
  }

  LearnerDto copyWith({
    String? id,
    int? rank,
    String? name,
    String? avatar,
    double? points,
    bool? isCurrentUser,
  }) {
    return LearnerDto(
      id: id ?? this.id,
      rank: rank ?? this.rank,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      points: points ?? this.points,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
    );
  }
}

class DashboardResponseDto {
  final List<DashboardBannerDto> bannerAds;
  final ResumeLearningDto resumeLearning;
  final WhatsNewDto whatsNew;
  final CompletedLearningDto completedLearning;
  final List<LearnerDto> leaderboard;

  const DashboardResponseDto({
    required this.bannerAds,
    required this.resumeLearning,
    required this.whatsNew,
    required this.completedLearning,
    required this.leaderboard,
  });

  factory DashboardResponseDto.fromJson(Map<String, dynamic> json) {
    final bannerAdsList =
        (json['banner_ads'] as List?)
            ?.map((e) => DashboardBannerDto.fromJson(e as Map<String, dynamic>))
            .whereType<DashboardBannerDto>()
            .toList() ??
        [];

    final leaderboardList =
        (json['leaderboard'] as List?)
            ?.asMap()
            .entries
            .map(
              (entry) => LearnerDto.fromJson(
                entry.value as Map<String, dynamic>,
                entry.key + 1,
              ),
            )
            .toList() ??
        [];

    return DashboardResponseDto(
      bannerAds: bannerAdsList,
      resumeLearning: ResumeLearningDto.fromJson(
        json['resume_learning'] as Map<String, dynamic>? ?? {},
      ),
      whatsNew: WhatsNewDto.fromJson(
        json['whats_new'] as Map<String, dynamic>? ?? {},
      ),
      completedLearning: CompletedLearningDto.fromJson(
        json['completed_learning'] as Map<String, dynamic>? ?? {},
      ),
      leaderboard: leaderboardList,
    );
  }
}

class ResumeLearningDto {
  final List<ContentAttemptDto> contentAttempts;
  final List<UserVideoDto> userVideos;
  final List<CourseSummaryDto> courses;
  final List<ChapterSummaryDto> chapters;
  final List<ChapterContentSummaryDto> chapterContents;
  final List<UserExamDto> userExams;

  const ResumeLearningDto({
    required this.contentAttempts,
    required this.userVideos,
    required this.courses,
    required this.chapters,
    required this.chapterContents,
    required this.userExams,
  });

  factory ResumeLearningDto.fromJson(Map<String, dynamic> json) {
    return ResumeLearningDto(
      contentAttempts:
          (json['content_attempts'] as List?)
              ?.map(
                (e) => ContentAttemptDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      userVideos:
          (json['user_videos'] as List?)
              ?.map((e) => UserVideoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      courses:
          (json['courses'] as List?)
              ?.map((e) => CourseSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chapters:
          (json['chapters'] as List?)
              ?.map(
                (e) => ChapterSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      chapterContents:
          (json['chapter_contents'] as List?)
              ?.map(
                (e) => ChapterContentSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      userExams:
          (json['user_exams'] as List?)
              ?.map((e) => UserExamDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CompletedLearningDto {
  final List<ContentAttemptDto> contentAttempts;
  final List<UserVideoDto> userVideos;
  final List<CourseSummaryDto> courses;
  final List<ChapterSummaryDto> chapters;
  final List<ChapterContentSummaryDto> chapterContents;
  final List<UserExamDto> userExams;

  const CompletedLearningDto({
    required this.contentAttempts,
    required this.userVideos,
    required this.courses,
    required this.chapters,
    required this.chapterContents,
    required this.userExams,
  });

  factory CompletedLearningDto.fromJson(Map<String, dynamic> json) {
    return CompletedLearningDto(
      contentAttempts:
          (json['content_attempts'] as List?)
              ?.map(
                (e) => ContentAttemptDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      userVideos:
          (json['user_videos'] as List?)
              ?.map((e) => UserVideoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      courses:
          (json['courses'] as List?)
              ?.map((e) => CourseSummaryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chapters:
          (json['chapters'] as List?)
              ?.map(
                (e) => ChapterSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      chapterContents:
          (json['chapter_contents'] as List?)
              ?.map(
                (e) => ChapterContentSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      userExams:
          (json['user_exams'] as List?)
              ?.map((e) => UserExamDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class WhatsNewDto {
  final List<ChapterSummaryDto> chapters;
  final List<ChapterContentSummaryDto> chapterContents;

  const WhatsNewDto({required this.chapters, required this.chapterContents});

  factory WhatsNewDto.fromJson(Map<String, dynamic> json) {
    return WhatsNewDto(
      chapters:
          (json['chapters'] as List?)
              ?.map(
                (e) => ChapterSummaryDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      chapterContents:
          (json['chapter_contents'] as List?)
              ?.map(
                (e) => ChapterContentSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class ContentAttemptDto {
  final String id;
  final String chapterContentId;
  final String contentType;
  final String state;
  final String? remainingTime;
  final String? userVideoId;
  final String? assessmentId;
  final String? courseId;
  final String? chapterId;

  const ContentAttemptDto({
    required this.id,
    required this.chapterContentId,
    required this.contentType,
    required this.state,
    this.remainingTime,
    this.userVideoId,
    this.assessmentId,
    this.courseId,
    this.chapterId,
  });

  factory ContentAttemptDto.fromJson(Map<String, dynamic> json) {
    return ContentAttemptDto(
      id: json['id']?.toString() ?? '',
      chapterContentId: json['chapter_content_id']?.toString() ?? '',
      contentType: json['content_type']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      remainingTime: json['remaining_time']?.toString(),
      userVideoId: json['user_video_id']?.toString(),
      assessmentId: json['assessment_id']?.toString(),
      courseId: json['course_id']?.toString(),
      chapterId: json['chapter_id']?.toString(),
    );
  }
}

class UserVideoDto {
  final String id;
  final double watchedPercentage;
  final String? remainingDuration;
  final VideoContentDto? videoContent;

  const UserVideoDto({
    required this.id,
    required this.watchedPercentage,
    this.remainingDuration,
    this.videoContent,
  });

  factory UserVideoDto.fromJson(Map<String, dynamic> json) {
    return UserVideoDto(
      id: json['id']?.toString() ?? '',
      watchedPercentage:
          (json['watched_percentage'] as num?)?.toDouble() ?? 0.0,
      remainingDuration: json['remaining_duration']?.toString(),
      videoContent: json['video_content'] != null
          ? VideoContentDto.fromJson(
              json['video_content'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class VideoContentDto {
  final String id;
  final String title;
  final String? duration;

  const VideoContentDto({required this.id, required this.title, this.duration});

  factory VideoContentDto.fromJson(Map<String, dynamic> json) {
    return VideoContentDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      duration: json['duration']?.toString(),
    );
  }
}

class CourseSummaryDto {
  final String id;
  final String title;
  final String slug;

  const CourseSummaryDto({
    required this.id,
    required this.title,
    required this.slug,
  });

  factory CourseSummaryDto.fromJson(Map<String, dynamic> json) {
    return CourseSummaryDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }
}

class ChapterSummaryDto {
  final String id;
  final String name;

  const ChapterSummaryDto({required this.id, required this.name});

  factory ChapterSummaryDto.fromJson(Map<String, dynamic> json) {
    return ChapterSummaryDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ChapterContentSummaryDto {
  final String id;
  final String title;
  final String chapterId;
  final String contentType;
  final String? coverImageMedium;
  final String? examId;

  const ChapterContentSummaryDto({
    required this.id,
    required this.title,
    required this.chapterId,
    required this.contentType,
    this.coverImageMedium,
    this.examId,
  });

  factory ChapterContentSummaryDto.fromJson(Map<String, dynamic> json) {
    return ChapterContentSummaryDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      chapterId: json['chapter_id']?.toString() ?? '',
      contentType: json['content_type']?.toString() ?? '',
      coverImageMedium: json['cover_image_medium']?.toString(),
      examId: json['exam_id']?.toString(),
    );
  }
}

class UserExamDto {
  final String id;
  final String examId;
  final String? totalScore;
  final int? numberOfCorrectAnswers;
  final int? numberOfIncorrectAnswers;

  const UserExamDto({
    required this.id,
    required this.examId,
    this.totalScore,
    this.numberOfCorrectAnswers,
    this.numberOfIncorrectAnswers,
  });

  factory UserExamDto.fromJson(Map<String, dynamic> json) {
    return UserExamDto(
      id: json['id']?.toString() ?? '',
      examId: json['exam_id']?.toString() ?? '',
      totalScore: json['total_score']?.toString(),
      numberOfCorrectAnswers: json['number_of_correct_answers'] as int?,
      numberOfIncorrectAnswers: json['number_of_incorrect_answers'] as int?,
    );
  }
}
