import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/store_providers.dart';
import 'store_content_tile.dart';

/// Chapter tree node that recursively renders nested sub-chapters or chapter contents.
class StoreChapterTile extends ConsumerStatefulWidget {
  final String courseId;
  final ChapterDto chapter;
  final List<ChapterDto>? allChapters;
  final Map<String, List<ChapterDto>>? childrenByParentId;
  final int depth;
  final VoidCallback? onBuyTap;

  const StoreChapterTile({
    super.key,
    required this.courseId,
    required this.chapter,
    this.allChapters,
    this.childrenByParentId,
    this.depth = 0,
    this.onBuyTap,
  });

  /// Builds a parentId -> `List<ChapterDto>` map once for O(1) child lookups.
  static Map<String, List<ChapterDto>> buildChildrenMap(
    List<ChapterDto> chapters,
  ) {
    final map = <String, List<ChapterDto>>{};
    for (final c in chapters) {
      final pid = c.parentId;
      if (pid != null && pid.isNotEmpty) {
        (map[pid] ??= []).add(c);
      }
    }
    return map;
  }

  @override
  ConsumerState<StoreChapterTile> createState() => _StoreChapterTileState();
}

class _StoreChapterTileState extends ConsumerState<StoreChapterTile> {
  bool _isExpanded = false;
  late Map<String, List<ChapterDto>> _childrenMap;

  @override
  void initState() {
    super.initState();
    _childrenMap = widget.childrenByParentId ??
        (widget.allChapters != null
            ? StoreChapterTile.buildChildrenMap(widget.allChapters!)
            : const {});
  }

  @override
  void didUpdateWidget(StoreChapterTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.childrenByParentId != oldWidget.childrenByParentId ||
        widget.allChapters != oldWidget.allChapters) {
      _childrenMap = widget.childrenByParentId ??
          (widget.allChapters != null
              ? StoreChapterTile.buildChildrenMap(widget.allChapters!)
              : const {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final chapter = widget.chapter;

    // Find children chapters via pre-built map (O(1))
    final childChapters = _childrenMap[chapter.id] ?? const [];
    final hasChildren = childChapters.isNotEmpty;
    final isLeaf = chapter.isLeaf && !hasChildren;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chapter Header Tile
        Semantics(
          expanded: _isExpanded,
          child: AppSemantics.button(
            label: chapter.title,
            child: AppFocusable(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(design.radius.sm),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(minHeight: kMinTouchTargetSize),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: (widget.depth * design.spacing.md).toDouble(),
                    top: design.spacing.md,
                    bottom: design.spacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isExpanded
                            ? LucideIcons.chevronDown
                            : LucideIcons.chevronRight,
                        size: design.iconSize.sm,
                        color: design.colors.textPrimary,
                      ),
                      SizedBox(width: design.spacing.sm),
                      Expanded(
                        child: AppText.cardTitle(
                          chapter.title,
                          color: design.colors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Expanded Body
        if (_isExpanded) ...[
          if (!isLeaf && hasChildren)
            ...childChapters.map(
              (child) => StoreChapterTile(
                courseId: widget.courseId,
                chapter: child,
                childrenByParentId: _childrenMap,
                depth: widget.depth + 1,
                onBuyTap: widget.onBuyTap,
              ),
            )
          else
            _buildContentsList(context, design),
        ],
      ],
    );
  }

  Widget _buildContentsList(BuildContext context, DesignConfig design) {
    final l10n = L10n.of(context);
    final contentsAsync = ref.watch(
      storeChapterContentsProvider(widget.courseId, widget.chapter.id),
    );

    return contentsAsync.when(
      loading: () => StoreChapterContentsSkeleton(depth: widget.depth + 1),
      error: (err, _) => Padding(
        padding: EdgeInsets.only(
          left: ((widget.depth + 1) * design.spacing.md).toDouble(),
          top: design.spacing.xs,
          bottom: design.spacing.xs,
        ),
        child: AppText.caption(
          l10n.storeFailedToLoadContents,
          color: design.colors.textSecondary,
        ),
      ),
      data: (contents) => _buildContentsColumn(context, design, contents),
    );
  }

  Widget _buildContentsColumn(
    BuildContext context,
    DesignConfig design,
    List<LessonDto> contents,
  ) {
    final l10n = L10n.of(context);
    if (contents.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(
          left: ((widget.depth + 1) * design.spacing.md).toDouble(),
          top: design.spacing.xs,
          bottom: design.spacing.xs,
        ),
        child: AppText.caption(
          l10n.storeNoContentAvailable,
          color: design.colors.textSecondary,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: contents.map((c) {
        return Padding(
          padding: EdgeInsets.only(
            left: ((widget.depth + 1) * design.spacing.md).toDouble(),
          ),
          child: StoreContentTile(
            content: c,
            onBuyTap: widget.onBuyTap,
          ),
        );
      }).toList(),
    );
  }
}

/// Loading skeleton for chapter contents/lessons.
class StoreChapterContentsSkeleton extends StatelessWidget {
  final int depth;

  const StoreChapterContentsSkeleton({
    super.key,
    required this.depth,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: (depth * design.spacing.md).toDouble(),
        top: design.spacing.xs,
        bottom: design.spacing.xs,
      ),
      child: Column(
        children: List.generate(
          2,
          (_) => Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
            child: Row(
              children: [
                Container(
                  width: design.spacing.md,
                  height: design.spacing.md,
                  decoration: BoxDecoration(
                    color: design.colors.skeleton,
                    borderRadius: BorderRadius.circular(design.radius.sm),
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: design.colors.skeleton,
                      borderRadius: BorderRadius.circular(design.radius.sm),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
