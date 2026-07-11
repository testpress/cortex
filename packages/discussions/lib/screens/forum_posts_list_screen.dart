import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_filter_bottom_sheet.dart';
import '../widgets/forum_header.dart';

class ForumPostsListScreen extends ConsumerStatefulWidget {
  const ForumPostsListScreen({super.key});

  @override
  ConsumerState<ForumPostsListScreen> createState() =>
      _ForumPostsListScreenState();
}

class _ForumPostsListScreenState extends ConsumerState<ForumPostsListScreen> {
  int? _selectedCategoryId;
  ForumActivityFilter? _selectedActivityFilter;
  ForumSort _selectedSortOrder = ForumSort.recent;
  String? _searchQuery;
  Timer? _debounceTimer;
  bool _isFilterSheetOpen = false;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().isEmpty ? null : query.trim();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final feedAsync = ref.watch(
      globalForumFeedProvider(
        categoryId: _selectedCategoryId,
        searchQuery: _searchQuery,
        activityFilter: _selectedActivityFilter,
        sortOrder: _selectedSortOrder,
      ),
    );
    final categoriesAsync = ref.watch(globalForumCategoriesProvider);

    final hasFilters = _selectedActivityFilter != null;

    void handleCreatePost() => context.push('/home/discussions/forum/create');

