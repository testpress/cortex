import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';

import '../providers/explore_providers.dart';
import '../widgets/featured_carousel.dart';
import '../widgets/quick_access_filter.dart';
import '../widgets/course_discovery_list.dart';
import '../widgets/short_lessons_section.dart';
import '../widgets/popular_tests_section.dart';
import '../widgets/study_tips_list.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                        // Paid Toggle Placeholder (Ignored as per instruction)
                      ],
                    ),
                    SizedBox(height: design.spacing.md),
                    AppSearchBar(
                      controller: _searchController,
                      hintText: l10n.exploreSearchHint,
                      backgroundColor: design.colors.surface, // Support dark mode better
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
                },
              ),
            ],
          ),
        ),

        // Content Section
        Expanded(
          child: Container(
            color: design.colors.canvas, // Muted background for the feed
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: design.spacing.md)),

                // 1. Featured Banners (Hide while searching)
                if (searchQuery.isEmpty) ...[
                  SliverToBoxAdapter(
                    child: bannersAsync.when(
                      data: (banners) => Column(
                        children: [
                          FeaturedCarousel(banners: banners),
                          SizedBox(height: design.spacing.lg),
                        ],
                      ),
                      loading: () => const SizedBox(
                        height: 200,
                        child: Center(child: AppLoadingIndicator()),
                      ),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                ],

                // 2. Discovery Courses (Trending / Recommended)
                SliverToBoxAdapter(
                  child: discoveryCoursesAsync.when(
                    data: (courses) {
                      if (searchQuery.isNotEmpty) {
                        return CourseDiscoveryList(
                          title: l10n.exploreSearchResultsTitle,
                          courses: courses,
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CourseDiscoveryList(
                            title: l10n.exploreTrendingTitle,
                            courses: courses.take(2).toList(),
                          ),
                          SizedBox(height: design.spacing.xl),
                          CourseDiscoveryList(
                            title: l10n.exploreRecommendedTitle,
                            courses: courses.skip(2).toList(),
                          ),
                        ],
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                // 3. Short Lessons
                SliverToBoxAdapter(
                  child: shortLessonsAsync.when(
                    data: (lessons) => ShortLessonsSection(lessons: lessons),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                // 4. Popular Tests
                SliverToBoxAdapter(
                  child: popularTestsAsync.when(
                    data: (tests) => PopularTestsSection(tests: tests),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: design.spacing.xl)),

                // 5. Study Tips Feed
                SliverToBoxAdapter(
                  child: studyTipsAsync.when(
                    data: (tips) => StudyTipsList(tips: tips),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: design.spacing.xxl)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
