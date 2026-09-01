import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'widgets/announcement_list_item.dart';
import 'widgets/announcement_filter_bar.dart';
import 'widgets/announcement_filter_sheet.dart';

/// Screen that displays a paginated list of all announcements (posts).
///
/// If [AppConfig.showQuickLinks] is enabled:
/// - Displays category filter chips and a filter modal sheet.
/// - Supports [initialCategory] to open pre-filtered to that category.
class AnnouncementsListScreen extends ConsumerStatefulWidget {
  const AnnouncementsListScreen({super.key, this.initialCategory});

  final PostCategoryDto? initialCategory;

  @override
  ConsumerState<AnnouncementsListScreen> createState() =>
      _AnnouncementsListScreenState();
}

class _AnnouncementsListScreenState
    extends ConsumerState<AnnouncementsListScreen> {
  final _scrollController = ScrollController();
  PostCategoryDto? _selectedCategory;
  bool _isFilterSheetOpen = false;

  bool get _isFilterEnabled => AppConfig.showQuickLinks;
  bool get _isFiltered => _isFilterEnabled && _selectedCategory != null;

  @override
  void initState() {
    super.initState();
    if (_isFilterEnabled) {
      _selectedCategory = widget.initialCategory;
    }
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
      if (_isFiltered) {
        if (!ref.read(categoryPostsFetchingPageProvider)) {
          try {
            await ref
                .read(categoryPostsProvider(_selectedCategory!.slug).notifier)
                .loadMore();
          } catch (e, stack) {
            _handleError(e, stack);
          }
        }
      } else {
        if (!ref.read(announcementsFetchingPageProvider)) {
          try {
            await ref.read(announcementsProvider.notifier).loadMore();
          } catch (e, stack) {
            _handleError(e, stack);
          }
        }
      }
    }
  }

  void _handleError(Object e, StackTrace stack) {
    ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
    if (mounted) {
      AppToast.show(context, message: L10n.of(context).errorGenericMessage);
    }
  }

  Future<void> _refresh() async {
    if (_isFiltered) {
      return ref
          .read(categoryPostsProvider(_selectedCategory!.slug).notifier)
          .refresh();
    } else {
      return ref.read(announcementsProvider.notifier).refresh();
    }
  }

  void _selectCategory(PostCategoryDto? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Watch appropriate data stream based on filter state
    final AsyncValue<List<PostDto>> postsState;
    final bool isFetchingNextPage;

    if (_isFiltered) {
      postsState = ref.watch(categoryPostsProvider(_selectedCategory!.slug));
      isFetchingNextPage = ref.watch(categoryPostsFetchingPageProvider);
    } else {
      postsState = ref.watch(announcementsProvider);
      isFetchingNextPage = ref.watch(announcementsFetchingPageProvider);
    }

    // Categories for filter UI (only watched if filter enabled)
    final categoriesAsync = _isFilterEnabled
        ? ref.watch(postCategoriesProvider)
        : null;
    final categoriesList = categoriesAsync?.value ?? const <PostCategoryDto>[];

    return AppShell(
      backgroundColor: design.colors.card,
      child: Stack(
        children: [
          Column(
            children: [
              AppHeader(
                title: l10n.updatesAnnouncementsTitle,
                showDivider: false,
                leading: AppBackButton(onTap: () => context.pop()),
                actions: [
                  if (_isFilterEnabled && categoriesList.isNotEmpty)
                    AppSemantics.button(
                      label: l10n.announcementsFilterAction,
                      onTap: () => setState(() => _isFilterSheetOpen = true),
                      child: AppFocusable(
                        padding: const EdgeInsets.all(13),
                        onTap: () => setState(() => _isFilterSheetOpen = true),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              LucideIcons.filter,
                              color: _isFiltered
                                  ? design.colors.primary
                                  : design.colors.textPrimary,
                              size: 20,
                            ),
                            if (_isFiltered)
                              Positioned(
                                top: -2,
                                right: -2,
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

              // Active Filter Pill (only shown when a category filter is active)
              if (_isFilterEnabled && _isFiltered)
                AnnouncementFilterBar(
                  selectedCategory: _selectedCategory,
                  onClear: () => _selectCategory(null),
                  onOpenFilterSheet: () =>
                      setState(() => _isFilterSheetOpen = true),
                ),

              Expanded(
                child: postsState.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return AppRefreshIndicator(
                        onRefresh: _refresh,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: AppText.body(
                                  l10n.noAnnouncementsFound,
                                  color: design.colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return AppRefreshIndicator(
                      onRefresh: _refresh,
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.all(design.spacing.md),
                            sliver: SliverList.builder(
                              itemCount:
                                  posts.length + (isFetchingNextPage ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == posts.length) {
                                  return SkeletonizerConfig(
                                    data: SkeletonizerConfigData(
                                      effect: ShimmerEffect(
                                        baseColor: design.colors.skeleton,
                                        highlightColor:
                                            design.colors.onSkeleton,
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
                                          title:
                                              'Loading announcement title here',
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
                      ),
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
                                  publishedDate: DateTime.now()
                                      .toIso8601String(),
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
                    child: AppErrorView(error: error, onRetry: _refresh),
                  ),
                ),
              ),
            ],
          ),

          // Filter Bottom Sheet (Only when filter enabled)
          if (_isFilterEnabled)
            AppBottomSheet(
              isOpen: _isFilterSheetOpen,
              onClose: () => setState(() => _isFilterSheetOpen = false),
              child: AnnouncementFilterSheet(
                categories: categoriesList,
                selectedCategory: _selectedCategory,
                onApply: (cat) {
                  _selectCategory(cat);
                  setState(() => _isFilterSheetOpen = false);
                },
                onClose: () => setState(() => _isFilterSheetOpen = false),
              ),
            ),
        ],
      ),
    );
  }
}
