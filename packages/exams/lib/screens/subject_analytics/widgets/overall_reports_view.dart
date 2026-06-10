import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import '../../../../providers/analytics_providers.dart';
import '../subject_analytics_screen.dart';
import 'bar_chart.dart';

class OverallReportsView extends ConsumerWidget {
  const OverallReportsView({
    super.key,
    this.parentId,
    this.activeFilter = 'All',
  });

  final String? parentId;
  final String activeFilter;

  Widget _buildSingleLegendItem(String filter, DesignConfig design) {
    return switch (filter) {
      'Correct' => _LegendItem(
        label: 'Strength / Correct',
        color: design.correctColor,
      ),
      'Incorrect' => _LegendItem(
        label: 'Weakness / Incorrect',
        color: design.incorrectColor,
      ),
      'Unanswered' => _LegendItem(
        label: 'Unanswered',
        color: design.unansweredColor,
      ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final parsedParentId = parentId != null ? int.tryParse(parentId!) : null;
    final subjectsAsync = ref.watch(subjectAnalyticsProvider(parsedParentId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Legend - dynamic height, horizontal padding using design tokens, bottom border
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm + design.spacing.xs,
          ),
          decoration: BoxDecoration(
            color: design.colors.card,
            border: Border(
              bottom: BorderSide(color: design.colors.divider, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: activeFilter == 'All'
                ? [
                    _LegendItem(label: 'Strength', color: design.correctColor),
                    SizedBox(width: design.spacing.md),
                    _LegendItem(
                      label: 'Weakness',
                      color: design.incorrectColor,
                    ),
                    SizedBox(width: design.spacing.md),
                    _LegendItem(
                      label: 'Unanswered',
                      color: design.unansweredColor,
                    ),
                  ]
                : [_buildSingleLegendItem(activeFilter, design)],
          ),
        ),

        // List
        Expanded(
          child: subjectsAsync.when(
            data: (subjects) {
              if (subjects.isEmpty) {
                return const Center(child: AppText.body('No subjects found.'));
              }
              return AppScroll(
                padding: EdgeInsets.symmetric(
                  vertical: design.spacing.sm + design.spacing.xs,
                ),
                children: [
                  for (final subjectAnalytics in subjects) ...[
                    subjectAnalytics.isLeaf
                        ? AppFocusable(
                            onTap: () {
                              context.push(
                                '/exams/analytics/topic/${subjectAnalytics.id}',
                                extra: subjectAnalytics,
                              );
                            },
                            child: BarRow(
                              subjectAnalytics: subjectAnalytics,
                              activeFilter: activeFilter,
                            ),
                          )
                        : AppFocusable(
                            onTap: () {
                              context.push(
                                '/exams/analytics/${subjectAnalytics.id}',
                                extra: subjectAnalytics,
                              );
                            },
                            child: BarRow(
                              subjectAnalytics: subjectAnalytics,
                              activeFilter: activeFilter,
                            ),
                          ),
                    SizedBox(height: design.spacing.sm + design.spacing.xs),
                  ],
                ],
              );
            },
            loading: () => const Center(child: AppLoadingIndicator()),
            error: (err, stack) => Center(
              child: AppText.body(
                'Error loading subjects: $err',
                color: design.colors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: design.spacing.sm,
          height: design.spacing.sm,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: design.spacing.sm),
        AppText.xs(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            letterSpacing: -0.08,
          ),
          color: design.colors.textPrimary,
        ),
      ],
    );
  }
}
