import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Filter chips for content types in the Study tab.
class ContentTypeFilterChip extends StatelessWidget {
  const ContentTypeFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.baseColor,
    required this.accentColor,
    required this.darkAccentColor,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color baseColor; // Light background
  final Color accentColor; // Text and Icon color
  final Color darkAccentColor; // Text and Icon color for dark mode

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final Color effectiveAccent = design.isDark ? darkAccentColor : accentColor;

    // In dark mode, we use a slightly transparent version of the accent color for background
    final Color bgColor = design.isDark
        ? effectiveAccent.withValues(alpha: 0.15)
        : (isSelected ? effectiveAccent.withValues(alpha: 0.1) : baseColor);

    final Color borderColor = design.isDark
        ? (isSelected ? effectiveAccent : design.colors.border)
        : (isSelected
              ? effectiveAccent.withValues(alpha: 0.3)
              : design.colors.border);

    final Color textColor = design.isDark
        ? (isSelected ? design.colors.textPrimary : effectiveAccent)
        : (isSelected ? design.colors.textPrimary : effectiveAccent);

    return AppSemantics.button(
      label: 'Filter by $label',
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: design.motion.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: design.radius.button,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: textColor),
            SizedBox(width: design.spacing.sm),
            AppText.label(label, color: textColor),
          ],
        ),
      ),
    );
  }
}
