import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/ai_models.dart';

class AIRecommendationCard extends StatelessWidget {
  final WeakTopic topic;
  final VoidCallback? onPracticeTap;

  const AIRecommendationCard({
    super.key,
    required this.topic,
    this.onPracticeTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final subjectColors = design.subjectPalette.atIndex(
      topic.subjectColorIndex,
    );
    final highlightColor = design.colors.recommendationAccent;
    final highlightBackground = highlightColor.withValues(alpha: 0.12);

    return AppCard(
      onTap: onPracticeTap,
      padding: EdgeInsets.all(design.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: highlightBackground,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.brain,
                    color: highlightColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: design.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.cardTitle(
                      l10n.aiAssistantImproveTopicsTitle,
                      color: design.colors.textPrimary,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AppText.caption(
                      l10n.aiAssistantStruggledTopicDesc,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                color: design.colors.textTertiary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: design.spacing.md),
          Container(
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              color: design.colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.trendingDown,
                      size: 14,
                      color: subjectColors.accent,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.caption(
                      topic.subject,
                      color: design.colors.textSecondary,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    AppText.caption(' → ', color: design.colors.textSecondary),
                    Expanded(
                      child: AppText.caption(
                        topic.topic,
                        color: design.colors.textPrimary,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: design.colors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: topic.accuracy / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: highlightColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    AppText.caption(
                      '${topic.accuracy.toInt()}% ↓',
                      color: highlightColor.withValues(alpha: 0.8),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
