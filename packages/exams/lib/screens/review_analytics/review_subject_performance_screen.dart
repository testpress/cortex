import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:core/data/data.dart';
import 'review_analytics_controller.dart';
import 'widgets/analytics_header.dart';
import 'widgets/donut_legend.dart';
import 'widgets/overall_performance_card.dart';
import 'widgets/section_donut_list.dart';
import 'widgets/section_table.dart';

class ReviewSubjectPerformanceScreen extends ConsumerWidget {
  const ReviewSubjectPerformanceScreen({
    super.key,
    required this.assessmentTitle,
    required this.questions,
    required this.attemptStates,
    this.attempt,
    this.exam,
    required this.onBack,
  });

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
            AnalyticsHeader(
              title: l10n.reviewSubjectPerformanceTitle,
              onBack: onBack,
            ),
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
          AnalyticsHeader(
            title: l10n.reviewSubjectPerformanceTitle,
            onBack: onBack,
          ),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                design.spacing.xxl,
              ),
              children: [
                AppSemantics.header(
                  label: l10n.labelOverallPerformance,
                  child: AppText.title(
                    l10n.labelOverallPerformance,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                OverallPerformanceCard(overview: overview),
                SizedBox(height: design.spacing.xl),
                AppSemantics.header(
                  label: l10n.labelSectionPerformance,
                  child: AppText.title(
                    l10n.labelSectionPerformance,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: design.spacing.xs),
                AppText.bodySmall(
                  l10n.reviewSubjectPerformanceDesc,
                  color: design.colors.textSecondary,
                ),
                SizedBox(height: design.spacing.md),
                if (state.isLoading)
                  const Center(child: AppLoadingIndicator())
                else if (state.errorMessage != null)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(design.spacing.md),
                      child: AppText.body(
                        l10n.reviewSubjectAnalyticsError(
                          state.errorMessage ?? '',
                        ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
