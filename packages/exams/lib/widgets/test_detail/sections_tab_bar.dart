import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../repositories/exam_repository.dart';

class SectionsTabBar extends StatelessWidget {
  final ExamAttemptState state;
  final int activeSubjectIndex;
  final bool isExpanded;
  final ValueChanged<bool> onExpandChanged;
  final ValueChanged<int> onTabSelected;

  const SectionsTabBar({
    super.key,
    required this.state,
    required this.activeSubjectIndex,
    required this.isExpanded,
    required this.onExpandChanged,
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
    final activeName = tabNames[activeIndex < tabNames.length ? activeIndex : 0];

    if (!isExpanded) {
      return GestureDetector(
        onTap: () => onExpandChanged(true),
        child: Container(
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
          decoration: BoxDecoration(
            color: design.colors.card,
            border: Border(
              bottom: BorderSide(
                color: design.colors.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.caption(
                '${state.sections.length > 1 ? "Section" : "Subject"}: ${activeName.isEmpty ? "General" : activeName}',
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: design.spacing.xs),
              Icon(
                LucideIcons.chevronDown,
                size: 16,
                color: design.colors.textSecondary,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          bottom: BorderSide(
            color: design.colors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFFFFFFFF),
                    Color(0x00FFFFFF),
                  ],
                  stops: [0.80, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: design.spacing.md, vertical: design.spacing.xs),
                itemCount: tabNames.length,
                itemBuilder: (context, index) {
                  final tabName = tabNames[index];
                  final isActive = index == activeIndex;

                  return GestureDetector(
                    onTap: () {
                      if (!isActive) {
                        onTabSelected(index);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: design.spacing.sm),
                      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive ? design.colors.primary : design.colors.card,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isActive ? design.colors.primary : design.colors.border,
                        ),
                      ),
                      child: AppText.body(
                        tabName.isEmpty ? 'General' : tabName,
                        color: isActive ? design.colors.onPrimary : design.colors.textPrimary,
                        style: TextStyle(
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onExpandChanged(false),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.chevronUp,
                size: 20,
                color: design.colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
