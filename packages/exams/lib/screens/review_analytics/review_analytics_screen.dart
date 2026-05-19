import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import '../../models/review_route_payload.dart';
import 'review_analytics_controller.dart';
import 'widgets/analytics_header.dart';
import 'widgets/donut_legend.dart';
import 'widgets/explore_details_card.dart';
import 'widgets/hero_donut_card.dart';
import 'widgets/metrics_grid.dart';
import 'widgets/overall_performance_card.dart';
import 'widgets/section_donut_list.dart';
import 'widgets/section_table.dart';

class ReviewAnalyticsScreen extends ConsumerWidget {
  const ReviewAnalyticsScreen({
    super.key,
    required this.testId,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
    required this.onBack,
  });

  final String testId;
  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
  final AttemptDto? attempt;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);

    final param = ReviewAnalyticsParam(
      attempt: attempt,
      questions: questions,
      attemptStates: attemptStates,
    );

    final state = ref.watch(reviewAnalyticsControllerProvider(param));
    final overview = state.overview;

    if (overview == null) {
      return ColoredBox(
        color: design.colors.canvas,
        child: Column(
          children: [
            AnalyticsHeader(title: assessmentTitle, onBack: onBack),
            const Expanded(child: Center(child: AppLoadingIndicator())),
          ],
        ),
      );
    }

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
                if (state.isLoading)
                  const Center(child: AppLoadingIndicator())
                else if (state.errorMessage != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AppText.body(
                        'Failed to load subject analytics: ${state.errorMessage}',
                        color: design.colors.error,
                      ),
                    ),
                  )
                else ...[
                  SectionDonutList(sections: state.sections),
                  SizedBox(height: design.spacing.md),
                  const DonutLegend(),
                  SizedBox(height: design.spacing.md),
                  if (state.sectionTotals != null)
                    SectionTable(
                      sections: state.sections,
                      overall: state.sectionTotals!,
                    ),
                ],
                SizedBox(height: design.spacing.xl),
                ExploreDetailsCard(
                  onExamReviewTap: () {
                    context.push(
                      '/study/test/$testId/review-answers',
                      extra: ReviewRoutePayload(
                        assessmentTitle: assessmentTitle,
                        questions: questions,
                        attemptStates: attemptStates,
                        attempt: attempt,
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
