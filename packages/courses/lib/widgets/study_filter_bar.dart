import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'content_type_filter_chip.dart';

class StudyFilterBar extends StatelessWidget {
  final Set<LessonType> activeTypeFilters;
  final ValueChanged<LessonType> onTypeToggled;

  const StudyFilterBar({
    super.key,
    required this.activeTypeFilters,
    required this.onTypeToggled,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final filterConfigs = [
      (LessonType.video, l10n.filterVideo, LucideIcons.playCircle, design.study.video),
      (LessonType.pdf, l10n.filterLesson, LucideIcons.fileText, design.study.pdf),
      (LessonType.assessment, l10n.filterAssessment, LucideIcons.clipboardCheck, design.study.assessment),
      (LessonType.test, l10n.filterTest, LucideIcons.shieldCheck, design.study.test),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: design.spacing.sm,
      crossAxisSpacing: design.spacing.sm,
      childAspectRatio: 4.5,
      padding: EdgeInsets.zero,
      children: filterConfigs.map((config) {
        final type = config.$1;
        final label = config.$2;
        final icon = config.$3;
        final theme = config.$4;

        return ContentTypeFilterChip(
          label: label,
          icon: icon,
          isSelected: activeTypeFilters.contains(type),
          onTap: () => onTypeToggled(type),
          baseColor: theme.background,
          accentColor: theme.foreground,
          darkAccentColor: theme.foreground,
        );
      }).toList(),
    );
  }
}
