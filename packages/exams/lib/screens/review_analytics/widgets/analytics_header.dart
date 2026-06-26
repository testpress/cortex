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
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: design.spacing.xs,
          horizontal: design.spacing.xs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSemantics.button(
              label: l10n.actionGoBack,
              onTap: onBack,
              child: AppFocusable(
                onTap: onBack,
                borderRadius: BorderRadius.circular(design.radius.md),
                child: Padding(
                  padding: EdgeInsets.all(design.spacing.xs),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Icon(
                      LucideIcons.arrowLeft,
                      color: design.colors.textPrimary,
                      size: design.iconSize.md,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: design.spacing.sm),
            Expanded(
              child: AppSemantics.header(
                label: localizedTitle,
                child: AppText.title(
                  localizedTitle,
                  color: design.colors.textPrimary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
