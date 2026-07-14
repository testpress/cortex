import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../providers/custom_exam_courses_provider.dart';

class CustomExamCourseSelectionScreen extends ConsumerStatefulWidget {
  const CustomExamCourseSelectionScreen({super.key});

  @override
  ConsumerState<CustomExamCourseSelectionScreen> createState() =>
      _CustomExamCourseSelectionScreenState();
}

class _CustomExamCourseSelectionScreenState
    extends ConsumerState<CustomExamCourseSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsyncValue = ref.watch(customExamCoursesProvider);
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return ColoredBox(
      color: design.colors.card,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drawer-style header ───────────────────────────────────
            Container(
              padding: EdgeInsets.only(
                top: design.spacing.md,
                left: design.spacing.md,
                right: design.spacing.md,
                bottom: design.spacing.md,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: design.colors.border, width: 1),
                ),
                boxShadow: design.shadows.surfaceSoft,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: design.spacing.xs,
                  horizontal: design.spacing.xs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFocusable(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(design.radius.md),
                      child: Padding(
                        padding: EdgeInsets.all(design.spacing.xs),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            color: design.colors.textPrimary,
                            size: design.iconSize.md,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.sm),
                    Expanded(
                      child: AppSemantics.header(
                        label: l10n.customExamTitle,
                        child: AppText.title(
                          l10n.customExamTitle,
                          color: design.colors.textPrimary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ── Info banner ───────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: design.colors.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: design.colors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(
                        LucideIcons.info,
                        color: design.colors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText.bodySmall(
                        l10n.customExamCourseSelectionInfo,
                        color: design.colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── "Select a course" + search ────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSemantics.header(
                    label: l10n.customExamSelectCourse,
                    child: AppText.title(
                      l10n.customExamSelectCourse,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      color: design.colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppSearchBar(
                    hintText: l10n.customExamSearchCourses,
                    controller: _searchController,
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ],
              ),
            ),

            // ── Course list (white bg, bordered cards) ───────────────
            Expanded(
              child: ColoredBox(
                color: design.colors.card,
                child: Skeletonizer(
                  enabled:
                      coursesAsyncValue.isLoading &&
                      !coursesAsyncValue.hasValue,
                  ignoreContainers: true,
                  effect: ShimmerEffect(
                    baseColor: design.colors.skeleton,
                    highlightColor: design.colors.onSkeleton,
                    duration: MotionPreferences.duration(
                      context,
                      const Duration(milliseconds: 800),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      // Determine the courses to display based on the state.
                      final List<CourseDto> coursesToDisplay;
                      if (coursesAsyncValue.isLoading) {
                        // When loading, provide dummy data to power the Skeletonizer
                        coursesToDisplay = List.generate(
                          5,
                          (i) => CourseDto(
                            id: '$i',
                            title: l10n.customExamLoadingCourse,
                            colorIndex: 0,
                            chapterCount: 0,
                            totalContents: 0,
                            progress: 0,
                            completedLessons: 0,
                            totalLessons: 10,
                          ),
                        );
                      } else if (coursesAsyncValue.hasError) {
                        return Center(
                          child: AppText.body(
                            l10n.customExamErrorLoading,
                            color: design.colors.error,
                          ),
                        );
                      } else {
                        // When loaded, filter by search query
                        final allCourses = coursesAsyncValue.valueOrNull ?? [];
                        coursesToDisplay = allCourses
                            .where(
                              (c) => c.title.toLowerCase().contains(
                                _searchQuery.toLowerCase(),
                              ),
                            )
                            .toList();

                        // Show empty state if no courses match
                        if (coursesToDisplay.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.searchX,
                                  size: 64,
                                  color: design.colors.border,
                                ),
                                const SizedBox(height: 16),
                                AppText.subtitle(
                                  l10n.customExamNoCoursesFound,
                                  color: design.colors.textSecondary,
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      // The single true UI definition, used for both real and skeleton rendering!
                      return AppSemantics.scrollableList(
                        label: l10n.customExamSelectCourse,
                        itemCount: coursesToDisplay.length,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          itemCount: coursesToDisplay.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final course = coursesToDisplay[index];
                            final subjectColors = design.subjectPalette.atIndex(
                              course.colorIndex,
                            );

                            return AppSemantics.button(
                              label: course.title,
                              onTap: coursesAsyncValue.isLoading
                                  ? null
                                  : () => context.push(
                                      '/exams/custom-exam-config',
                                      extra: course,
                                    ),
                              child: AppFocusable(
                                onTap: coursesAsyncValue.isLoading
                                    ? null
                                    : () => context.push(
                                        '/exams/custom-exam-config',
                                        extra: course,
                                      ),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: design.colors.card,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: design.colors.border.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Wrap container in Skeleton.leaf so it becomes a solid grey bone instead of a coloured box
                                      Skeleton.leaf(
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: subjectColors.background,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child:
                                              course.image != null &&
                                                  course.image!.isNotEmpty &&
                                                  !coursesAsyncValue.isLoading
                                              ? Image.network(
                                                  course.image!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, _, _) =>
                                                      Icon(
                                                        LucideIcons
                                                            .graduationCap,
                                                        color: subjectColors
                                                            .accent,
                                                        size: 24,
                                                      ),
                                                )
                                              : Icon(
                                                  LucideIcons.graduationCap,
                                                  color: subjectColors.accent,
                                                  size: 24,
                                                ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppText.body(
                                              course.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: design.colors.textPrimary,
                                            ),
                                            const SizedBox(height: 2),
                                            AppText.bodySmall(
                                              '${course.totalLessons} Lessons',
                                              color:
                                                  design.colors.textSecondary,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        LucideIcons.chevronRight,
                                        color: design.colors.textTertiary,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
