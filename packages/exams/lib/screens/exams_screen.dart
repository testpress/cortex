import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';

class ExamsScreen extends ConsumerStatefulWidget {
  const ExamsScreen({super.key});

  @override
  ConsumerState<ExamsScreen> createState() => _ExamsScreenState();
}

class _ExamsScreenState extends ConsumerState<ExamsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Ensure courses are synced when entering the exams tab independently
    Future.microtask(() {
      if (mounted) {
        ref.read(examListProvider.notifier).initialize();
      }
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      ref.read(examListProvider.notifier).loadMore();
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
    final padding = MediaQuery.paddingOf(context);

    final examCoursesState = ref.watch(examListProvider);
    final isSyncing = ref.watch(isSyncingExamsProvider);
    final isSyncingMore = ref.watch(isSyncingMoreExamsProvider);

    return DecoratedBox(
      decoration: BoxDecoration(color: design.colors.canvas),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: design.colors.card,
              padding: EdgeInsets.fromLTRB(
                padding.left > design.spacing.md ? padding.left : design.spacing.md,
                padding.top + design.spacing.md,
                padding.right > design.spacing.md ? padding.right : design.spacing.md,
                design.spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headline('Exams', color: design.colors.textPrimary),
                  SizedBox(height: design.spacing.xs),
                  AppText.body(
                    'Select an exam to view question papers',
                    color: design.colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(height: 1, color: design.colors.divider),
          ),

          SliverPadding(
            padding: EdgeInsets.all(design.spacing.md),
            sliver: SliverToBoxAdapter(
              child: AppText.title(
                'Available Exam Courses',
                color: design.colors.textPrimary,
              ),
            ),
          ),

          examCoursesState.when(
            data: (courses) {
              final isSkeleton = isSyncing && courses.isEmpty;
              final displayCourses = isSkeleton ? _skeletonCourses : courses;

              if (displayCourses.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppText.body(
                      'No exam courses found.',
                      color: design.colors.textSecondary,
                    ),
                  ),
                );
              }

              return SliverMainAxisGroup(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final course = displayCourses[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: design.spacing.md),
                          child: CourseCard(
                            course: course,
                            isSkeleton: isSkeleton,
                            onTap: isSkeleton
                                ? null
                                : () {
                                    context.push(
                                      '/exams/course/${course.id}/chapters',
                                    );
                                  },
                          ),
                        );
                      }, childCount: displayCourses.length),
                    ),
                  ),
                  if (isSyncingMore)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: design.spacing.md),
                          child: CourseCard(
                            course: _skeletonCourses.first,
                            isSkeleton: isSyncingMore,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
            loading: () => isSyncing
                ? SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: design.spacing.md),
                          child: CourseCard(
                            course: _skeletonCourses[index],
                            isSkeleton: isSyncing,
                          ),
                        ),
                        childCount: _skeletonCourses.length,
                      ),
                    ),
                  )
                : const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (error, stack) => SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: AppText.body(
                  'Error loading exams: $error',
                  color: design.colors.error,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

final _skeletonCourses = List.generate(
  6,
  (index) => CourseDto(
    id: 'skeleton-$index',
    title: 'Loading course title text',
    colorIndex: index % 6,
    chapterCount: 12,
    totalContents: 48,
    progress: 0,
    completedLessons: 0,
    totalLessons: 48,
    image: '',
    examsCount: 0,
    order: index,
  ),
);
