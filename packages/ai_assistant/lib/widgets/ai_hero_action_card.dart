import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AIHeroActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;

  const AIHeroActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final accentColor = design.colors.accent2;
    final onAccentColor = design.colors.onPrimary;

    return Container(
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: design.radius.card,
        boxShadow: design.shadows.floating,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Background Sparkles/Decoration if wanted, but keep it clean
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              icon,
              size: 120,
              color: onAccentColor.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(design.spacing.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: onAccentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(design.radius.md),
                  ),
                  child: Icon(icon, color: onAccentColor, size: 28),
                ),
                SizedBox(width: design.spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText.xl(
                        title,
                        color: onAccentColor,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: design.spacing.xs),
                      AppText.caption(
                        description,
                        color: onAccentColor.withValues(alpha: 0.85),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                Icon(
                  LucideIcons.arrowRight,
                  color: onAccentColor.withValues(alpha: 0.7),
                  size: 20,
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}
