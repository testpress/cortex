import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + design.spacing.md,
        left: design.spacing.md,
        right: design.spacing.md,
        bottom: design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(bottom: BorderSide(color: design.colors.border)),
        boxShadow: design.shadows.surfaceSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSemantics.button(
            label: 'Back',
            onTap: onBack,
            child: AppFocusable(
              onTap: onBack,
              borderRadius: BorderRadius.circular(design.radius.md),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: design.spacing.xs,
                  horizontal: design.spacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      color: design.colors.textPrimary,
                      size: design.iconSize.md,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.subtitle(
                      'Back',
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: design.spacing.sm),
          AppSemantics.header(
            label: 'Review Analytics for $title',
            child: AppText.headline(
              'Review Analytics for $title',
              color: design.colors.textPrimary,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
