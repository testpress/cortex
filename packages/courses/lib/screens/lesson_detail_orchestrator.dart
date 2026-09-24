import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/course_list_provider.dart';
import '../widgets/lesson_detail/pdf_viewer.dart';
import '../widgets/lesson_detail/lesson_web_view.dart';
import '../widgets/lesson_detail/video_lesson_viewer.dart';
import '../widgets/lesson_detail/live_stream_viewer.dart';
import '../widgets/lesson_detail/attachment_viewer.dart';
import '../widgets/lesson_detail/video_conference_viewer.dart';
import '../widgets/lesson_detail/ask_doubt_fab.dart';
import '../widgets/lesson_detail/lesson_detail_skeleton.dart';
import '../widgets/lesson_detail/video_mcq_filter_sheet.dart';
import '../widgets/lesson_detail/assignment_viewer.dart';
import '../providers/downloads_provider.dart';

/// Orchestrator that decides which viewer to show for a given lesson.
/// It wraps content in the unified [LessonDetailShell].
class LessonDetailOrchestrator extends ConsumerStatefulWidget {
  const LessonDetailOrchestrator({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
    this.customBuilder,
    this.error,
    this.onRetry,
  });

  /// The lesson to render.
  final LessonDto lesson;

  /// Optional callback to navigate to the next lesson.
  final VoidCallback? onNext;

  /// Optional callback to navigate to the previous lesson.
  final VoidCallback? onPrevious;

  /// Optional builder to provide specialized viewers for specific lesson types
  /// (e.g. Tests and Assessments from the Exams package).
  final Widget Function(BuildContext context, LessonDto lesson)? customBuilder;

  /// Optional error from fetching full lesson detail.
  final Object? error;

  /// Optional callback to retry fetching lesson detail when in error state.
  final FutureOr<dynamic> Function()? onRetry;

  @override
  ConsumerState<LessonDetailOrchestrator> createState() =>
      _LessonDetailOrchestratorState();
}

