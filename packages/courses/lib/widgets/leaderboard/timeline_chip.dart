import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class TimelineChip extends StatelessWidget {
  const TimelineChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? design.colors.accent2.withValues(alpha: 0.1)
              : design.colors.card,
          borderRadius: BorderRadius.circular(100),
          border: isSelected ? null : Border.all(color: design.colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? design.colors.accent2
                  : design.colors.textSecondary,
            ),
            const SizedBox(width: 6),
            AppText.labelSmall(
              label,
              color: isSelected
                  ? design.colors.accent2
                  : design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
