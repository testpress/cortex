import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../providers/explore_providers.dart';
import '../../widgets/explore/featured_carousel.dart';
import '../../widgets/explore/quick_access_filter.dart';
import '../../widgets/explore/course_discovery_list.dart';
import '../../widgets/explore/short_lessons_section.dart';
import '../../widgets/explore/popular_tests_section.dart';
import '../../widgets/explore/study_tips_list.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter;
  final GlobalKey _trendingKey = GlobalKey();
  final GlobalKey _recommendedKey = GlobalKey();
  final GlobalKey _shortLessonsKey = GlobalKey();
  final GlobalKey _popularKey = GlobalKey();
  final GlobalKey _studyTipsKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToSection(String filter) {
    final l10n = L10n.of(context);
    GlobalKey? targetKey;

    if (filter == l10n.exploreFilterTrending) {
      targetKey = _trendingKey;
    } else if (filter == l10n.exploreFilterRecommended) {
      targetKey = _recommendedKey;
    } else if (filter == l10n.exploreFilterShortLessons) {
      targetKey = _shortLessonsKey;
    } else if (filter == l10n.exploreFilterPopular) {
      targetKey = _popularKey;
    } else if (filter == l10n.exploreFilterStudyTips) {
      targetKey = _studyTipsKey;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    _selectedFilter ??= l10n.exploreFilterTrending;

    final bannersAsync = ref.watch(exploreBannersProvider);
    final discoveryCoursesAsync = ref.watch(filteredDiscoveryCoursesProvider);
    final shortLessonsAsync = ref.watch(filteredShortLessonsProvider);
    final popularTestsAsync = ref.watch(filteredPopularTestsProvider);
    final studyTipsAsync = ref.watch(filteredStudyTipsProvider);
    final searchQuery = ref.watch(exploreSearchQueryProvider);

    return Column(
      children: [
        // Header Section (Active UI with Search and Filters)
        Container(
          color: design.colors.card,
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Search Section
              Padding(
                padding: EdgeInsets.fromLTRB(
                  design.spacing.md,
                  design.spacing.md,
                  design.spacing.md,
                  design.spacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText.lg(
                          l10n.exploreTabTitle,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    SizedBox(height: design.spacing.md),
                    AppSearchBar(
                      controller: _searchController,
                      hintText: l10n.exploreSearchHint,
                      backgroundColor: design.colors.surface,
                      onChanged: (value) {
                        ref
                            .read(exploreSearchQueryProvider.notifier)
                            .update(value);
                      },
                    ),
                  ],
                ),
              ),

              // Category Chips
              QuickAccessFilter(
                selectedFilter: _selectedFilter!,
                onFilterSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                  _scrollToSection(filter);
                },
              ),
            ],
          ),
        ),

        // Content Section
        Expanded(
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
              ignoreContainers: false,
            ),
            child: Container(
              color: design.colors.canvas,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: design.spacing.md)),

                  // 1. Featured Banners
                  if (searchQuery.isEmpty) ...[
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          FeaturedCarousel(
                            banners: bannersAsync.valueOrNull ?? [],
                            isLoading: bannersAsync.isLoading,
                          ),
                          SizedBox(height: design.spacing.lg),
                        ],
                      ),
                    ),
                  ],

                  // 2. Discovery Courses
                  SliverToBoxAdapter(
                    child: Builder(
                      builder: (context) {
                        final courses = discoveryCoursesAsync.valueOrNull ?? [];
                        final isLoading = discoveryCoursesAsync.isLoading;

                        if (searchQuery.isNotEmpty) {
                          return CourseDiscoveryList(
                            title: l10n.exploreSearchResultsTitle,
                            courses: courses,
                            isLoading: isLoading,
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CourseDiscoveryList(
                              key: _trendingKey,
                              title: l10n.exploreTrendingTitle,
                              courses: courses
                                  .where((c) => c.isTrending)
                                  .toList(),
                              isLoading: isLoading,
                            ),
                            SizedBox(height: design.spacing.xl),
                            CourseDiscoveryList(
                              key: _recommendedKey,
                              title: l10n.exploreRecommendedTitle,
                              courses: courses
                                  .where((c) => c.isRecommended)
                                  .toList(),
                              isLoading: isLoading,
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                  // 3. Short Lessons
                  SliverToBoxAdapter(
                    child: ShortLessonsSection(
                      key: _shortLessonsKey,
                      lessons: shortLessonsAsync.valueOrNull ?? [],
                      isLoading: shortLessonsAsync.isLoading,
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                  // 4. Popular Tests
                  SliverToBoxAdapter(
                    child: PopularTestsSection(
                      key: _popularKey,
                      tests: popularTestsAsync.valueOrNull ?? [],
                      isLoading: popularTestsAsync.isLoading,
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                  // 5. Study Tips Feed
                  SliverToBoxAdapter(
                    child: studyTipsAsync.when(
                      data: (tips) => StudyTipsList(
                        key: _studyTipsKey,
                        tips: tips,
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: design.spacing.xxl)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
