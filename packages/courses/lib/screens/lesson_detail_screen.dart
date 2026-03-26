import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/course_content.dart';
import '../providers/course_list_provider.dart';
import '../widgets/lesson_detail/lesson_detail_header.dart';
import '../widgets/lesson_detail/lesson_reading_progress_bar.dart';
import '../widgets/lesson_detail/lesson_navigation_footer.dart';
import '../widgets/lesson_detail/pdf_viewer.dart';
import '../providers/lesson_detail_provider.dart';

/// Fullscreen reader for text-based lessons.
///
/// Supports rich content rendering, reading progress tracking, and navigation.
class LessonDetailScreen extends ConsumerStatefulWidget {
  const LessonDetailScreen({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
  });

  /// The lesson domain model to render.
  final Lesson lesson;

  /// Optional callback to navigate to the next lesson.
  final VoidCallback? onNext;

  /// Optional callback to navigate to the previous lesson.
  final VoidCallback? onPrevious;

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;
  bool _showDownloadFeedback = false;
  bool _alreadyMarkedComplete = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Calculates reading progress based on scroll position.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    // Avoid division by zero if content is shorter than the viewport
    if (maxScroll <= 0) {
      if (_readingProgress != 1.0) {
        setState(() => _readingProgress = 1.0);
        if (widget.lesson.progressStatus != LessonProgressStatus.completed) {
          _markAsCompleted();
        }
      }
      return;
    }

    final newProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    if ((newProgress - _readingProgress).abs() > 0.01) {
      setState(() {
        _readingProgress = newProgress;
      });

      // Mark as completed if scroll exceeds 99%
      if (newProgress >= 0.99 &&
          !_alreadyMarkedComplete &&
          widget.lesson.progressStatus != LessonProgressStatus.completed) {
        _alreadyMarkedComplete = true;
        _markAsCompleted();
      }
    }
  }

  Future<void> _markAsCompleted() async {
    final repository = await ref.read(courseRepositoryProvider.future);
    await repository.updateLessonProgress(
      widget.lesson.id,
      LessonProgressStatus.completed,
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final subjectColors = widget.lesson.subjectIndex != null
        ? design.subjectPalette.atIndex(widget.lesson.subjectIndex!)
        : null;

    final isBookmarked =
        ref.watch(lessonBookmarkProvider(widget.lesson.id)).valueOrNull ??
        false;

    return Container(
      color: design.colors.surface,
      child: Stack(
        children: [
          Column(
            children: [
              // Sticky Top Navigation
              LessonDetailHeader(
                onBack: () => Navigator.of(context).pop(),
                isBookmarked: isBookmarked,
                onBookmarkToggle: () async {
                  final repository = await ref.read(
                    courseRepositoryProvider.future,
                  );
                  await repository.toggleLessonBookmark(widget.lesson.id);
                },
                onDownload: () {
                  setState(() => _showDownloadFeedback = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() => _showDownloadFeedback = false);
                    }
                  });
                },
              ),
              // Scroll-linked progress bar
              LessonReadingProgressBar(
                progress: _readingProgress,
                foregroundColor: subjectColors?.accent,
                animationDuration: widget.lesson.type == LessonType.pdf
                    ? const Duration(milliseconds: 50)
                    : const Duration(milliseconds: 300),
              ),
              // Main Content Area
              Expanded(
                child: _buildMediaContent(context, design, subjectColors),
              ),
            ],
          ),
          if (_showDownloadFeedback)
            Positioned(
              bottom: design.spacing.xl,
              left: design.spacing.md,
              right: design.spacing.md,
              child: _CustomToast(message: L10n.of(context).lessonDownload),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(
    BuildContext context,
    DesignConfig design,
    dynamic subjectColors,
  ) {
    // PDF Lesson: Render the new premium PDF viewer
    if (widget.lesson.type == LessonType.pdf &&
        widget.lesson.contentUrl != null) {
      return Column(
        children: [
          Expanded(
            child: AppPdfViewer(
              url: widget.lesson.contentUrl!,
              onProgressChanged: (progress) {
                setState(() => _readingProgress = progress);

                // Mark as completed if progress exceeds 99%
                if (progress >= 0.99 &&
                    !_alreadyMarkedComplete &&
                    widget.lesson.progressStatus !=
                        LessonProgressStatus.completed) {
                  _alreadyMarkedComplete = true;
                  _markAsCompleted();
                }
              },
            ),
          ),
          _buildNavigationFooter(design),
        ],
      );
    }

    // Video Lesson: For now, fallback or empty (will be consolidated later or handled by VideoDetailScreen)
    if (widget.lesson.type == LessonType.video) {
      return const Center(child: AppText.body('Video content coming soon...'));
    }

    // Fallback: Empty state or assessment placeholder
    return Center(
      child: AppText.body('No content available for this lesson type'),
    );
  }

  Widget _buildNavigationFooter(DesignConfig design) {
    return Padding(
      padding: EdgeInsets.all(design.spacing.md),
      child: LessonNavigationFooter(
        onPrevious: widget.onPrevious,
        onNext: widget.onNext,
        hasPrevious: widget.onPrevious != null,
        hasNext: widget.onNext != null,
      ),
    );
  }
}



class _CustomToast extends StatelessWidget {
  const _CustomToast({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.textPrimary,
        borderRadius: BorderRadius.circular(design.radius.md),
        boxShadow: [
          BoxShadow(
            color: design.colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppText.label(
        message,
        color: design.colors.textInverse,
        textAlign: TextAlign.center,
      ),
    );
  }
}
