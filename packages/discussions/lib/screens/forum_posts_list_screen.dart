import 'dart:async';
import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter/widgets.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/forum_providers.dart';
import '../widgets/forum_header.dart';

class ForumPostsListScreen extends ConsumerStatefulWidget {
  const ForumPostsListScreen({super.key});

  @override
  ConsumerState<ForumPostsListScreen> createState() => _ForumPostsListScreenState();
}

class _ForumPostsListScreenState extends ConsumerState<ForumPostsListScreen> {
  int? _selectedCategoryId;
  String? _searchQuery;
  Timer? _debounceTimer;

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
    final feedAsync = ref.watch(globalForumFeedProvider(
      categoryId: _selectedCategoryId,
      searchQuery: _searchQuery,
    ));
    final categoriesAsync = ref.watch(globalForumCategoriesProvider);

    return SkeletonizerConfig(
      data: SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: design.colors.skeleton,
          highlightColor: design.colors.onSkeleton,
          duration: MotionPreferences.duration(context, const Duration(milliseconds: 800)),
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: design.colors.card),
        child: Column(
        children: [
          ForumHeader(
            title: l10n.forumTitle,
            showDivider: false,
            actions: [
              AppFocusable(
                onTap: () {
                  context.push('/home/discussions/forum/create');
                },
                borderRadius: BorderRadius.circular(design.radius.full),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                  child: AppText.labelSmall(
                    l10n.forumCreatePost,
                    color: design.colors.accent2,
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
          _CategoryChips(
            categoriesAsync: categoriesAsync,
            selectedId: _selectedCategoryId,
            onCategorySelected: (id) {
              setState(() => _selectedCategoryId = id);
            },
          ),
          Expanded(
            child:            Builder(
              builder: (context) {
                final feedState = feedAsync.valueOrNull ?? const GlobalForumFeedState(items: []);
                final isLoading = feedAsync.isLoading && feedState.items.isEmpty;
                final displayState = isLoading 
                  ? feedState.copyWith(items: _mockSkeletonThreads) 
                  : feedState;
                
                if (feedAsync.hasError && feedState.items.isEmpty) {
                  return Center(child: AppText.body(l10n.errorGenericMessage));
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    children: [
                      Container(height: 1, color: design.colors.divider),
                      Expanded(
                        child: _ThreadList(
                          state: displayState,
                          onRefresh: () async {
                            return ref.refresh(globalForumFeedProvider(
                              categoryId: _selectedCategoryId,
                              searchQuery: _searchQuery,
                            ).future);
                          },
                          onLoadMore: () {
                            ref.read(globalForumFeedProvider(
                              categoryId: _selectedCategoryId,
                              searchQuery: _searchQuery,
                            ).notifier).loadMore();
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
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final AsyncValue<List<ForumCategoryDto>> categoriesAsync;
  final int? selectedId;
  final ValueChanged<int?> onCategorySelected;

  const _CategoryChips({
    required this.categoriesAsync,
    required this.selectedId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final categories = categoriesAsync.valueOrNull ?? [];
    final isLoading = categoriesAsync.isLoading && categories.isEmpty;
    final displayCategories = isLoading ? _mockSkeletonCategories : categories;

    if (categoriesAsync.hasError || (!isLoading && displayCategories.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: displayCategories.length + 1,
          separatorBuilder: (_, _) => SizedBox(width: design.spacing.sm),
          itemBuilder: (context, index) {
            if (index == 0) {
              return _ChipButton(
                label: L10n.of(context).filterAll,
                isSelected: selectedId == null,
                onTap: () => onCategorySelected(null),
              );
            }
            final category = displayCategories[index - 1];
            return _ChipButton(
              label: category.name,
              isSelected: selectedId == category.id,
              onTap: () => onCategorySelected(category.id),
            );
          },
        ),
      ),
    );
  }
}



class _ChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipButton({
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? design.colors.primary : design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.full),
          ),
          child: AppText.caption(
            label,
            color: isSelected ? design.colors.textInverse : design.colors.textPrimary,
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
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: widget.onRefresh,
          builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
            return Opacity(
              opacity: (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0),
              child: Center(
                child: AppLoadingIndicator(color: design.colors.primary),
              ),
            );
          },
        ),
        SliverList.separated(
          itemCount: widget.state.items.length + (widget.state.isLoadingMore ? 1 : 0),
          separatorBuilder: (context, index) => Container(
            height: 1,
            color: design.colors.divider,
          ),
          itemBuilder: (context, index) {
            if (index >= widget.state.items.length) {
              return Skeletonizer(
                enabled: true,
                child: _ThreadItem(
                  thread: _mockSkeletonThreads[index % _mockSkeletonThreads.length],
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

    return GestureDetector(
      onTap: () => context.push('/home/discussions/forum/posts/${thread.slug}', extra: thread),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.md,
        ),
        color: design.colors.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.cardTitle(
              thread.title,
              color: design.colors.textPrimary,
            ),
            if (thread.summary.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              AppText.cardSubtitle(
                thread.summary.trim(),
                color: design.colors.textSecondary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            _ThreadFooter(thread: thread),
          ],
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
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: isAnswered
              ? design.colors.accent2.withValues(alpha: 0.12)
              : design.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppText.caption(
          isAnswered ? l10n.forumLabelAnswered : l10n.forumLabelUnanswered,
          color: isAnswered ? design.colors.accent2 : design.colors.textSecondary,
          style: const TextStyle(fontSize: 10, height: 1.1, fontWeight: FontWeight.w600),
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

final _mockSkeletonCategories = List.generate(
  4,
  (i) => ForumCategoryDto(
    id: i,
    name: 'Category Name',
    slug: 'cat-$i',
    color: null,
    order: i,
  ),
);

final _mockSkeletonThreads = List.generate(
  5,
  (index) => ForumThreadDto(
    threadId: index,
    slug: 'slug-$index',
    title: 'Loading thread title placeholder...',
    summary: 'Loading thread summary placeholder that spans across multiple lines...',
    authorName: 'Author Name',
    createdAt: '2026-05-25T11:43:37Z',
    replyCount: 1,
    upvotes: 0,
    downvotes: 0,
    status: ForumThreadStatus.unanswered,
  ),
);
