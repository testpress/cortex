import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
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
  final Set<LessonType> _selectedTypes = {};
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    final enrollmentAsync = ref.watch(enrollmentProvider);
    final allLessons = ref.watch(allLessonsProvider);
    final resumeAsync = ref.watch(recentActivityProvider);

    return Stack(
      children: [
        Positioned.fill(
          child: enrollmentAsync.when(
            data: (courses) {
              final filteredCourses = _filterCourses(courses);
              final filteredLessons = _filterLessons(allLessons);

              return AppScroll(
                padding: EdgeInsets.zero,
                children: [
                  // Top Header Section (White Background)
                  Container(
                    color: design.colors.card, // Pure white in light mode
                    padding: EdgeInsets.fromLTRB(
                      design.spacing.md,
                      design.spacing.md,
                      design.spacing.md,
                      design.spacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.headline(
                          l10n.studyTabTitle,
                          color: design.colors.textPrimary,
                        ),
                        SizedBox(height: design.spacing.md),

                        // Search Bar
                        AppSearchBar(
                          controller: _searchController,
                          hintText: l10n.studySearchHint,
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                          backgroundColor: design.colors.surfaceVariant,
                        ),
                        SizedBox(height: design.spacing.md),

                        // Filter Chips
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: design.spacing.sm,
                          crossAxisSpacing: design.spacing.sm,
                          childAspectRatio: 4.5,
                          padding: EdgeInsets.zero, // Remove grid padding
                          children: [
                            ContentTypeFilterChip(
                              label: l10n.filterVideo,
                              icon: LucideIcons.playCircle,
                              isSelected: _selectedTypes.contains(
                                LessonType.video,
                              ),
                              onTap: () => _toggleType(LessonType.video),
                              baseColor: design.study.video.background,
                              accentColor: design.study.video.foreground,
                              darkAccentColor: design.study.video.foreground,
                            ),
                            ContentTypeFilterChip(
                              label: l10n.filterLesson,
                              icon: LucideIcons.fileText,
                              isSelected: _selectedTypes.contains(
                                LessonType.pdf,
                              ),
                              onTap: () => _toggleType(LessonType.pdf),
                              baseColor: design.study.pdf.background,
                              accentColor: design.study.pdf.foreground,
                              darkAccentColor: design.study.pdf.foreground,
                            ),
                            ContentTypeFilterChip(
                              label: l10n.filterAssessment,
                              icon: LucideIcons.clipboardCheck,
                              isSelected: _selectedTypes.contains(
                                LessonType.assessment,
                              ),
                              onTap: () => _toggleType(LessonType.assessment),
                              baseColor: design.study.assessment.background,
                              accentColor: design.study.assessment.foreground,
                              darkAccentColor:
                                  design.study.assessment.foreground,
                            ),
                            ContentTypeFilterChip(
                              label: l10n.filterTest,
                              icon: LucideIcons.shieldCheck,
                              isSelected: _selectedTypes.contains(
                                LessonType.test,
                              ),
                              onTap: () => _toggleType(LessonType.test),
                              baseColor: design.study.test.background,
                              accentColor: design.study.test.foreground,
                              darkAccentColor: design.study.test.foreground,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Separator touching edges
                  Container(height: 1, color: design.colors.divider),

                  // Content Section (Canvas Background)
                  Container(
                    color: design.colors.canvas,
                    padding: EdgeInsets.fromLTRB(
                      design.spacing.md,
                      design.spacing.md,
                      design.spacing.md,
                      design.spacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_selectedTypes.isEmpty) ...[
                          AppText.title(
                            l10n.studyYourCoursesTitle,
                            color: design.colors.textPrimary,
                          ),
                          SizedBox(height: design.spacing.md),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredCourses.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
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
                            },
                          ),
                        ] else ...[
                          AppText.title(
                            l10n.studyYourCoursesTitle,
                            color: design.colors.textPrimary,
                          ),
                          SizedBox(height: design.spacing.md),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredLessons.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              final l = filteredLessons[index];
                              return _LessonListItem(lesson: l);
                            },
                          ),
                        ],
                        // Bottom padding for resume card
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (e, _) => Center(child: AppText.body('Error: $e')),
          ),
        ),

        // Resume Card (Sticky bottom)
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
      label: 'Open lesson: ${lesson.title}',
      onTap: () {
        final route = switch (lesson.type) {
          LessonType.video => '/video/${lesson.id}',
          LessonType.pdf => '/lesson/${lesson.id}',
          LessonType.assessment => '/assessment/${lesson.id}',
          LessonType.test => '/test/${lesson.id}',
        };
        context.push(route);
      },
      child: AppFocusable(
        onTap: () {
          final route = switch (lesson.type) {
            LessonType.video => '/video/${lesson.id}',
            LessonType.pdf => '/lesson/${lesson.id}',
            LessonType.assessment => '/assessment/${lesson.id}',
            LessonType.test => '/test/${lesson.id}',
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
