import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AIQuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;

  const AIQuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppCard(
      onTap: onTap,
      showShadow: true,
      padding: EdgeInsets.all(design.spacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: BorderRadius.circular(design.radius.md),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.cardTitle(
                  title,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.caption(
                  description,
                  color: design.colors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
