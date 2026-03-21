import 'package:flutter/material.dart' show ScaffoldMessenger, SnackBar, Colors;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../providers/course_list_provider.dart';
import '../providers/lesson_providers.dart';
import '../providers/recent_activity_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/content_type_filter_chip.dart';
import '../widgets/study_resume_card.dart';

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
  final Set<LessonType> _selectedTypes = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Explicitly trigger the initial sync when the screen is first loaded.
    // This is better than a side-effect provider because it's easy to trace.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(courseListProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // UI only detects the intent (scrolled near bottom)
    if (_scrollController.position.extentAfter < 500) {
      // Business logic is encapsulated in the notifier
      ref.read(courseListProvider.notifier).loadMore();
    }
  }

  void _toggleType(LessonType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final enrollmentAsync = ref.watch(courseListProvider);
    final isInitialSyncing = ref.watch(isInitialSyncingProvider);
    final isMoreSyncing = ref.watch(isMoreSyncingProvider);
    final allLessons = ref.watch(allLessonsProvider);
    final resumeAsync = ref.watch(recentActivityProvider);

    // Show a small notification if a sync error occurs during scrolling
    ref.listen(syncErrorProvider, (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText.body('Sync failed: $next', color: Colors.white),
            backgroundColor: design.colors.error,
          ),
        );
      }
    });

    // Determines if we show the centered full-page spinner (only for truly empty state)
    final showInitialLoader =
        isInitialSyncing && enrollmentAsync.valueOrNull?.isEmpty == true;

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.canvas),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Static Header Section (Always Visible)
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
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          backgroundColor: design.colors.surfaceVariant,
                        ),
                        SizedBox(height: design.spacing.md),
                        _buildFilterChips(context, design, l10n),
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
                if (showInitialLoader)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: AppLoadingIndicator()),
                  )
                else
                  ...enrollmentAsync.when(
                    data: (courses) {
                      final filteredCourses = _filterCourses(courses);
                      final filteredLessons = _filterLessons(allLessons);

                      return [
                        if (_selectedTypes.isEmpty)
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final c = filteredCourses[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: design.spacing.md,
                                  ),
                                  child: CourseCard(
                                    course: c,
                                    onTap: () => context.push(
                                      '/study/course/${c.id}/chapters',
                                    ),
                                  ),
                                );
                              }, childCount: filteredCourses.length),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final l = filteredLessons[index];
                                return _LessonListItem(lesson: l);
                              }, childCount: filteredLessons.length),
                            ),
                          ),

                        // Footer Loader
                        if (isMoreSyncing)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: design.spacing.md,
                              ),
                              child: const Center(
                                child: AppLoadingIndicator(),
                              ),
                            ),
                          ),
                      ];
                    },
                    loading: () => [
                      const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ],
                    error: (e, _) => [
                      SliverToBoxAdapter(
                        child: Center(child: AppText.body('Error: $e')),
                      ),
                    ],
                  ),

                // Bottom Safe Area Spacer
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ),
          ),
          // Resume Card
          resumeAsync.when(
            data: (activity) => activity != null
                ? Positioned(
                    bottom: design.spacing.md,
                    left: design.spacing.md,
                    right: design.spacing.md,
                    child: StudyResumeCard(activity: activity, onResume: () {}),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    DesignConfig design,
    AppLocalizations l10n,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: design.spacing.sm,
      crossAxisSpacing: design.spacing.sm,
      childAspectRatio: 4.5,
      padding: EdgeInsets.zero,
      children: [
        ContentTypeFilterChip(
          label: l10n.filterVideo,
          icon: LucideIcons.playCircle,
          isSelected: _selectedTypes.contains(LessonType.video),
          onTap: () => _toggleType(LessonType.video),
          baseColor: design.study.video.background,
          accentColor: design.study.video.foreground,
          darkAccentColor: design.study.video.foreground,
        ),
        ContentTypeFilterChip(
          label: l10n.filterLesson,
          icon: LucideIcons.fileText,
          isSelected: _selectedTypes.contains(LessonType.pdf),
          onTap: () => _toggleType(LessonType.pdf),
          baseColor: design.study.pdf.background,
          accentColor: design.study.pdf.foreground,
          darkAccentColor: design.study.pdf.foreground,
        ),
        ContentTypeFilterChip(
          label: l10n.filterAssessment,
          icon: LucideIcons.clipboardCheck,
          isSelected: _selectedTypes.contains(LessonType.assessment),
          onTap: () => _toggleType(LessonType.assessment),
          baseColor: design.study.assessment.background,
          accentColor: design.study.assessment.foreground,
          darkAccentColor: design.study.assessment.foreground,
        ),
        ContentTypeFilterChip(
          label: l10n.filterTest,
          icon: LucideIcons.shieldCheck,
          isSelected: _selectedTypes.contains(LessonType.test),
          onTap: () => _toggleType(LessonType.test),
          baseColor: design.study.test.background,
          accentColor: design.study.test.foreground,
          darkAccentColor: design.study.test.foreground,
        ),
      ],
    );
  }

  List<CourseDto> _filterCourses(List<CourseDto> courses) {
    if (_searchQuery.isEmpty) return courses;
    return courses
        .where(
          (c) => c.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  List<LessonDto> _filterLessons(List<LessonDto> lessons) {
    if (_selectedTypes.isEmpty) return [];

    return lessons.where((lesson) {
      if (!_selectedTypes.contains(lesson.type)) return false;
      if (_searchQuery.isEmpty) return true;
      return lesson.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }
}

class _LessonListItem extends StatelessWidget {
  const _LessonListItem({required this.lesson});
  final LessonDto lesson;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    IconData icon;
    ShortcutColors typeTheme;
    switch (lesson.type) {
      case LessonType.video:
        icon = LucideIcons.playCircle;
        typeTheme = design.study.video;
        break;
      case LessonType.pdf:
        icon = LucideIcons.fileText;
        typeTheme = design.study.pdf;
        break;
      case LessonType.assessment:
        icon = LucideIcons.clipboardCheck;
        typeTheme = design.study.assessment;
        break;
      case LessonType.test:
        icon = LucideIcons.shieldCheck;
        typeTheme = design.study.test;
        break;
    }

    final color = typeTheme.foreground;
    final backgroundColor = typeTheme.background;

    return AppSemantics.button(
      label: l10n.openDetailedLesson(lesson.title),
      onTap: () {
        final route = switch (lesson.type) {
          LessonType.video => '/study/video/${lesson.id}',
          LessonType.pdf => '/study/lesson/${lesson.id}',
          LessonType.assessment => '/study/assessment/${lesson.id}',
          LessonType.test => '/study/test/${lesson.id}',
        };
        context.push(route);
      },
      child: AppFocusable(
        onTap: () {
          final route = switch (lesson.type) {
            LessonType.video => '/study/video/${lesson.id}',
            LessonType.pdf => '/study/lesson/${lesson.id}',
            LessonType.assessment => '/study/assessment/${lesson.id}',
            LessonType.test => '/study/test/${lesson.id}',
          };
          context.push(route);
        },
        borderRadius: design.radius.card,
        child: AppCard(
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.label(
                      lesson.title,
                      color: design.colors.textPrimary,
                    ),
                    AppText.caption(
                      '${lesson.type.name.toUpperCase()} · ${lesson.duration}',
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: design.colors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
