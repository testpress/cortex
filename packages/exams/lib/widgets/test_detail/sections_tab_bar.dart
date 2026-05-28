import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../repositories/exam_repository.dart';

class SectionsTabBar extends StatelessWidget {
  final ExamAttemptState state;
  final int activeSubjectIndex;
  final ValueChanged<int> onTabSelected;

  const SectionsTabBar({
    super.key,
    required this.state,
    required this.activeSubjectIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabNames = [];
    final List<String> subjects = [];

    if (state.sections.length > 1) {
      tabNames.addAll(state.sections.map((s) => s.name));
    } else {
      for (final q in state.questions) {
        if (!subjects.contains(q.subject)) {
          subjects.add(q.subject);
        }
      }
      if (subjects.length > 1) {
        tabNames.addAll(subjects);
      }
    }

    if (tabNames.isEmpty) return const SizedBox.shrink();

    final design = Design.of(context);
    final activeIndex = state.sections.length > 1
        ? state.currentSectionIndex
        : activeSubjectIndex;

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
        ),
        child: Row(
          children: tabNames.asMap().entries.map((entry) {
            final index = entry.key;
            final tabName = entry.value;
            final isActive = index == activeIndex;

            final bgColor = isActive
                ? design.colors.textPrimary
                : design.colors.surfaceVariant;
            final fgColor = isActive
                ? design.colors.card
                : design.colors.textPrimary;

            return Padding(
              padding: EdgeInsets.only(right: design.spacing.sm),
              child: AppSemantics.button(
                label: 'Filter by ${tabName.isEmpty ? 'General' : tabName}',
                onTap: () {
                  if (!isActive) {
                    onTabSelected(index);
                  }
                },
                child: AppFocusable(
                  onTap: () {
                    if (!isActive) {
                      onTabSelected(index);
                    }
                  },
                  borderRadius: design.radius.pill,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: design.motion.easeOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: design.radius.pill,
                    ),
                    child: AppText.label(
                      tabName.isEmpty ? 'General' : tabName,
                      color: fgColor,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
