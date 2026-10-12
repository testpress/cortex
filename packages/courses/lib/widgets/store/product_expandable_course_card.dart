import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/store_providers.dart';
import 'store_chapter_tile.dart';

class ProductExpandableCourseCard extends ConsumerStatefulWidget {
  final ProductCourseDto course;
  final VoidCallback? onBuyTap;
  final ValueChanged<LessonDto>? onPreviewTap;

  const ProductExpandableCourseCard({
    super.key,
    required this.course,
    this.onBuyTap,
    this.onPreviewTap,
  });

  @override
  ConsumerState<ProductExpandableCourseCard> createState() =>
      _ProductExpandableCourseCardState();
}

class _ProductExpandableCourseCardState
    extends ConsumerState<ProductExpandableCourseCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final course = widget.course;

    final chaptersAsync = _isExpanded
        ? ref.watch(storeCourseChaptersProvider(course.id.toString()))
        : null;

    final List<String> stats = [];
    if (course.chaptersCount > 0) {
      stats.add(L10n.of(context).storeStatisticsChapters(course.chaptersCount));
    }
    if (course.videosCount > 0) {
      stats.add(L10n.of(context).storeStatisticsVideos(course.videosCount));
    }
    if (course.examsCount > 0) {
      stats.add(L10n.of(context).storeStatisticsExams(course.examsCount));
    }
    if (course.attachmentsCount > 0) {
      stats.add(
          L10n.of(context).storeStatisticsAttachments(course.attachmentsCount));
    }
    if (course.htmlContentsCount > 0) {
      stats
          .add(L10n.of(context).storeStatisticsNotes(course.htmlContentsCount));
    }

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border.all(color: design.colors.border),
        borderRadius: BorderRadius.circular(design.spacing.sm),
      ),
      margin: EdgeInsets.only(bottom: design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSemantics.button(
            label: widget.course.title,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(design.spacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: AppText.cardTitle(widget.course.title),
                    ),
                    Icon(
                      _isExpanded
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: EdgeInsets.only(
                left: design.spacing.md,
                right: design.spacing.md,
                bottom: design.spacing.md,
              ),
              child:
                  _buildExpandedContent(context, design, chaptersAsync, stats),
            ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    DesignConfig design,
    AsyncValue<List<ChapterDto>>? chaptersAsync,
    List<String> stats,
  ) {
    if (chaptersAsync == null || chaptersAsync.isLoading) {
      return const StoreChapterContentsSkeleton(
        count: 3,
        showTrailing: true,
      );
    }

    if (chaptersAsync.hasError) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
        child: AppText.cardCaption(
          L10n.of(context).storeNoContentAvailable,
          color: design.colors.textSecondary,
        ),
      );
    }

    final allChapters = chaptersAsync.value ?? [];
    if (allChapters.isEmpty) {
      if (stats.isNotEmpty) {
        return Wrap(
          spacing: design.spacing.md,
          runSpacing: design.spacing.xs,
          children: stats
              .map((stat) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.checkCircle2,
                          size: design.iconSize.sm,
                          color: design.colors.primary),
                      SizedBox(width: design.spacing.xs),
                      AppText.cardSubtitle(stat),
                    ],
                  ))
              .toList(),
        );
      }
      return AppText.cardCaption(L10n.of(context).storeNoContentAvailable);
    }

    final rootChapters = allChapters
        .where((c) => c.parentId == null || c.parentId!.isEmpty)
        .toList();
    final displayChapters =
        rootChapters.isNotEmpty ? rootChapters : allChapters;
    final childrenMap = StoreChapterTile.buildChildrenMap(allChapters);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: displayChapters
          .map(
            (chapter) => StoreChapterTile(
              courseId: widget.course.id.toString(),
              chapter: chapter,
              childrenByParentId: childrenMap,
              onBuyTap: widget.onBuyTap,
              onPreviewTap: widget.onPreviewTap,
            ),
          )
          .toList(),
    );
  }
}
