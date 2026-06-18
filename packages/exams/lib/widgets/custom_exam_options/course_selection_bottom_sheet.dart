import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

class CourseSelectionSheet extends StatefulWidget {
  final List<CourseDto> courses;
  final String? selectedCourseId;
  final ValueChanged<CourseDto> onCourseSelected;

  const CourseSelectionSheet({
    super.key,
    required this.courses,
    this.selectedCourseId,
    required this.onCourseSelected,
  });

  @override
  State<CourseSelectionSheet> createState() => _CourseSelectionSheetState();
}

class _CourseSelectionSheetState extends State<CourseSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<CourseDto> _filteredCourses = [];

  @override
  void initState() {
    super.initState();
    _filteredCourses = widget.courses;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(CourseSelectionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.courses != oldWidget.courses) {
      _onSearchChanged();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      setState(() {
        _filteredCourses = widget.courses;
      });
    } else {
      setState(() {
        _filteredCourses = widget.courses
            .where((c) => c.title.toLowerCase().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    // Calculate half screen height
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      constraints: BoxConstraints(maxHeight: screenHeight * 0.5),
      margin: EdgeInsets.only(
        left: design.spacing.md,
        right: design.spacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.all(Radius.circular(design.radius.xxl)),
        boxShadow: design.shadows.floating,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handler Pill
          Center(
            child: Container(
              margin: EdgeInsets.only(top: design.spacing.sm),
              width: design.spacing.xl * 1.5,
              height: 4,
              decoration: BoxDecoration(
                color: design.colors.textTertiary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(design.radius.full),
              ),
            ),
          ),
          // Header and Search
          Padding(
            padding: EdgeInsets.fromLTRB(
              design.spacing.md,
              design.spacing.md,
              design.spacing.md,
              design.spacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSemantics.header(
                  label: context.l10n.customExamSelectCourse,
                  child: AppText.headline(context.l10n.customExamSelectCourse),
                ),
                SizedBox(height: design.spacing.md),
                AppTextField(
                  label: '',
                  controller: _searchController,
                  hintText: context.l10n.customExamSearchCourses,
                  prefixIcon: LucideIcons.search,
                ),
              ],
            ),
          ),

          // List of courses
          Expanded(
            child: _filteredCourses.isEmpty
                ? Center(
                    child: AppText.body(
                      context.l10n.customExamNoCoursesFound,
                      color: design.colors.textSecondary,
                    ),
                  )
                : AppSemantics.scrollableList(
                    label: context.l10n.customExamSelectCourse,
                    itemCount: _filteredCourses.length,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        vertical: design.spacing.sm,
                      ),
                      itemCount: _filteredCourses.length,
                      itemBuilder: (context, index) {
                        final course = _filteredCourses[index];
                        final isSelected = course.id == widget.selectedCourseId;

                        return AppSemantics.button(
                          label: course.title,
                          onTap: () => widget.onCourseSelected(course),
                          child: GestureDetector(
                            onTap: () => widget.onCourseSelected(course),
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.spacing.md,
                                vertical: design.spacing.md,
                              ),
                              color: isSelected
                                  ? design.colors.primary.withValues(alpha: 0.1)
                                  : null,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppText.body(
                                      course.title,
                                      color: isSelected
                                          ? design.colors.primary
                                          : design.colors.textPrimary,
                                      style: isSelected
                                          ? const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            )
                                          : null,
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(
                                      LucideIcons.check,
                                      color: design.colors.primary,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
