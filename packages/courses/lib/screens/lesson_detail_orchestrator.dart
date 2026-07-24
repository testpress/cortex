import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../models/course_content.dart';
import '../providers/course_list_provider.dart';
import '../widgets/lesson_detail/pdf_viewer.dart';
import '../widgets/lesson_detail/lesson_web_view.dart';
import '../widgets/lesson_detail/video_lesson_viewer.dart';
import '../widgets/lesson_detail/live_stream_viewer.dart';
import '../widgets/lesson_detail/attachment_viewer.dart';
import '../utils/pdf_download_service.dart';
import '../utils/pdf_cache_service.dart';
import '../widgets/lesson_detail/ask_doubt_fab.dart';
import '../widgets/lesson_detail/lesson_detail_skeleton.dart';
import 'package:open_filex/open_filex.dart';
import '../widgets/lesson_detail/download_progress_banner.dart';
import '../widgets/lesson_detail/already_downloaded_sheet.dart';

/// Orchestrator that decides which viewer to show for a given lesson.
/// It wraps content in the unified [LessonDetailShell].
class LessonDetailOrchestrator extends ConsumerStatefulWidget {
  const LessonDetailOrchestrator({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
    this.customBuilder,
  });

  /// The lesson to render.
  final Lesson lesson;

  /// Optional callback to navigate to the next lesson.
  final VoidCallback? onNext;

  /// Optional callback to navigate to the previous lesson.
  final VoidCallback? onPrevious;

  /// Optional builder to provide specialized viewers for specific lesson types
  /// (e.g. Tests and Assessments from the Exams package).
  final Widget Function(BuildContext context, Lesson lesson)? customBuilder;

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
  bool _isAlreadyDownloadedSheetOpen = false;
  bool _justCompletedDownload = false;

  @override
  void dispose() {
    _readingProgress.dispose();
    super.dispose();
  }

  Future<void> _handleDownload(Lesson lesson) async {
    final downloadItem =
        ref.read(watchDownloadItemProvider(lesson.id)).valueOrNull;

    if (downloadItem?.status == DownloadStatus.completed) {
      // Check the exact path stored in the DB (covers the last download).
      final filePath = downloadItem?.filePath;
      final storedFileExists = filePath != null &&
          filePath.isNotEmpty &&
          await File(filePath).exists();

      // Also check the canonical base-name file (lesson.pdf, not lesson (1).pdf).
      // This catches the case where the user deleted a duplicate but the
      // original file from the first download is still present.
      final pdfService = ref.read(pdfDownloadServiceProvider);
      final canonicalPath = await pdfService.getDownloadedPath(lesson.title);
      final canonicalFileExists = canonicalPath != null;

      if ((storedFileExists || canonicalFileExists) && mounted) {
        setState(() => _isAlreadyDownloadedSheetOpen = true);
        return;
      }

      // Both paths are gone — the DB record is stale. Wipe it so the next
      // download starts fresh.
      if (mounted) {
        final downloadsRepo =
            await ref.read(downloadsRepositoryProvider.future);
        await downloadsRepo.deleteDownload(downloadItem!);
      }
    }

    _startDownload(lesson);
  }

  Future<void> _startDownload(Lesson lesson) async {
    if (!mounted) return;

    try {
      final pdfService = ref.read(pdfDownloadServiceProvider);
      await pdfService.downloadAndWatermarkPdf(
        lessonId: lesson.id,
        url: lesson.contentUrl!,
        lessonTitle: lesson.title,
        fallbackWatermarkText: L10n.of(context).pdfWatermarkFallbackText,
      );
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

  Future<void> _removeBookmark(Lesson lesson) async {
    final bookmarkId = lesson.bookmarkId;
    if (bookmarkId == null) return;

    final l10n = L10n.of(context);

    // Optimistic toast
    AppToast.show(context, message: l10n.bookmarkRemoved);

    try {
      await ref.read(removeBookmarkProvider(
        bookmarkId: bookmarkId,
        lessonId: int.tryParse(lesson.id) ?? 0,
      ).future);
    } catch (e) {
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
    ref.listen(watchDownloadItemProvider(widget.lesson.id), (previous, next) {
      final wasDownloading =
          previous?.valueOrNull?.status == DownloadStatus.downloading;
      final isNowCompleted =
          next.valueOrNull?.status == DownloadStatus.completed;

      if (wasDownloading && isNowCompleted) {
        setState(() => _justCompletedDownload = true);
        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() => _justCompletedDownload = false);
          }
        });
      }
    });

