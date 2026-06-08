import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart' show CupertinoSliverRefreshControl;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/announcement_list_item.dart';

/// Screen that displays a paginated list of all announcements (posts).
class AnnouncementsListScreen extends ConsumerStatefulWidget {
  const AnnouncementsListScreen({super.key});

  @override
  ConsumerState<AnnouncementsListScreen> createState() =>
      _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState
    extends ConsumerState<AnnouncementsListScreen> {
  final _scrollController = ScrollController();

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

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!ref.read(announcementsFetchingPageProvider)) {
        try {
          await ref.read(announcementsProvider.notifier).loadMore();
        } catch (_) {
          if (mounted) {
            AppToast.show(
              context,
              message: L10n.of(context).errorGenericMessage,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(announcementsProvider);
    final isFetchingNextPage = ref.watch(announcementsFetchingPageProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppShell(
      backgroundColor: design.colors.card,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border(bottom: BorderSide(color: design.colors.divider)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  design.spacing.screenPadding,
                  design.spacing.md,
                  design.spacing.screenPadding,
                  design.spacing.md,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 2,
                        ), // Optical alignment
                        child: Icon(
                          LucideIcons.arrowLeft,
                          color: design.colors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppText.title(
                        l10n.updatesAnnouncementsTitle,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: AppText.body(
                      l10n.noAnnouncementsFound,
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
                      onRefresh: () async {
                        return ref
                            .read(announcementsProvider.notifier)
                            .refresh();
                      },
                      builder:
                          (
                            context,
                            refreshState,
                            pulledExtent,
                            refreshTriggerPullDistance,
                            refreshIndicatorExtent,
                          ) {
                            return Opacity(
                              opacity:
                                  (pulledExtent / refreshTriggerPullDistance)
                                      .clamp(0.0, 1.0),
                              child: Center(
                                child: AppLoadingIndicator(
                                  color: design.colors.primary,
                                ),
                              ),
                            );
                          },
                    ),
                    SliverPadding(
                      padding: EdgeInsets.all(design.spacing.md),
                      sliver: SliverList.builder(
                        itemCount: posts.length + (isFetchingNextPage ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == posts.length) {
                            return SkeletonizerConfig(
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
                              child: Skeletonizer(
                                enabled: true,
                                child: AnnouncementListItem(
                                  post: PostDto(
                                    id: 99999,
                                    title: 'Loading announcement title here',
                                    summary:
                                        'Loading announcement summary goes here and it might be long',
                                    publishedDate: DateTime.now()
                                        .toIso8601String(),
                                    categoryId: 0,
                                    slug: '',
                                    allowComments: false,
                                    contentHtml: '',
                                    shortLink: '',
                                  ),
                                ),
                              ),
                            );
                          }
                          return Column(
                            children: [
                              AnnouncementListItem(post: posts[index]),
                              Container(
                                height: 1,
                                margin: EdgeInsets.only(
                                  top: design.spacing.sm,
                                  bottom: design.spacing.sm,
                                ),
                                color: design.colors.border,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
              loading: () => SkeletonizerConfig(
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
                child: Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.all(design.spacing.md),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          AnnouncementListItem(
                            post: PostDto(
                              id: index,
                              title: 'Loading announcement title here',
                              summary:
                                  'Loading announcement summary goes here and it might be long',
                              publishedDate: DateTime.now().toIso8601String(),
                              categoryId: 0,
                              slug: '',
                              allowComments: false,
                              contentHtml: '',
                              shortLink: '',
                            ),
                          ),
                          Container(
                            height: 1,
                            margin: EdgeInsets.only(
                              top: design.spacing.sm,
                              bottom: design.spacing.sm,
                            ),
                            color: design.colors.border,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              error: (error, stack) => Center(
                child: AppErrorView(
                  message: error.toString(),
                  onRetry: () =>
                      ref.read(announcementsProvider.notifier).refresh(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
