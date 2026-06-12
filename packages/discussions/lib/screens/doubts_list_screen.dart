import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../widgets/forum_header.dart';

class DoubtsListScreen extends ConsumerStatefulWidget {
  const DoubtsListScreen({super.key});

  @override
  ConsumerState<DoubtsListScreen> createState() => _DoubtsListScreenState();
}

class _DoubtsListScreenState extends ConsumerState<DoubtsListScreen> {
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchQuery != null && _searchQuery!.isNotEmpty;

    final doubtsAsync = isSearching
        ? ref.watch(doubtsSearchProvider(_searchQuery!))
        : ref.watch(doubtsListProvider);
    final syncAsync = ref.watch(doubtsSyncProvider);
    final syncNotifier = ref.read(doubtsSyncProvider.notifier);

    // Fire-and-forget sync for topics.
    ref.watch(doubtTopicsSyncProvider);

    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.surface,
      child: Column(
        children: [
          Container(
            color: design.colors.card,
            child: Column(
              children: [
                if (doubtsAsync.valueOrNull?.isEmpty == true &&
                    !syncAsync.isLoading &&
                    !isSearching)
                  AppHeader(
                    title: l10n.drawerDoubts,
                    subtitle: l10n.doubtsEmptySubtitle,
                  )
                else
                  ForumHeader(
                    title: l10n.drawerDoubts,
                    showDivider: false,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          context.push('/home/discussions/doubts/ask');
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.sm,
                          ),
                          child: AppText.labelSmall(
                            l10n.doubtsHeaderAskDoubt,
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
                    hintText: l10n.doubtsSearchHint,
                    onSubmitted: (query) {
                      setState(() {
                        _searchQuery = query.trim().isEmpty
                            ? null
                            : query.trim();
                      });
                    },
                    backgroundColor: design.colors.surfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: design.colors.divider),
          Expanded(
            child: doubtsAsync.when(
              data: (doubts) {
                // Show skeleton only if initial sync is still loading AND database is empty
                final isInitialLoading =
                    !isSearching && syncAsync.isLoading && doubts.isEmpty;
                final syncState = syncAsync.valueOrNull;
                final isLoadingMore =
                    !isSearching && (syncState?.isLoadingMore ?? false);
                final hasMore = !isSearching && (syncState?.hasMore ?? true);

                return doubts.isEmpty && !isInitialLoading
                    ? _buildEmptyState(context, design, ref)
                    : _DoubtsBody(
                        doubts: isInitialLoading ? _dummyDoubts : doubts,
                        isInitialLoading: isInitialLoading,
                        isLoadingMore: isLoadingMore,
                        hasMore: hasMore,
                        onLoadMore: () => syncNotifier.loadMore(),
                        onRefresh: () async {
                          return ref.refresh(doubtsSyncProvider.future);
                        },
                      );
              },
              loading: () => _DoubtsBody(
                doubts: _dummyDoubts,
                isInitialLoading: true,
                isLoadingMore: false,
                hasMore: false,
                onLoadMore: () {},
                onRefresh: () async {},
              ),
              error: (err, stack) => Center(
                child: AppErrorView(
                  message: l10n.errorGenericMessage,
                  onRetry: () {
                    ref.invalidate(doubtsListProvider);
                    ref.invalidate(doubtsSyncProvider);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    DesignConfig design,
    WidgetRef ref,
  ) {
    final l10n = L10n.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.messageSquare,
            size: 80,
            color: design.colors.textTertiary.withValues(alpha: 0.2),
          ),
          SizedBox(height: design.spacing.lg),
          AppText.headline(
            l10n.doubtsEmptyTitle,
            color: design.colors.textSecondary,
          ),
          SizedBox(height: design.spacing.xs),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: design.spacing.xl),
            child: AppText.body(
              l10n.doubtsEmptySubtitle,
              color: design.colors.textTertiary,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: design.spacing.xl),
          AppButton.primary(
            label: l10n.doubtsHeaderAskDoubt,
            leading: const Icon(
              LucideIcons.plus,
              size: 20,
              color: Color(0xFFFFFFFF),
            ),
            onPressed: () {
              context.push('/home/discussions/doubts/ask');
            },
          ),
        ],
      ),
    );
  }
}

final List<DoubtDto> _dummyDoubts = List.generate(
  5,
  (index) => DoubtDto(
    id: 'dummy_$index',
    title: 'Loading your doubts and queries',
    content: 'Loading content description placeholder text',
    studentName: 'Student Name',
    status: DoubtStatus.pending,
    createdAt: DateTime.now(),
    topicId: index,
    topicName: 'Course Name Placeholder',
  ),
);

class _DoubtsBody extends StatefulWidget {
  final List<DoubtDto> doubts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback onLoadMore;
  final Future<void> Function() onRefresh;

  const _DoubtsBody({
    required this.doubts,
    required this.isInitialLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.onLoadMore,
    required this.onRefresh,
  });

  @override
  State<_DoubtsBody> createState() => _DoubtsBodyState();
}

class _DoubtsBodyState extends State<_DoubtsBody> {
  final _scrollController = ScrollController();

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
      if (!widget.isLoadingMore && widget.hasMore) {
        widget.onLoadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

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
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          sliver: SliverSkeletonizer(
            enabled: widget.isInitialLoading,
            child: SliverList.separated(
              itemCount: widget.doubts.length + (widget.isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => SizedBox(height: design.spacing.xs),
              itemBuilder: (context, index) {
                if (index >= widget.doubts.length) {
                  return Skeletonizer(
                    enabled: true,
                    child: _DoubtItem(
                      doubt: _dummyDoubts[index % _dummyDoubts.length],
                    ),
                  );
                }
                return _DoubtItem(doubt: widget.doubts[index]);
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }
}

class _DoubtItem extends StatelessWidget {
  final DoubtDto doubt;

  const _DoubtItem({required this.doubt});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      onTap: () {
        context.push('/home/discussions/doubts/${doubt.id}');
      },
      padding: EdgeInsets.all(design.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title (Bold cardTitle)
          AppText.cardTitle(
            doubt.title,
            color: design.colors.textPrimary,
            maxLines: 2,
          ),
          SizedBox(height: design.spacing.sm),
          // Metadata Row: Subject • Replies • Time
          Row(
            children: [
              if (doubt.topicName != null) ...[
                AppText.labelSmall(
                  doubt.topicName!,
                  color: design.colors.accent2,
                ),
                _buildDot(design),
              ],
              AppText.caption(
                doubt.createdHumanized ??
                    DateFormatter.formatTimeAgo(doubt.createdAt),
                color: design.colors.textTertiary,
              ),
            ],
          ),
          // Status badge — shown for all statuses
          SizedBox(height: design.spacing.sm),
          _buildStatusBadge(design, doubt.status),
        ],
      ),
    );
  }

  Widget _buildDot(DesignConfig design) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.xs),
      child: AppText.caption('•', color: design.colors.textTertiary),
    );
  }

  Widget _buildStatusBadge(DesignConfig design, DoubtStatus status) {
    final Color color;

    switch (status) {
      case DoubtStatus.active:
        color = design.colors.accent2;
        break;
      case DoubtStatus.resolved:
        color = design.colors.success;
        break;
      case DoubtStatus.pending:
        color = design.colors.warning;
        break;
      case DoubtStatus.closed:
        color = design.colors.error;
        break;
    }

    final label = '${status.name[0].toUpperCase()}${status.name.substring(1)}';

    return Skeleton.leaf(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: AppText.labelSmall(
          label,
          color: color,
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
