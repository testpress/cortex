import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import '../../models/review_route_payload.dart';
import 'review_analytics_controller.dart';
import 'widgets/analytics_header.dart';
import 'widgets/explore_details_card.dart';
import 'widgets/metrics_grid.dart';

class ReviewAnalyticsScreen extends ConsumerWidget {
  const ReviewAnalyticsScreen({
    super.key,
    required this.testId,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
    this.exam,
    required this.onBack,
  });

  final String testId;
  final String assessmentTitle;
  final List<QuestionDto> questions;
  final Map<String, AnswerDto> attemptStates;
  final AttemptDto? attempt;
  final ExamDto? exam;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final param = ReviewAnalyticsParam(
      attempt: attempt,
      exam: exam,
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
                  label: l10n.reviewPerformanceOverviewTitle,
                  child: AppText.xl2(
                    l10n.reviewPerformanceOverviewTitle,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                MetricsGrid(overview: overview),
                SizedBox(height: design.spacing.xl),
                ExploreDetailsCard(
                  onExamReviewTap: () {
                    final basePath = GoRouterState.of(
                      context,
                    ).uri.path.replaceFirst('/review-analytics', '');
                    context.push(
                      '$basePath/review-answers',
                      extra: ReviewRoutePayload(
                        assessmentTitle: assessmentTitle,
                        questions: questions,
                        attemptStates: attemptStates,
                        attempt: attempt,
                        exam: exam,
                      ),
                    );
                  },
                  onSubjectPerformanceTap: () {
                    final currentPath = GoRouterState.of(context).uri.path;
                    context.push(
                      '$currentPath/subject-performance',
                      extra: ReviewRoutePayload(
                        assessmentTitle: assessmentTitle,
                        questions: questions,
                        attemptStates: attemptStates,
                        attempt: attempt,
                        exam: exam,
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
