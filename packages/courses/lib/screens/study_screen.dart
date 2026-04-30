import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/course_list_provider.dart';
import '../providers/lesson_providers.dart';
import '../providers/recent_activity_provider.dart';
import '../widgets/study_resume_card.dart';
import '../widgets/study_filter_bar.dart';
import '../widgets/study_content_list.dart';

/// The main Study screen for paid active users.
///
/// Provides course listing, content type filtering, and search.
class StudyScreen extends ConsumerStatefulWidget {
  const StudyScreen({super.key});

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Set<LessonType> _activeTypeFilters = {};
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Explicitly trigger the initial sync when the screen is first loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseListProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    const scrollThreshold = 500;
    if (_scrollController.position.extentAfter < scrollThreshold) {
      ref.read(courseListProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    // Update local state immediately for responsive client-side filtering of lessons.
    setState(() {
      _searchQuery = value;
    });

    // Debounce the server-side API call for course searching.
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        ref.read(courseListProvider.notifier).search(value);
      }
    });
  }

  void _toggleType(LessonType type) {
    setState(() {
      if (_activeTypeFilters.contains(type)) {
        _activeTypeFilters.remove(type);
      } else {
        _activeTypeFilters.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final enrolledCoursesState = ref.watch(courseListProvider);
    final isSyncingInitial = ref.watch(isSyncingInitialPage);
    final isSyncingMore = ref.watch(isSyncingMoreResults);
    final allLessons = ref.watch(allLessonsProvider);
    final recentActivityState = ref.watch(recentActivityProvider);
    final activeSyncError = ref.watch(courseListSyncError);
    final config = ref.watch(clientConfigProvider);


    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.canvas),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Static Header Section
                SliverToBoxAdapter(
                  child: Container(
                    color: design.colors.card,
                    padding: EdgeInsets.all(design.spacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.headline(
                          l10n.studyTabTitle,
                          color: design.colors.textPrimary,
                        ),
                        SizedBox(height: design.spacing.md),
                        AppSearchBar(
                          controller: _searchController,
                          hintText: l10n.studySearchHint,
                          onChanged: _onSearchChanged,
                          backgroundColor: design.colors.surfaceVariant,
                        ),
                        if (config.showStudyCategoryButtons) ...[
                          SizedBox(height: design.spacing.md),
                          StudyFilterBar(
                            activeTypeFilters: _activeTypeFilters,
                            onTypeToggled: _toggleType,
                          ),
                        ],
                        if (activeSyncError != null) ...[
                          SizedBox(height: design.spacing.md),
                          ClipRRect(
                            borderRadius: design.radius.card,
                            child: Container(
                              color: design.colors.error,
                              padding: EdgeInsets.all(design.spacing.sm),
                              child: Row(
                                children: [
                                  Icon(
                                    LucideIcons.alertCircle,
                                    color: const Color(0xFFFFFFFF),
                                    size: 16,
                                  ),
                                  SizedBox(width: design.spacing.sm),
                                  Expanded(
                                    child: AppText.body(
                                      'Sync issues: $activeSyncError',
                                      color: const Color(0xFFFFFFFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Separator
                SliverToBoxAdapter(
                  child: Container(
                    height: 1,
                    color: design.colors.divider,
                  ),
                ),

                // Content Title
                SliverPadding(
                  padding: EdgeInsets.all(design.spacing.md),
                  sliver: SliverToBoxAdapter(
                    child: AppText.title(
                      l10n.studyYourCoursesTitle,
                      color: design.colors.textPrimary,
                    ),
                  ),
                ),

                // 2. Dynamic Content Section
                StudyContentList(
                  enrolledCoursesState: enrolledCoursesState,
                  isSyncingInitial: isSyncingInitial,
                  isSyncingMore: isSyncingMore,
                  allLessons: allLessons,
                  activeTypeFilters: _activeTypeFilters,
                  searchQuery: _searchQuery,
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),
          recentActivityState.when(
            data: (activity) => activity != null
                ? Positioned(
                    bottom: design.spacing.md,
                    left: design.spacing.md,
                    right: design.spacing.md,
                    child: StudyResumeCard(activity: activity, onResume: () {}),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