    return Stack(
      children: [
        Container(
          color: design.colors.surface,
          child: SkeletonizerConfig(
            data: SkeletonizerConfigData(
              effect: ShimmerEffect(
                baseColor: design.colors.skeleton,
                highlightColor: design.colors.onSkeleton,
                duration: MotionPreferences.duration(
                  context,
                  const Duration(milliseconds: 800),
                ),
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(color: design.colors.card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ForumHeader(
                    title: l10n.forumTitle,
                    showDivider: false,
                    actions: [
                      AppSemantics.button(
                        label: l10n.forumFilterSemantic,
                        onTap: () {
                          setState(() => _isFilterSheetOpen = true);
                        },
                        child: AppFocusable(
                          padding: const EdgeInsets.all(13),
                          onTap: () {
                            setState(() => _isFilterSheetOpen = true);
                          },
                          child: Stack(
                            children: [
                              Icon(
                                LucideIcons.filter,
                                color: design.colors.textPrimary,
                                size: 22,
                              ),
                              if (hasFilters)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: design.colors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                    child: AppSearchBar(
                      hintText: l10n.forumSearchDiscussions,
                      onChanged: _onSearchChanged,
                      backgroundColor: design.colors.surfaceVariant,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: design.spacing.md,
                      right: design.spacing.md,
                      bottom: design.spacing.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _SegmentButton(
                            label: l10n.forumSortRecent,
                            isSelected: _selectedSortOrder == ForumSort.recent,
                            onTap: () => setState(
                              () => _selectedSortOrder = ForumSort.recent,
                            ),
                          ),
                        ),
                        SizedBox(width: design.spacing.sm),
                        Expanded(
                          child: _SegmentButton(
                            label: l10n.forumSortMostLiked,
                            isSelected:
                                _selectedSortOrder == ForumSort.mostLiked,
                            onTap: () => setState(
                              () => _selectedSortOrder = ForumSort.mostLiked,
                            ),
                          ),
                        ),
                        SizedBox(width: design.spacing.sm),
                        Expanded(
                          child: _SegmentButton(
                            label: l10n.forumSortMostViewed,
                            isSelected:
                                _selectedSortOrder == ForumSort.mostViewed,
                            onTap: () => setState(
                              () => _selectedSortOrder = ForumSort.mostViewed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 36,
                    margin: EdgeInsets.only(bottom: design.spacing.sm),
                    child: categoriesAsync.when(
                      data: (categories) {
                        return ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.md,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length + 1,
                          separatorBuilder: (a, b) =>
                              SizedBox(width: design.spacing.sm),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _CategoryChip(
                                label: l10n.filterAll,
                                isSelected: _selectedCategoryId == null,
                                onTap: () =>
                                    setState(() => _selectedCategoryId = null),
                              );
                            }
                            final cat = categories[index - 1];
                            return _CategoryChip(
                              label: cat.name,
                              isSelected: _selectedCategoryId == cat.id,
                              onTap: () =>
                                  setState(() => _selectedCategoryId = cat.id),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: AppLoadingIndicator()),
                      error: (err, stack) => const SizedBox(),
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final feedState =
                            feedAsync.valueOrNull ??
                            const GlobalForumFeedState(items: []);
                        final isLoading =
                            feedAsync.isLoading && feedState.items.isEmpty;
                        final displayState = isLoading
                            ? feedState.copyWith(items: _mockSkeletonThreads)
                            : feedState;

                        if (feedAsync.hasError && feedState.items.isEmpty) {
                          return Center(
                            child: AppText.body(l10n.errorGenericMessage),
                          );
                        }

                        return Skeletonizer(
                          enabled: isLoading,
                          child: Column(
                            children: [
                              Container(height: 1, color: design.colors.border),
                              Expanded(
                                child: _ThreadList(
                                  state: displayState,
                                  onRefresh: () async {
                                    return ref.refresh(
                                      globalForumFeedProvider(
                                        categoryId: _selectedCategoryId,
                                        searchQuery: _searchQuery,
                                        activityFilter: _selectedActivityFilter,
                                        sortOrder: _selectedSortOrder,
                                      ).future,
                                    );
                                  },
                                  onLoadMore: () {
                                    ref
                                        .read(
                                          globalForumFeedProvider(
                                            categoryId: _selectedCategoryId,
                                            searchQuery: _searchQuery,
                                            activityFilter:
                                                _selectedActivityFilter,
                                            sortOrder: _selectedSortOrder,
                                          ).notifier,
                                        )
                                        .loadMore();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // FAB Replacement
        Positioned(
          bottom: design.spacing.lg + MediaQuery.of(context).padding.bottom,
          right: design.spacing.lg,
          child: AppSemantics.button(
            label: l10n.forumCreatePost,
            child: AppFocusable(
              onTap: handleCreatePost,
              borderRadius: BorderRadius.circular(design.radius.full),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: design.colors.primary,
                  shape: BoxShape.circle,
                  boxShadow: design.shadows.floating,
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.plus,
                    color: design.colors.textInverse,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom Sheet
        AppBottomSheet(
          isOpen: _isFilterSheetOpen,
          onClose: () => setState(() => _isFilterSheetOpen = false),
          child: ForumFilterBottomSheet(
            initialActivityFilter: _selectedActivityFilter,
            onApply: (activityFilter) {
              setState(() {
                _selectedActivityFilter = activityFilter;
              });
            },
            onClose: () => setState(() => _isFilterSheetOpen = false),
          ),
        ),
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bgColor = isSelected
        ? design.colors.primary
        : design.colors.surfaceVariant;
    final fgColor = isSelected
        ? design.colors.textInverse
        : design.colors.textPrimary;

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(design.radius.lg),
              border: isSelected
                  ? null
                  : Border.all(color: design.colors.border),
            ),
            child: Center(
              child: AppText.caption(
                label,
                color: fgColor,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.full),
        child: AnimatedContainer(
          duration: MotionPreferences.duration(context, design.motion.fast),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? design.colors.primary
                : design.colors.surfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(design.radius.full),
            border: isSelected ? null : Border.all(color: design.colors.border),
          ),
          child: Center(
            child: AppText.caption(
              label.toUpperCase(),
              color: isSelected
                  ? design.colors.textInverse
                  : design.colors.textPrimary,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThreadList extends StatefulWidget {
  final GlobalForumFeedState state;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const _ThreadList({
    required this.state,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  State<_ThreadList> createState() => _ThreadListState();
}

class _ThreadListState extends State<_ThreadList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (!widget.state.isLoadingMore && widget.state.hasMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (widget.state.items.isEmpty) {
      return Center(
        child: AppText.body(
          l10n.forumNoDiscussions,
          color: design.colors.textSecondary,
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
          builder:
              (
                context,
                refreshState,
                pulledExtent,
                refreshTriggerPullDistance,
                refreshIndicatorExtent,
              ) {
                return Opacity(
                  opacity: (pulledExtent / refreshTriggerPullDistance).clamp(
                    0.0,
                    1.0,
                  ),
                  child: Center(
                    child: AppLoadingIndicator(color: design.colors.primary),
                  ),
                );
              },
        ),
        SliverList.separated(
          itemCount:
              widget.state.items.length + (widget.state.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) =>
              Container(height: 1, color: design.colors.border),
          itemBuilder: (context, index) {
            if (index >= widget.state.items.length) {
              return Skeletonizer(
                enabled: true,
                child: _ThreadItem(
                  thread:
                      _mockSkeletonThreads[index % _mockSkeletonThreads.length],
                ),
              );
            }
            return _ThreadItem(thread: widget.state.items[index]);
          },
        ),
      ],
    );
  }
}

class _ThreadItem extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadItem({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: thread.title,
      onTap: () => context.push(
        '/home/discussions/forum/posts/${thread.slug}',
        extra: thread,
      ),
      child: AppFocusable(
        onTap: () => context.push(
          '/home/discussions/forum/posts/${thread.slug}',
          extra: thread,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.cardTitle(thread.title, color: design.colors.textPrimary),
              if (thread.summary.trim().isNotEmpty) ...[
                const SizedBox(height: 6),
                AppText.cardSubtitle(
                  thread.summary.trim(),
                  color: design.colors.textSecondary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: design.spacing.sm + 4),
              _ThreadFooter(thread: thread),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadFooter extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadFooter({required this.thread});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ThreadAuthorMeta(thread: thread),
        _ThreadStats(thread: thread),
      ],
    );
  }
}

class _ThreadAuthorMeta extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadAuthorMeta({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Expanded(
      child: Row(
        children: [
          Flexible(
            child: AppText.caption(
              thread.authorName,
              color: design.colors.textPrimary,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
            child: AppText.caption('·', color: design.colors.textSecondary),
          ),
          AppText.caption(
            _formatDateSafe(thread.createdAt),
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _ThreadStats extends StatelessWidget {
  final ForumThreadDto thread;

  const _ThreadStats({required this.thread});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      children: [
        Icon(
          LucideIcons.messageSquare,
          size: 14,
          color: design.colors.textSecondary,
        ),
        const SizedBox(width: 4),
        AppText.caption(
          '${thread.replyCount}',
          color: design.colors.textSecondary,
        ),
        const SizedBox(width: 10),
        _StatusBadge(status: thread.status),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ForumThreadStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isAnswered = status == ForumThreadStatus.answered;

    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isAnswered
              ? design.colors.accent2.withValues(alpha: 0.12)
              : design.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppText.caption(
          isAnswered ? l10n.forumLabelAnswered : l10n.forumLabelUnanswered,
          color: isAnswered
              ? design.colors.accent2
              : design.colors.textSecondary,
          style: const TextStyle(
            fontSize: 10,
            height: 1.1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

String _formatDateSafe(String dateStr) {
  if (dateStr.isEmpty) return '';
  final dt = DateTime.tryParse(dateStr);
  if (dt != null) {
    return DateFormatter.formatDateTime(dt.toLocal());
  }
  return dateStr;
}

final _mockSkeletonThreads = List.generate(
  5,
  (index) => ForumThreadDto(
    threadId: index,
    slug: 'slug-$index',
    title: 'Loading thread title placeholder...',
    summary:
        'Loading thread summary placeholder that spans across multiple lines...',
    authorName: 'Author Name',
    createdAt: '2026-05-25T11:43:37Z',
    replyCount: 1,
    upvotes: 0,
    downvotes: 0,
    status: ForumThreadStatus.unanswered,
  ),
);
