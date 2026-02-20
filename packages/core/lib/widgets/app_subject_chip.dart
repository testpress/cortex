import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';

class AppSubjectChip extends StatelessWidget {
  const AppSubjectChip({
    super.key,
    required this.label,
    required this.subjectPaletteIndex,
    this.isActive = false,
    this.icon,
    required this.onTap,
  });

  final String label;
  final int subjectPaletteIndex;
  final bool isActive;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final subjectColors = design.subjectPalette.atIndex(subjectPaletteIndex);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: design.motion.fast,
        curve: design.motion.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? subjectColors.background : design.colors.surface,
          borderRadius: design.radius.pill,
          border: Border.all(
            color: isActive ? subjectColors.accent : design.colors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isActive
                    ? subjectColors.foreground
                    : design.colors.textSecondary,
              ),
              SizedBox(width: design.spacing.xs),
            ],
            Text(
              label,
              style: design.typography.labelSmall.copyWith(
                color: isActive
                    ? subjectColors.foreground
                    : design.colors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
