import 'dart:async';
import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'course_list_provider.dart';
import '../models/course_content.dart';
import '../utils/pdf_cache_service.dart';
import 'package:async/async.dart';

part 'lesson_detail_provider.g.dart';

/// Provider that fetches a specific lesson domain model by its ID.
///
/// Uses a timed keep-alive: the provider stays cached for 5 minutes after its
/// last listener drops (e.g. the user navigates away), then disposes itself.
/// This avoids the unbounded memory growth of a static [keepAlive: true] while
/// still providing fast re-entry for typical back-navigation patterns.
@riverpod
Stream<Lesson?> lessonDetail(LessonDetailRef ref, String lessonId) async* {
  final link = ref.keepAlive();
  Timer? disposeTimer;

  ref.onCancel(() {
    disposeTimer = Timer(const Duration(minutes: 5), link.close);
  });
  ref.onResume(() async {
    disposeTimer?.cancel();
    disposeTimer = null;
    final repository = await ref.read(courseRepositoryProvider.future);
    repository.refreshLesson(lessonId).ignore();
  });
  ref.onDispose(() => disposeTimer?.cancel());

  final repository = await ref.watch(courseRepositoryProvider.future);

  final initial = await repository.getLesson(lessonId);

  final Stream<Lesson?> dbStream = repository.watchLesson(lessonId).map((row) {
    if (row == null) return null;

    final lessonDto = repository.rowToLessonDto(row);
    return Lesson(
      id: lessonDto.id,
      chapterId: lessonDto.chapterId,
      title: lessonDto.title,
      type: lessonDto.type,
      progressStatus: lessonDto.progressStatus,
      orderIndex: lessonDto.orderIndex,
      duration: lessonDto.duration,
      isLocked: lessonDto.isLocked,
      bookmarkId: lessonDto.bookmarkId,
      subtitle: lessonDto.subtitle,
      subjectName: lessonDto.subjectName,
      subjectIndex: lessonDto.subjectIndex,
      lessonNumber: lessonDto.lessonNumber,
      totalLessons: lessonDto.totalLessons,
      uuid: lessonDto.uuid,
      contentUrl: lessonDto.contentUrl,
      image: lessonDto.image,
      isRunning: lessonDto.isRunning,
      isUpcoming: lessonDto.isUpcoming,
      hasAttempts: lessonDto.hasAttempts,
      start: lessonDto.start,
      end: lessonDto.end,
      hasEnded: lessonDto.hasEnded,
      nextContentId: lessonDto.nextContentId,
      previousContentId: lessonDto.previousContentId,
      htmlContent: lessonDto.htmlContent,
      isDetailFetched: lessonDto.isDetailFetched,
      chatEmbedUrl: lessonDto.chatEmbedUrl,
      streamStatus: lessonDto.streamStatus,
      showRecordedVideo: lessonDto.showRecordedVideo,
      liveStreamProvider: lessonDto.liveStreamProvider,
      isScheduled: lessonDto.isScheduled,
      scheduledMessage: lessonDto.scheduledMessage,
      attemptsUrl: lessonDto.attemptsUrl,
      slug: lessonDto.slug,
      description: lessonDto.description,
      enableTranscript: lessonDto.enableTranscript,
      videoSubtitleUrl: lessonDto.videoSubtitleUrl,
      isAiEnabled: lessonDto.isAiEnabled,
      canEnableLearnlensAi: lessonDto.canEnableLearnlensAi,
      learnlensAssetId: lessonDto.learnlensAssetId,
      learnlensAssetStatus: lessonDto.learnlensAssetStatus,
      aiNotesUrl: lessonDto.aiNotesUrl,
      lastWatchedDuration: lessonDto.lastWatchedDuration,
      exam: lessonDto.exam,
      allowDownload: lessonDto.allowDownload,
      watermarkBeforeDownload: lessonDto.watermarkBeforeDownload,
      conferenceId: lessonDto.conferenceId,
      password: lessonDto.password,
      accessToken: lessonDto.accessToken,
    );
  });

  final sentryService = ref.read(sentryServiceProvider);
  if (initial == null) {
    // First time load: Await fetch so the UI starts in a loading state
    try {
      final refreshed = await repository.refreshLesson(lessonId);
      _prefetchPdfLesson(ref, refreshed);
    } catch (e, st) {
      sentryService.captureException(e, stackTrace: st);
      rethrow;
    }
    yield* dbStream;
  } else if (!initial.isComplete) {
    // Background refresh: Combine DB updates with the refresh result
    // If refresh fails, the error propagates through the merged stream.
    yield* StreamGroup.merge<Lesson?>([
      dbStream,
      repository
          .refreshLesson(lessonId)
          .then((lesson) {
            _prefetchPdfLesson(ref, lesson);
          })
          .asStream()
          .handleError((e) {
            throw e;
          })
          .where((_) => false)
          .cast<Lesson?>(),
    ]);
  } else {
    // Already have complete data: Safe to refresh in the background silently
    _prefetchPdfLesson(ref, initial);
    repository.refreshLesson(lessonId).then((lesson) {
      _prefetchPdfLesson(ref, lesson);
    }).ignore();
    yield* dbStream;
  }
}

void _prefetchPdfLesson(LessonDetailRef ref, LessonDto lesson) {
  final url = lesson.contentUrl;
  if (lesson.type != LessonType.pdf || url == null || url.isEmpty) return;

  ref
      .read(pdfCacheServiceProvider)
      .prefetchPdf(
        lessonId: lesson.id,
        url: url,
      )
      .ignore();
}

/// Provider that watches and manages the bookmark status of a specific lesson.
@riverpod
Stream<bool> lessonBookmark(LessonBookmarkRef ref, String lessonId) async* {
  final repository = await ref.watch(courseRepositoryProvider.future);
  yield* repository.watchLesson(lessonId).map((l) => l?.bookmarkId != null);
}
