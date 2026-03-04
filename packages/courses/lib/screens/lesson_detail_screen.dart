import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import '../models/course_content.dart';
import '../widgets/lesson_detail/lesson_detail_header.dart';
import '../widgets/lesson_detail/lesson_reading_progress_bar.dart';
import '../widgets/lesson_detail/lesson_navigation_footer.dart';
import '../widgets/lesson_detail/content_widgets.dart';
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
          widget.lesson.progressStatus != LessonProgressStatus.completed) {
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
              ),
              // Main Content Area
              Expanded(
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.screenPadding,
                        vertical: design.spacing.xl,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Lesson Title & Badges
                          _LessonMetaSection(lesson: widget.lesson),
                          SizedBox(height: design.spacing.lg),

                          // Rich Content Blocks
                          ...widget.lesson.content.map(
                            (item) =>
                                _renderContentItem(item, subjectColors?.accent),
                          ),

                          SizedBox(height: design.spacing.md),

                          // Sequential Navigation
                          LessonNavigationFooter(
                            onPrevious: widget.onPrevious,
                            onNext: widget.onNext,
                            hasPrevious: widget.onPrevious != null,
                            hasNext: widget.onNext != null,
                          ),

                          SizedBox(height: design.spacing.md),
                        ]),
                      ),
                    ),
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

  /// Maps content domain models to their respective rendering widgets.
  Widget _renderContentItem(LessonContentItem item, Color? bulletColor) {
    return switch (item) {
      HeadingContent() => LessonHeading(text: item.text, level: item.level),
      ParagraphContent() => LessonParagraph(text: item.text),
      ImageContent() => LessonImage(
        imageUrl: item.imageUrl,
        altText: item.altText,
      ),
      ListContent() => LessonList(items: item.items, bulletColor: bulletColor),
      CalloutContent() => LessonCallout(text: item.text, type: item.type),
      VideoContent() => const SizedBox.shrink(),
    };
  }
}

/// Renders the informational header below the sticky navigation.
class _LessonMetaSection extends StatelessWidget {
  const _LessonMetaSection({required this.lesson});
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (lesson.subjectName != null && lesson.subjectIndex != null) ...[
              AppSubjectChip(
                label: lesson.subjectName!,
                subjectPaletteIndex: lesson.subjectIndex!,
                isActive: true,
                onTap: () {},
              ),
              SizedBox(width: design.spacing.sm),
            ],
            if (lesson.lessonNumber != null && lesson.totalLessons != null)
              AppText.caption(
                l10n.lessonXofY(lesson.lessonNumber!, lesson.totalLessons!),
                color: design.colors.textSecondary,
              ),
            if (lesson.duration != null) ...[
              SizedBox(width: design.spacing.xs),
              AppText.caption('•', color: design.colors.textTertiary),
              SizedBox(width: design.spacing.xs),
              AppText.caption(
                lesson.duration!,
                color: design.colors.textSecondary,
              ),
            ],
          ],
        ),
        SizedBox(height: design.spacing.md),
        AppText.headline(lesson.title, color: design.colors.textPrimary),
        if (lesson.subtitle != null) ...[
          SizedBox(height: design.spacing.sm),
          AppText.body(lesson.subtitle!, color: design.colors.textSecondary),
        ],
        SizedBox(height: design.spacing.lg),
        Container(color: design.colors.divider, height: 1),
      ],
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
