import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:courses/courses.dart';
import '../providers/exam_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

const _skeletonCourse = CourseDto(
  id: 'skeleton',
  title: 'Loading Exam Course Name',
  colorIndex: 0,
  chapterCount: 8,
  totalContents: 24,
  progress: 0,
  completedLessons: 0,
  totalLessons: 24,
);
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
    
    final examCoursesState = ref.watch(examListProvider);
    final isSyncing = ref.watch(isSyncingExamsProvider);
    final isSyncingMore = ref.watch(isSyncingMoreExamsProvider);
    
    final courses = examCoursesState.valueOrNull ?? [];
    final isSkeleton = isSyncing && courses.isEmpty;
    
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
        containersColor: design.colors.transparent,
        ignoreContainers: false,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(color: design.colors.canvas),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: design.colors.card,
                padding: EdgeInsets.all(design.spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.headline(
                      'Exams',
                      color: design.colors.textPrimary,
                    ),
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
              child: Container(
                height: 1,
                color: design.colors.divider,
              ),
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
            
            // Handle the main content logic uniformly without the rigid state branches
            // of .when(), allowing seamless transitions from cache to current data.
            if (examCoursesState.hasError && courses.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: AppText.body(
                    'Error loading exams: ${examCoursesState.error}',
                    color: design.colors.error,
                  ),
                ),
              )
            else if (courses.isEmpty && !isSkeleton)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: AppText.body(
                    'No exam courses found.',
                    color: design.colors.textSecondary,
                  ),
                ),
              )
            else
              (() {
                final displayCourses = isSkeleton
                    ? List.generate(6, (_) => _skeletonCourse)
                    : courses;

                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                                        '/exams/course/${course.id}/chapters');
                                  },
                          ),
                        );
                      },
                      childCount: displayCourses.length,
                    ),
                  ),
                );
              })(),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}
