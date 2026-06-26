import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class AnalyticsHeader extends StatelessWidget {
  const AnalyticsHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final localizedTitle = l10n.reviewAnalyticsForTitle(title);

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
      child: AppSemantics.button(
        label: localizedTitle,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ), // Optical alignment with first line
                  child: Icon(
                    LucideIcons.arrowLeft,
                    color: design.colors.textPrimary,
                    size: 22,
                  ),
                ),
                SizedBox(width: design.spacing.sm),
                Expanded(
                  child: AppText.title(
                    localizedTitle,
                    color: design.colors.textPrimary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
