import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ReviewEmptyState extends StatelessWidget {
  final AppLocalizations l10n;
  const ReviewEmptyState({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: design.spacing.xxl),
        child: Column(
          children: [
            Icon(
              LucideIcons.search,
              size: 48,
              color: design.colors.textSecondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: design.spacing.md),
            AppText.body(
              l10n.reviewEmptyStateMessage,
              color: design.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
