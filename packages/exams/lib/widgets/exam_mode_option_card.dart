import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// A card to display an exam mode option (e.g. Regular vs Quiz mode).
///
/// Highlights state dynamically via border, background tint, and icon colors.
class ExamModeOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ExamModeOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final childContent = Row(
      children: [
        Container(
          padding: EdgeInsets.all(design.spacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? design.colors.primary.withValues(alpha: 0.12)
                : design.colors.surfaceVariant,
            borderRadius: BorderRadius.circular(design.radius.md),
          ),
          child: Icon(
            icon,
            color: isSelected
                ? design.colors.primary
                : design.colors.textSecondary,
            size: 24,
          ),
        ),
        SizedBox(width: design.spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.body(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: design.spacing.xs),
              AppText.caption(description, color: design.colors.textSecondary),
            ],
          ),
        ),
      ],
    );

    final containerDecoration = BoxDecoration(
      color: isSelected
          ? design.colors.primary.withValues(alpha: 0.08)
          : design.colors.card,
      borderRadius: BorderRadius.circular(design.radius.lg),
      border: Border.all(
        color: isSelected ? design.colors.primary : design.colors.border,
        width: 1.5,
      ),
    );

    final containerWidget = MotionPreferences.shouldAnimate(context)
        ? AnimatedContainer(
            duration: MotionPreferences.duration(
              context,
              const Duration(milliseconds: 150),
            ),
            padding: EdgeInsets.all(design.spacing.md),
            decoration: containerDecoration,
            child: childContent,
          )
        : Container(
            padding: EdgeInsets.all(design.spacing.md),
            decoration: containerDecoration,
            child: childContent,
          );

    return AppSemantics.button(
      label: title,
      onTap: onTap,
      child: GestureDetector(onTap: onTap, child: containerWidget),
    );
  }
}
