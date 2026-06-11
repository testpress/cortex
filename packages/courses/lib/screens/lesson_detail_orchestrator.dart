import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../models/course_content.dart';
import '../providers/course_list_provider.dart';
import '../widgets/lesson_detail/pdf_viewer.dart';
import '../widgets/lesson_detail/lesson_web_view.dart';
import '../widgets/lesson_detail/video_lesson_viewer.dart';
import '../widgets/lesson_detail/attachment_viewer.dart';
import '../widgets/lesson_detail/live_stream_viewer.dart';
import '../widgets/lesson_detail/ask_doubt_fab.dart';
import '../widgets/lesson_detail/lesson_detail_skeleton.dart';

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
  double _readingProgress = 0.0;
  bool _alreadyMarkedComplete = false;
  bool _isBookmarkSheetOpen = false;
  bool _isCreateFolderDialogOpen = false;

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
    } catch (e, stack) {
      debugPrint('Error removing bookmark: $e\n$stack');
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
          progress: lesson.type == LessonType.pdf ? _readingProgress : null,
          onBack: () => Navigator.of(context).pop(),
          onBookmarkToggle: () {
            if (isBookmarked) {
              _removeBookmark(lesson);
            } else {
              setState(() => _isBookmarkSheetOpen = true);
            }
          },
          onMarkAsCompleted: supportsManualCompletion ? _markAsCompleted : null,
          onNext: widget.onNext,
          onPrevious: widget.onPrevious,
          stickyFooter: lesson.type != LessonType.video &&
              lesson.type != LessonType.liveStream,
          child: _buildLessonContent(context),
        ),
        if (lesson.isComplete &&
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
          return AppPdfViewer(
            url: lesson.contentUrl!,
            onProgressChanged: (progress) {
              setState(() => _readingProgress = progress);
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
