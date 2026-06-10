import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DoubtContextBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const DoubtContextBadge({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.accent2.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.accent2.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: design.colors.accent2),
          const SizedBox(width: 8),
          Expanded(
            child: AppText.bodySmall(text, color: design.colors.accent2),
          ),
        ],
      ),
    );
  }
}
