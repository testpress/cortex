import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show Divider; // Use Divider from Material for convenience
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../models/course_content.dart';
import '../widgets/lesson_detail/lesson_detail_header.dart';
import '../widgets/lesson_detail/lesson_reading_progress_bar.dart';
import '../widgets/lesson_detail/lesson_navigation_footer.dart';
import '../widgets/lesson_detail/content_widgets.dart';

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
  bool _isBookmarked = false;

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
      }
      return;
    }

    final newProgress = (currentScroll / maxScroll).clamp(0.0, 1.0);
    if ((newProgress - _readingProgress).abs() > 0.01) {
      setState(() {
        _readingProgress = newProgress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final subjectColors = widget.lesson.subjectIndex != null
        ? design.subjectPalette.atIndex(widget.lesson.subjectIndex!)
        : null;

    return Container(
      color: design.colors.surface,
      child: Column(
        children: [
          // Sticky Top Navigation
          LessonDetailHeader(
            onBack: () => Navigator.of(context).pop(),
            isBookmarked: _isBookmarked,
            onBookmarkToggle: () =>
                setState(() => _isBookmarked = !_isBookmarked),
            onDownload: () {
              // Action handled by consumer or future sync logic
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
                      ...widget.lesson.content.map(_renderContentItem),

                      SizedBox(height: design.spacing.xxl),

                      // Sequential Navigation
                      LessonNavigationFooter(
                        onPrevious: widget.onPrevious,
                        onNext: widget.onNext,
                        hasPrevious: widget.onPrevious != null,
                        hasNext: widget.onNext != null,
                      ),

                      SizedBox(height: design.spacing.xxl),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Maps content domain models to their respective rendering widgets.
  Widget _renderContentItem(LessonContentItem item) {
    return switch (item) {
      HeadingContent() => LessonHeading(text: item.text, level: item.level),
      ParagraphContent() => LessonParagraph(text: item.text),
      ImageContent() => LessonImage(
        imageUrl: item.imageUrl,
        altText: item.altText,
      ),
      ListContent() => LessonList(
        items: item.items,
        bulletColor: widget.lesson.subjectIndex != null
            ? Design.of(
                context,
              ).subjectPalette.atIndex(widget.lesson.subjectIndex!).accent
            : null,
      ),
      CalloutContent() => LessonCallout(text: item.text, type: item.type),
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
        Divider(color: design.colors.divider, height: 1),
      ],
    );
  }
}
