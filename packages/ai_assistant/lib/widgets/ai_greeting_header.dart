import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class AIGreetingHeader extends StatelessWidget {
  final String userName;
  final String studyInsight;

  const AIGreetingHeader({
    super.key,
    required this.userName,
    required this.studyInsight,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.border, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              LucideIcons.sparkles,
              size: design.iconSize.lg,
              color: design.colors.primary,
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.xl(
                  l10n.aiAssistantGreeting(userName),
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                AppText.sm(
                  l10n.aiAssistantStudyInsight(studyInsight),
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.sm),
                AppText.xs(
                  l10n.aiAssistantPoweredBy,
                  color: design.colors.textSecondary.withValues(alpha: 0.82),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
