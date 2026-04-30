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
  @override
  void initState() {
    super.initState();
    // Ensure courses are synced when entering the exams tab independently
    Future.microtask(() {
      if (mounted) {
        ref.read(examListProvider.notifier).initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    
    final examCoursesState = ref.watch(examListProvider);
    final isSyncing = ref.watch(isSyncingExamsProvider);
    
    return DecoratedBox(
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
          
          examCoursesState.when(
            data: (courses) {
              if (courses.isEmpty) {
                if (isSyncing) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: AppLoadingIndicator(),
                    ),
                  );
                }
                
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
              
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final course = courses[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: design.spacing.md),
                        child: CourseCard(
                          course: course,
                          onTap: () {
                            context.push('/exams/course/${course.id}/chapters');
                          },
                        ),
                      );
                    },
                    childCount: courses.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: AppLoadingIndicator(),
              ),
            ),
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
          
          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }
}
