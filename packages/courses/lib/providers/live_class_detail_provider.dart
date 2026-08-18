import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:async/async.dart';
import 'course_list_provider.dart';
import '../models/course_content.dart';

part 'live_class_detail_provider.g.dart';

/// Provider that fetches a specific live class domain model by its ID.
///
/// Uses a timed keep-alive cache exactly like lessonDetailProvider.
@riverpod
Stream<Lesson?> liveClassDetail(
    LiveClassDetailRef ref, String lessonId) async* {
  final link = ref.keepAlive();
  Timer? disposeTimer;

  ref.onCancel(() {
    disposeTimer = Timer(const Duration(minutes: 5), link.close);
  });
  ref.onResume(() async {
    disposeTimer?.cancel();
    disposeTimer = null;
    final repository = await ref.read(courseRepositoryProvider.future);
    repository.refreshLiveClass(lessonId).ignore();
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

  if (initial == null) {
    // First time load: Await fetch so the UI starts in a loading state
    try {
      await repository.refreshLiveClass(lessonId);
    } catch (e) {
      rethrow;
    }
    yield* dbStream;
  } else if (!initial.isDetailFetched) {
    // Background refresh: Combine DB updates with the refresh result
    yield* StreamGroup.merge<Lesson?>([
      dbStream,
      repository
          .refreshLiveClass(lessonId)
          .asStream()
          .handleError((e) {
            throw e;
          })
          .where((_) => false)
          .cast<Lesson?>(),
    ]);
  } else {
    // Already have complete data: Safe to refresh in the background silently
    repository.refreshLiveClass(lessonId).ignore();
    yield* dbStream;
  }
}
