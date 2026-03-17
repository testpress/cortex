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

    return Container(
      padding: EdgeInsets.all(design.spacing.lg),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(24), // Increased radius
        border: Border.all(
          color: highlightColor.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, // Slightly larger
                height: 44,
                decoration: BoxDecoration(
                  color: highlightBackground,
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: Center(
                  child: Icon(
                    LucideIcons.brain,
                    color: highlightColor,
                    size: 22,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4), // Added space
                    AppText.caption(
                      l10n.aiAssistantStruggledTopicDesc,
                      color: design.colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: design.spacing.lg),
          Container(
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              color: design.colors.surface,
              borderRadius: BorderRadius.circular(16), // Softer radius
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.trendingDown,
                      size: 16,
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
                SizedBox(height: design.spacing.md), // Slightly more gap
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: design.colors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: topic.accuracy / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: highlightColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: design.spacing.md),
                    AppText.caption(
                      '${topic.accuracy.toInt()}% ↓',
                      color: highlightColor,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: design.spacing.lg),
          GestureDetector(
            onTap: onPracticeTap,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14), // Taller button
              decoration: BoxDecoration(
                color: highlightColor,
                borderRadius: BorderRadius.circular(
                  16,
                ), // Match inner container
              ),
              child: AppText.labelBold(
                l10n.aiAssistantPracticeNow,
                textAlign: TextAlign.center,
                color: design.colors.onPrimary,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