    final lesson = widget.lesson;
    final isBookmarked = lesson.bookmarkId != null;
    final parsedLessonId = int.tryParse(lesson.id) ?? 0;

    final settings = ref.watch(instituteSettingsProvider);
    final bookmarksEnabled = settings?.bookmarksEnabled ?? false;
    final helpdeskEnabled = settings?.helpdeskEnabled ?? false;
    final downloadItemAsync = ref.watch(watchDownloadItemProvider(lesson.id));
    final downloadItem = downloadItemAsync.valueOrNull;

    final isDownloading = downloadItem?.status == DownloadStatus.downloading;
    final downloadProgress = downloadItem?.progress ?? 0;
    final downloadedFilePath = downloadItem?.filePath;

    // Determine if we should show the "Mark as Completed" button in the header
    final supportsManualCompletion = [
      LessonType.pdf,
      LessonType.notes,
      LessonType.embedContent,
      LessonType.attachment,
    ].contains(lesson.type);

    final isCompleted = _alreadyMarkedComplete ||
        lesson.progressStatus == LessonProgressStatus.completed;

    return Stack(
      children: [
        LessonDetailShell(
          title: lesson.title,
          subtitle: lesson.subtitle,
          isBookmarked: isBookmarked,
          isCompleted: isCompleted,
          progressListenable:
              lesson.type == LessonType.pdf ? _readingProgress : null,
          onBack: () => Navigator.of(context).pop(),
          onBookmarkToggle: bookmarksEnabled
              ? () {
                  if (isBookmarked) {
                    _removeBookmark(lesson);
                  } else {
                    setState(() => _isBookmarkSheetOpen = true);
                  }
                }
              : null,
          onMarkAsCompleted: supportsManualCompletion ? _markAsCompleted : null,
          onDownload: lesson.allowDownload && lesson.contentUrl != null
              ? () => _handleDownload(lesson)
              : null,
          isDownloading: isDownloading,
          onNext: widget.onNext,
          onPrevious: widget.onPrevious,
          stickyFooter: lesson.type != LessonType.video &&
              lesson.type != LessonType.liveStream,
          child: _buildLessonContent(context),
        ),
        if (lesson.isComplete &&
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
        if (isDownloading || _justCompletedDownload)
          Positioned(
            key: const ValueKey('download_progress_banner'),
            bottom: 0,
            left: 0,
            right: 0,
            child: DownloadProgressBanner(
              isCompleted: !isDownloading,
              progress: downloadProgress,
              onView: downloadedFilePath != null
                  ? () => OpenFilex.open(downloadedFilePath)
                  : null,
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
        AppBottomSheet(
          key: const ValueKey('already_downloaded_sheet'),
          isOpen: _isAlreadyDownloadedSheetOpen,
          onClose: () => setState(() => _isAlreadyDownloadedSheetOpen = false),
          child: AlreadyDownloadedSheet(
            onClose: () =>
                setState(() => _isAlreadyDownloadedSheetOpen = false),
            onOpenFile: () {
              if (downloadedFilePath != null) {
                OpenFilex.open(downloadedFilePath);
              }
            },
            onDownloadAgain: () {
              setState(() => _isAlreadyDownloadedSheetOpen = false);
              _startDownload(lesson);
            },
          ),
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

    if (widget.customBuilder != null) {
      final customWidget = widget.customBuilder!(context, lesson);
      if (customWidget is! SizedBox) {
        return customWidget;
      }
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
        );
      case LessonType.pdf:
        if (lesson.contentUrl != null) {
          return _CachedPdfLessonViewer(
            lesson: lesson,
            onProgressChanged: (progress) {
              _readingProgress.value = progress;
            },
          );
        }
        break;
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

class _CachedPdfLessonViewer extends ConsumerWidget {
  const _CachedPdfLessonViewer({
    required this.lesson,
    required this.onProgressChanged,
  });

  final Lesson lesson;
  final ValueChanged<double> onProgressChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = lesson.contentUrl;
    if (url == null || url.isEmpty) {
      return LessonDetailSkeleton(lessonType: LessonType.pdf);
    }

    final pdfFile = ref.watch(
      pdfFileProvider(PdfCacheRequest(
        lessonId: lesson.id,
        url: url,
      )),
    );

    return pdfFile.when(
      skipLoadingOnReload: true,
      data: (file) => AppPdfViewer(
        file: file,
        onProgressChanged: onProgressChanged,
      ),
      loading: () => LessonDetailSkeleton(lessonType: LessonType.pdf),
      error: (error, _) => Center(
        child: AppText.body(
          error.toString(),
          color: Design.of(context).colors.error,
        ),
      ),
    );
  }
}
