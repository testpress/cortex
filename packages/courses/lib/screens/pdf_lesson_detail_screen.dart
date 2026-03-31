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

/// Specialized reader for PDF-based lessons.
class PdfLessonDetailScreen extends ConsumerStatefulWidget {
  const PdfLessonDetailScreen({
    super.key,
    required this.lesson,
    this.onNext,
    this.onPrevious,
  });

  /// The PDF lesson to render.
  final Lesson lesson;

  /// Optional callback to navigate to the next lesson.
  final VoidCallback? onNext;

  /// Optional callback to navigate to the previous lesson.
  final VoidCallback? onPrevious;

  @override
  ConsumerState<PdfLessonDetailScreen> createState() =>
      _PdfLessonDetailScreenState();
}

class _PdfLessonDetailScreenState extends ConsumerState<PdfLessonDetailScreen> {
  double _readingProgress = 0.0;
  bool _showDownloadFeedback = false;
  bool _alreadyMarkedComplete = false;

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
                animationDuration: const Duration(milliseconds: 50),
              ),
              // Main PDF Content Area
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: AppPdfViewer(
                        url: widget.lesson.contentUrl ?? '',
                        onProgressChanged: (progress) {
                          setState(() => _readingProgress = progress);

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
                ),
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
