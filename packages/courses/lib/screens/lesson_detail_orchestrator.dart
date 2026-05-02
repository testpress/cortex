import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/course_content.dart';
import '../providers/course_list_provider.dart';
import '../providers/lesson_detail_provider.dart';
import '../widgets/lesson_detail/pdf_viewer.dart';
import '../widgets/lesson_detail/lesson_web_view.dart';
import '../widgets/lesson_detail/video_lesson_viewer.dart';
import '../widgets/lesson_detail/attachment_viewer.dart';
import '../widgets/lesson_detail/live_stream_viewer.dart';

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

  Future<void> _markAsCompleted() async {
    if (_alreadyMarkedComplete) return;

    setState(() => _alreadyMarkedComplete = true);
    final repository = await ref.read(courseRepositoryProvider.future);
    await repository.updateLessonProgress(
      widget.lesson.id,
      LessonProgressStatus.completed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final isBookmarked =
        ref.watch(lessonBookmarkProvider(lesson.id)).valueOrNull ?? false;

    // Determine if we should show the "Mark as Completed" button in the header
    final supportsManualCompletion = [
      LessonType.pdf,
      LessonType.notes,
      LessonType.embedContent,
      LessonType.attachment,
    ].contains(lesson.type);

    final isCompleted = _alreadyMarkedComplete ||
        lesson.progressStatus == LessonProgressStatus.completed;

    final showTitleInShell = ![
      LessonType.video,
      LessonType.liveStream,
    ].contains(lesson.type);

    return LessonDetailShell(
      title: showTitleInShell ? lesson.title : '',
      subtitle: showTitleInShell ? lesson.subtitle : null,
      isBookmarked: isBookmarked,
      isCompleted: isCompleted,
      progress: lesson.type == LessonType.pdf ? _readingProgress : null,
      onBack: () => Navigator.of(context).pop(),
      onBookmarkToggle: () async {
        final repository = await ref.read(courseRepositoryProvider.future);
        await repository.toggleLessonBookmark(lesson.id);
      },
      onMarkAsCompleted: supportsManualCompletion ? _markAsCompleted : null,
      onNext: widget.onNext,
      onPrevious: widget.onPrevious,
      stickyFooter:
          lesson.type != LessonType.video && 
          lesson.type != LessonType.liveStream,
      child: _buildLessonContent(context),
    );
  }

  Widget _buildLessonContent(BuildContext context) {
    final lesson = widget.lesson;
    final onNext = widget.onNext;
    final onPrevious = widget.onPrevious;
    final design = Design.of(context);

    // Priority 1: Custom Builder
    if (widget.customBuilder != null) {
      final customWidget = widget.customBuilder!(context, lesson);
      if (customWidget is! SizedBox) {
        return customWidget;
      }
    }

    // New: Show loader if we have some data from the list but not enough to render the viewer yet
    if (!lesson.isComplete && lesson.type != LessonType.liveStream) {
      return const Center(child: AppLoadingIndicator());
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
          return LessonWebView(htmlContent: lesson.htmlContent!);
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
            title: lesson.title,
            url: lesson.contentUrl!,
          );
        }
        break;
      case LessonType.test:
      case LessonType.assessment:
        return Center(
          child: AppText.body(
            'Specialized viewer required for ${lesson.type.name}',
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
