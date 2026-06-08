import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

import '../../providers/info_providers.dart';

/// The main entry point for the Info tab, displaying a list of curated learning resources.
class InfoPage extends ConsumerStatefulWidget {
  const InfoPage({super.key});

  @override
  ConsumerState<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends ConsumerState<InfoPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future(() {
      if (!mounted) return;
      ref.read(infoListProvider.notifier).initialize();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      ref.read(infoListProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final coursesAsync = ref.watch(infoListProvider);
    final isSyncing = ref.watch(isSyncingInfoProvider);
    final isSyncingMore = ref.watch(isSyncingMoreInfoProvider);

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.canvas),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          const _InfoPageHeader(),
          _InfoPageSeparator(color: design.colors.divider),
          _InfoCourseList(
            coursesAsync: coursesAsync,
            isSyncing: isSyncing,
            isSyncingMore: isSyncingMore,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

/// The sticky header for the Info page.
class _InfoPageHeader extends StatelessWidget {
  const _InfoPageHeader();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return SliverToBoxAdapter(
      child: Container(
        color: design.colors.card,
        padding: EdgeInsets.all(design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.headline(
              l10n.infoPageTitle,
              color: design.colors.textPrimary,
            ),
            SizedBox(height: design.spacing.xs),
            AppText.body(
              l10n.infoPageSubtitle,
              color: design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple divider sliver.
class _InfoPageSeparator extends StatelessWidget {
  const _InfoPageSeparator({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: 1,
        color: color,
      ),
    );
  }
}

/// Handles the different states (loading, loaded, error, empty) of the course list.
class _InfoCourseList extends StatelessWidget {
  const _InfoCourseList({
    required this.coursesAsync,
    required this.isSyncing,
    required this.isSyncingMore,
  });

  final AsyncValue<List<CourseDto>> coursesAsync;
  final bool isSyncing;
  final bool isSyncingMore;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return coursesAsync.when(
      data: (courses) {
        if (courses.isEmpty && !isSyncing) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: _InfoEmptyState(),
          );
        }

        final isSkeleton = courses.isEmpty && isSyncing;
        final displayCourses = isSkeleton ? _mockSkeletonCourses : courses;

        return SliverMainAxisGroup(
          slivers: [
            _CourseSliverList(
              courses: displayCourses,
              isSkeleton: isSkeleton,
              design: design,
            ),
            if (isSyncingMore)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: design.spacing.md),
                  child: const Center(child: AppLoadingIndicator()),
                ),
              ),
          ],
        );
      },
      loading: () => _CourseSliverList(
        courses: _mockSkeletonCourses,
        isSkeleton: true,
        design: design,
      ),
      error: (e, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: _InfoErrorState(error: e),
      ),
    );
  }
}

/// Renders the actual list of course cards (or their skeletons).
class _CourseSliverList extends StatelessWidget {
  const _CourseSliverList({
    required this.courses,
    required this.isSkeleton,
    required this.design,
  });

  final List<CourseDto> courses;
  final bool isSkeleton;
  final DesignConfig design;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(design.spacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final course = courses[index];
            return Padding(
              padding: EdgeInsets.only(bottom: design.spacing.md),
              child: _InfoCourseCard(
                course: course,
                isSkeleton: isSkeleton,
              ),
            );
          },
          childCount: courses.length,
        ),
      ),
    );
  }
}

class _InfoEmptyState extends StatelessWidget {
  const _InfoEmptyState();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.helpCircle,
            size: 48,
            color: design.colors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          AppText.body(
            l10n.infoPageEmptyState,
            color: design.colors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _InfoErrorState extends StatelessWidget {
  const _InfoErrorState({required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 48, color: design.colors.error),
            const SizedBox(height: 16),
            AppText.body(
              l10n.infoPageLoadError,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCourseCard extends StatelessWidget {
  const _InfoCourseCard({
    required this.course,
    required this.isSkeleton,
  });

  final CourseDto course;
  final bool isSkeleton;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.infoPageOpenCourse(course.title),
      child: AppFocusable(
        onTap: () => context.push('/info/course/${course.id}/chapters'),
        borderRadius: design.radius.card,
        child: AppCard(
          showShadow: true,
          padding: EdgeInsets.all(design.spacing.md),
          child: Skeletonizer(
            enabled: isSkeleton,
            ignoreContainers: true,
            effect: ShimmerEffect(
              baseColor: design.colors.skeleton,
              highlightColor: design.colors.onSkeleton,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Image Box
                Skeleton.replace(
                  width: 78,
                  height: 80,
                  replacement: DecoratedBox(
                    decoration: BoxDecoration(
                      color: design.colors.skeleton,
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                  ),
                  child: Container(
                    width: 78,
                    height: 80,
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(design.radius.md),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(design.radius.md),
                      child: course.image?.isNotEmpty == true
                          ? Image.network(
                              course.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                LucideIcons.bookOpen,
                                color: design.colors.textSecondary
                                    .withValues(alpha: 0.5),
                                size: 32,
                              ),
                            )
                          : Icon(
                              LucideIcons.bookOpen,
                              color: design.colors.textSecondary
                                  .withValues(alpha: 0.5),
                              size: 32,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: design.spacing.md),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText.cardTitle(
                              course.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            LucideIcons.chevronRight,
                            color: design.colors.textSecondary
                                .withValues(alpha: 0.3),
                            size: 20,
                          ),
                        ],
                      ),
                      SizedBox(height: design.spacing.xs),

                      // Metadata: Chapters with icon
                      Row(
                        children: [
                          Icon(
                            LucideIcons.layers,
                            size: 14,
                            color: design.colors.textSecondary
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          AppText.caption(
                            L10n.of(context)
                                .curriculumChaptersCount(course.chapterCount),
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),

                      SizedBox(height: design.spacing.sm),

                      // Specific Info Metadata: Lessons
                      Row(
                        children: [
                          Icon(
                            LucideIcons.playCircle,
                            size: 14,
                            color: design.colors.textSecondary
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 4),
                          AppText.cardCaption(
                            l10n.infoPageLessonsCount(course.totalLessons),
                            color: design.colors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Mock data strictly used for skeleton states.
// BoneMock provides realistic string lengths so Skeletonizer generates appropriately sized bones.
final _mockSkeletonCourses = List.generate(
  5,
  (index) => CourseDto(
    id: index.toString(),
    title: 'Mock learning resource course title',
    image: '',
    colorIndex: index,
    chapterCount: 3,
    totalContents: 20,
    progress: 0,
    completedLessons: 0,
    totalLessons: 12,
    examsCount: 0,
    tags: const ['Info'],
  ),
);