class _LessonDetailOrchestratorState
    extends ConsumerState<LessonDetailOrchestrator> {
  final ValueNotifier<double> _readingProgress = ValueNotifier<double>(0.0);
  bool _alreadyMarkedComplete = false;
  bool _isBookmarkSheetOpen = false;
  bool _isCreateFolderDialogOpen = false;
  final ValueNotifier<bool> _isMcqFilterSheetOpen = ValueNotifier<bool>(false);
  String _mcqDifficulty = 'medium';
  int _mcqQuestionCount = 5;

  @override
  void dispose() {
    _readingProgress.dispose();
    _isMcqFilterSheetOpen.dispose();
    super.dispose();
  }

  Future<void> _handleDownload(LessonDto lesson) async {
    _startDownload(lesson);
  }

  Future<void> _startDownload(LessonDto lesson) async {
    if (!mounted) return;

    final currentDownload =
        ref.read(watchDownloadItemProvider(lesson.id)).valueOrNull;
    if (currentDownload?.status == DownloadStatus.downloading ||
        currentDownload?.status == DownloadStatus.paused ||
        (currentDownload?.status == DownloadStatus.completed &&
            currentDownload?.filePath != null)) {
      return;
    }

    if (mounted) {
      AppToast.show(context, message: L10n.of(context).downloadStarted);
    }

    try {
      await ref.read(downloadsProvider.notifier).startPdfLessonDownload(lesson);
      if (mounted) {
        AppToast.show(context, message: L10n.of(context).downloadCompleted);
      }
    } catch (e) {
      if (mounted) {
        AppToast.show(
          context,
          message: L10n.of(context).errorGenericMessage,
          isError: true,
        );
      }
    }
  }

  Future<void> _markAsCompleted() async {
    if (_alreadyMarkedComplete) return;

    setState(() => _alreadyMarkedComplete = true);
    final repository = await ref.read(courseRepositoryProvider.future);
    await repository.updateLessonProgress(
      widget.lesson.id,
      LessonProgressStatus.completed,
    );

    if (!mounted) return;

    if (widget.lesson.type == LessonType.video && widget.onNext != null) {
      // Auto-play the next video if the user setting allows it
      final db = await ref.read(appDatabaseProvider.future);
      final settings = await db.getAppSettings();

      if (!mounted) return;

      final autoPlayNext = settings.autoPlayNext;

      if (autoPlayNext) {
        widget.onNext!();
      }
    }
  }

  Future<void> _removeBookmark(LessonDto lesson) async {
    final bookmarkId = lesson.bookmarkId;
    if (bookmarkId == null) return;

    final l10n = L10n.of(context);

    // Optimistic toast
    AppToast.show(context, message: l10n.bookmarkRemoved);

    final sentry = ref.read(sentryServiceProvider);
    try {
      await ref.read(removeBookmarkProvider(
        bookmarkId: bookmarkId,
        lessonId: int.tryParse(lesson.id) ?? 0,
      ).future);
    } catch (e, stack) {
      sentry.captureException(e, stackTrace: stack);
      if (mounted) {
        AppToast.show(
          context,
          message: L10n.of(context).errorFailedToRemoveBookmark,
          isError: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final isBookmarked = lesson.bookmarkId != null;
    final parsedLessonId = int.tryParse(lesson.id) ?? 0;

    final settings = ref.watch(instituteSettingsProvider);
    final bookmarksEnabled = settings?.bookmarksEnabled ?? false;
    final helpdeskEnabled = settings?.helpdeskEnabled ?? false;

    // Determine if we should show the "Mark as Completed" button in the header
    final supportsManualCompletion = [
      LessonType.pdf,
      LessonType.notes,
      LessonType.embedContent,
      LessonType.attachment,
    ].contains(lesson.type);

    final downloadItem =
        ref.watch(watchDownloadItemProvider(lesson.id)).valueOrNull;
    final isDownloaded = downloadItem?.status == DownloadStatus.completed &&
        downloadItem?.filePath != null;
    final isDownloading = downloadItem?.status == DownloadStatus.downloading ||
        downloadItem?.status == DownloadStatus.paused;
    final canDownload = lesson.type == LessonType.pdf &&
        lesson.allowDownload &&
        lesson.contentUrl != null;

    final isCompleted = _alreadyMarkedComplete ||
        lesson.progressStatus == LessonProgressStatus.completed;

    final isLocked = lesson.isLocked;

    return Stack(
      children: [
        LessonDetailShell(
          title: lesson.title,
          subtitle: lesson.subtitle,
          showTitle: lesson.type != LessonType.assignment,
          isBookmarked: isBookmarked,
          isCompleted: isCompleted,
          isDownloaded: canDownload && isDownloaded,
          isDownloading: canDownload && isDownloading,
          onBack: () => Navigator.of(context).pop(),
          onBookmarkToggle: (!lesson.hasEnded &&
                  !isLocked &&
                  !lesson.isScheduled &&
                  bookmarksEnabled)
              ? () {
                  if (isBookmarked) {
                    _removeBookmark(lesson);
                  } else {
                    setState(() => _isBookmarkSheetOpen = true);
                  }
                }
              : null,
          onMarkAsCompleted: (!lesson.hasEnded &&
                  !isLocked &&
                  !lesson.isScheduled &&
                  supportsManualCompletion)
              ? _markAsCompleted
              : null,
          onDownload: (!lesson.hasEnded &&
                  !isLocked &&
                  !lesson.isScheduled &&
                  canDownload &&
                  !isDownloaded &&
                  !isDownloading)
              ? () => _handleDownload(lesson)
              : null,
          onNext: lesson.type == LessonType.assignment ? null : widget.onNext,
          onPrevious:
              lesson.type == LessonType.assignment ? null : widget.onPrevious,
          stickyFooter: lesson.type != LessonType.assignment &&
              (lesson.hasEnded ||
                  isLocked ||
                  lesson.isScheduled ||
                  widget.error != null ||
                  (lesson.type != LessonType.video &&
                      lesson.type != LessonType.liveStream)),
          child: _buildLessonContent(context),
        ),
        if (!lesson.hasEnded &&
            !isLocked &&
            !lesson.isScheduled &&
            lesson.isComplete &&
            helpdeskEnabled &&
            [
              LessonType.pdf,
              LessonType.notes,
              LessonType.embedContent,
              LessonType.liveStream,
              LessonType.attachment,
            ].contains(lesson.type))
          Positioned(
            bottom: 106,
            right: 24,
            child: AskDoubtFab(
              onTap: () {
                final uri = Uri(
                  path: '/home/discussions/doubts/ask',
                  queryParameters: {
                    'chapterContentId':
                        int.tryParse(lesson.id)?.toString() ?? '',
                    'lessonTitle': lesson.title,
                    'lessonType': lesson.type.name,
                  },
                );
                context.push(uri.toString());
              },
            ),
          ),
        AppBottomSheet(
          key: const ValueKey('bookmark_sheet'),
          isOpen: _isBookmarkSheetOpen,
          onClose: () => setState(() => _isBookmarkSheetOpen = false),
          child: BookmarkFoldersSheet(
            lessonId: parsedLessonId,
            category: lesson.type.name,
            parentContext: context,
            onClose: () => setState(() => _isBookmarkSheetOpen = false),
            onCreateFolderRequest: () {
              setState(() {
                _isBookmarkSheetOpen = false;
                _isCreateFolderDialogOpen = true;
              });
            },
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isMcqFilterSheetOpen,
          builder: (context, isOpen, _) {
            return AppBottomSheet(
              key: const ValueKey('mcq_filter_sheet'),
              isOpen: isOpen,
              onClose: () => _isMcqFilterSheetOpen.value = false,
              child: VideoMcqFilterSheet(
                difficulty: _mcqDifficulty,
                questionCount: _mcqQuestionCount,
                onApply: (difficulty, questionCount) {
                  setState(() {
                    _mcqDifficulty = difficulty;
                    _mcqQuestionCount = questionCount;
                  });
                  _isMcqFilterSheetOpen.value = false;
                },
              ),
            );
          },
        ),
        if (_isCreateFolderDialogOpen)
          CreateFolderDialog(
            lessonId: parsedLessonId,
            category: lesson.type.name,
            onClose: () => setState(() => _isCreateFolderDialogOpen = false),
          ),
      ],
    );
  }

  Widget _buildLessonContent(BuildContext context) {
    final lesson = widget.lesson;
    final onNext = widget.onNext;
    final onPrevious = widget.onPrevious;
    final design = Design.of(context);

    if (lesson.hasEnded) {
      final formattedEnd =
          lesson.end != null ? TimeFormatter.formatDate(lesson.end!) : null;
      final detailMessage = (formattedEnd != null && formattedEnd.isNotEmpty)
          ? L10n.of(context).accessExpiredOn(formattedEnd)
          : L10n.of(context).contentAccessEnded;

      return ContentNoticeView(
        icon: LucideIcons.calendarClock,
        title: L10n.of(context).accessExpired,
        message: detailMessage,
      );
    }

    if (lesson.isLocked) {
      return ContentNoticeView(
        icon: LucideIcons.lock,
        title: L10n.of(context).errorAccessDeniedTitle,
        message: L10n.of(context).completePreviousContentToUnlock,
      );
    }

    if (lesson.isScheduled &&
        lesson.type != LessonType.liveStream &&
        lesson.type != LessonType.videoConference) {
      final scheduledMsg = lesson.scheduledMessage;
      final detailMessage = (scheduledMsg != null && scheduledMsg.isNotEmpty)
          ? scheduledMsg
          : L10n.of(context).liveStreamScheduledDefault;

      return ContentNoticeView(
        icon: LucideIcons.calendarClock,
        title: L10n.of(context).liveStreamScheduledDefault,
        message: detailMessage,
      );
    }

    if (widget.customBuilder != null) {
      final customWidget = widget.customBuilder!(context, lesson);
      if (customWidget is! SizedBox) {
        return customWidget;
      }
    }

    final isAccessError = widget.error is ApiException &&
        ([
          ApiErrorType.forbidden,
          ApiErrorType.unauthorized,
          ApiErrorType.notFound,
        ].contains((widget.error as ApiException).type));

    if (widget.error != null && (isAccessError || !lesson.isComplete)) {
      return Center(
        child: AppErrorView(
          error: widget.error,
          onRetry: widget.onRetry,
        ),
      );
    }

    // New: Show loader if we have some data from the list but not enough to render the viewer yet
    if (!lesson.isComplete) {
      return LessonDetailSkeleton(lessonType: lesson.type);
    }

    // Priority 2: Built-in viewers
    switch (lesson.type) {
      case LessonType.video:
        return VideoLessonViewer(
          lesson: lesson,
          onComplete: _markAsCompleted,
          footerBuilder: (context) => LessonDetailShell.buildStaticFooter(
            context,
            onNext: onNext,
            onPrevious: onPrevious,
          ),
          onOpenMcqFilterSheet: () => _isMcqFilterSheetOpen.value = true,
          mcqDifficulty: _mcqDifficulty,
          mcqQuestionCount: _mcqQuestionCount,
        );
      case LessonType.pdf:
        return _PdfLessonViewer(
          lesson: lesson,
          onProgressChanged: (progress) => _readingProgress.value = progress,
        );
      case LessonType.notes:
      case LessonType.embedContent:
        if (lesson.htmlContent != null) {
          return LessonWebView(
            htmlContent: lesson.htmlContent!,
            description: lesson.description,
          );
        }
        break;
      case LessonType.liveStream:
        return LiveStreamViewer(
          lesson: lesson,
          onComplete: _markAsCompleted,
          footerBuilder: (context) => LessonDetailShell.buildStaticFooter(
            context,
            onNext: onNext,
            onPrevious: onPrevious,
          ),
        );
      case LessonType.videoConference:
        final isEnded = lesson.streamStatus?.toLowerCase() == 'completed' ||
            lesson.streamStatus?.toLowerCase() == 'ended';
        if (isEnded &&
            (lesson.isZoom || lesson.isTeams) &&
            lesson.showRecordedVideo) {
          return VideoLessonViewer(
            lesson: lesson,
            onComplete: _markAsCompleted,
            onOpenMcqFilterSheet: () => _isMcqFilterSheetOpen.value = true,
            mcqDifficulty: _mcqDifficulty,
            mcqQuestionCount: _mcqQuestionCount,
          );
        }
        return VideoConferenceViewer(
          lesson: lesson,
          onComplete: _markAsCompleted,
        );
      case LessonType.attachment:
        if (lesson.contentUrl != null) {
          return AttachmentViewer(
            id: lesson.id,
            title: lesson.title,
            url: lesson.contentUrl!,
          );
        }
        break;
      case LessonType.test:
      case LessonType.assessment:
        return Center(
          child: AppText.body(
            L10n.of(context).lessonSpecializedViewerRequired(lesson.type.name),
            color: design.colors.textSecondary,
          ),
        );
      case LessonType.assignment:
        return AssignmentLessonViewer(
          lesson: lesson,
          onComplete: _markAsCompleted,
        );
      case LessonType.unknown:
        break;
    }

    return Center(
      child: AppText.body(
        L10n.of(context).chapterNoContent,
        color: design.colors.textSecondary,
      ),
    );
  }
}

class _PdfLessonViewer extends ConsumerWidget {
  final LessonDto lesson;
  final ValueChanged<double>? onProgressChanged;

  const _PdfLessonViewer({
    required this.lesson,
    this.onProgressChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadItemAsync = ref.watch(watchDownloadItemProvider(lesson.id));

    final downloadItem = downloadItemAsync.valueOrNull;
    final filePath = downloadItem?.filePath;
    final isDownloaded =
        downloadItem?.status == DownloadStatus.completed && filePath != null;

    if (!downloadItemAsync.hasValue) {
      return LessonDetailSkeleton(lessonType: LessonType.pdf);
    }

    if (isDownloaded) {
      return AppPdfViewer.file(
        key: ValueKey('pdf_file_${lesson.id}'),
        file: File(filePath),
        onProgressChanged: onProgressChanged,
      );
    }

    if (lesson.contentUrl != null) {
      return AppPdfViewer.network(
        key: ValueKey('pdf_network_${lesson.id}'),
        url: lesson.contentUrl!,
        onProgressChanged: onProgressChanged,
      );
    }

    return const SizedBox.shrink();
  }
}
