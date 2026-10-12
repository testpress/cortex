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
  final List<ChapterDto> allChapters;
  final int depth;
  final VoidCallback? onBuyTap;

  const StoreChapterTile({
    super.key,
    required this.courseId,
    required this.chapter,
    required this.allChapters,
    this.depth = 0,
    this.onBuyTap,
  });

  @override
  ConsumerState<StoreChapterTile> createState() => _StoreChapterTileState();
}

class _StoreChapterTileState extends ConsumerState<StoreChapterTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final chapter = widget.chapter;

    // Find children chapters if this is a parent folder
    final childChapters =
        widget.allChapters.where((c) => c.parentId == chapter.id).toList();
    final hasChildren = childChapters.isNotEmpty;
    final isLeaf = chapter.isLeaf && !hasChildren;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Chapter Header Tile
        AppSemantics.button(
          label: chapter.title,
          child: AppFocusable(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(design.radius.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
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

        // Expanded Body
        if (_isExpanded) ...[
          if (!isLeaf && hasChildren)
            ...childChapters.map(
              (child) => StoreChapterTile(
                courseId: widget.courseId,
                chapter: child,
                allChapters: widget.allChapters,
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

  Widget _buildContentsList(BuildContext context, dynamic design) {
    final l10n = L10n.of(context);
    final contentsAsync = ref.watch(
      storeChapterContentsProvider(widget.courseId, widget.chapter.id),
    );

    return contentsAsync.when(
      loading: () => Padding(
        padding: EdgeInsets.only(
          left: ((widget.depth + 1) * design.spacing.md).toDouble(),
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
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: design.colors.skeleton,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  Expanded(
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: design.colors.skeleton,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    dynamic design,
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
