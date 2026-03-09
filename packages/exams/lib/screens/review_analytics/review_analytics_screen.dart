import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import '../../data/mock_review_analytics.dart';
import '../../models/review_route_payload.dart';
import '../../models/test_model.dart';
import 'widgets/analytics_header.dart';
import 'widgets/explore_details_card.dart';
import 'widgets/hero_donut_card.dart';
import 'widgets/metrics_grid.dart';
import 'widgets/overall_performance_card.dart';
import 'widgets/section_donut_list.dart';
import 'widgets/section_table.dart';

class ReviewAnalyticsScreen extends StatelessWidget {
  const ReviewAnalyticsScreen({
    super.key,
    required this.testId,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    required this.onBack,
  });

  final String testId;
  final String assessmentTitle;
  final List<TestQuestion> questions;
  final Map<String, TestAttemptAnswer> attemptStates;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final dataset = MockReviewAnalyticsFactory.createDataset(
      questions: questions,
      attemptStates: attemptStates,
    );
    final overview = dataset.overview;

    return ColoredBox(
      color: design.colors.canvas,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnalyticsHeader(title: assessmentTitle, onBack: onBack),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.lg,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                AppSemantics.header(
                  label: 'Performance Overview',
                  child: AppText.xl2(
                    'Performance Overview',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                MetricsGrid(overview: overview),
                SizedBox(height: design.spacing.md),
                HeroDonutCard(overview: overview),
                SizedBox(height: design.spacing.md),
                OverallPerformanceCard(overview: overview),
                SizedBox(height: design.spacing.xl),
                AppSemantics.header(
                  label: 'Section Performance',
                  child: AppText.xl2(
                    'Section Performance',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.body(
                  'Breakdown of your performance across each subject',
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.md),
                SectionDonutList(sections: dataset.sections),
                SizedBox(height: design.spacing.md),
                const DonutLegend(),
                SizedBox(height: design.spacing.md),
                SectionTable(
                  sections: dataset.sections,
                  overall: dataset.sectionTotals,
                ),
                SizedBox(height: design.spacing.xl),
                ExploreDetailsCard(
                  onExamReviewTap: () {
                    context.push(
                      '/study/test/$testId/review-answers',
                      extra: ReviewRoutePayload(
                        assessmentTitle: assessmentTitle,
                        questions: questions,
                        attemptStates: attemptStates,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
