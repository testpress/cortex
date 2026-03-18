import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../data/ai_mock_data.dart';
import '../widgets/ai_quick_action_card.dart';
import '../widgets/ai_doubt_hero.dart';
import '../widgets/ai_recommendation_card.dart';
import '../widgets/ai_activity_item.dart';
import '../models/ai_models.dart';

class AIAssistantPage extends StatelessWidget {
  const AIAssistantPage({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final userName = AIMockData.userName;
    final weakTopics = AIMockData.weakTopics;
    final recentActivities = AIMockData.recentActivities;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        AIDoubtHero(
          userName: userName,
          onAskDoubtTap: () {},
          onSearchSolutionTap: () {},
        ),
        Padding(
          padding: EdgeInsets.all(design.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: design.spacing.md),
              AIQuickActionCard(
                icon: LucideIcons.fileText,
                title: l10n.aiAssistantPracticeExamTitle,
                description: l10n.aiAssistantPracticeExamDesc,
                iconColor: design.colors.accent1,
                iconBackgroundColor: design.colors.accent1.withValues(
                  alpha: 0.1,
                ),
                onTap: () {},
              ),
              SizedBox(height: design.spacing.lg),
              _buildSectionTitle(design, l10n.aiAssistantRecommendedTitle),
              SizedBox(height: design.spacing.md),
              AIRecommendationCard(topic: weakTopics[0], onPracticeTap: () {}),
              if (weakTopics.length > 1) ...[
                SizedBox(height: design.spacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(design, l10n.aiAssistantMoreTopicsTitle),
                    AppText.labelSmall(
                      l10n.aiAssistantViewAll,
                      color: design.colors.primary,
                    ),
                  ],
                ),
                SizedBox(height: design.spacing.md),
                ...weakTopics
                    .skip(1)
                    .map(
                      (topic) => Padding(
                        padding: EdgeInsets.only(bottom: design.spacing.md),
                        child: _buildSecondaryWeakTopicCard(design, topic),
                      ),
                    ),
              ],
              SizedBox(height: design.spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(design, l10n.aiAssistantRecentHelpTitle),
                  AppText.labelSmall(
                    l10n.aiAssistantViewAll,
                    color: design.colors.primary,
                  ),
                ],
              ),
              SizedBox(height: design.spacing.md),
              ...recentActivities.map(
                (activity) => Padding(
                  padding: EdgeInsets.only(bottom: design.spacing.md),
                  child: AIActivityItem(activity: activity, onTap: () {}),
                ),
              ),
              SizedBox(height: design.spacing.xl),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(DesignConfig design, String title) {
    return AppText.sectionHeader(
      title.toUpperCase(),
      color: design.colors.textSecondary.withValues(alpha: 0.85),
    );
  }

  Widget _buildSecondaryWeakTopicCard(DesignConfig design, WeakTopic topic) {
    final subjectColors = design.subjectPalette.atIndex(
      topic.subjectColorIndex,
    );
    final recommendationHighlight = design.colors.recommendationAccent;

    return AppCard(
      onTap: () {},
      padding: EdgeInsets.all(design.spacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.trendingDown,
                      size: 14,
                      color: subjectColors.accent,
                    ),
                    SizedBox(width: 4),
                    AppText.caption(
                      topic.subject,
                      color: design.colors.textSecondary,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                AppText.body(
                  topic.topic,
                  color: design.colors.textPrimary,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
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
                              color: recommendationHighlight,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    AppText.caption(
                      '${topic.accuracy.toInt()}%',
                      color: recommendationHighlight,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Icon(
            LucideIcons.chevronRight,
            color: design.colors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
