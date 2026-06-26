import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import '../../../models/section_performance_overview.dart';
import 'donut_chart.dart';

class SectionDonutList extends StatelessWidget {
  const SectionDonutList({super.key, required this.sections});

  final List<SectionPerformanceOverview> sections;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    final l10n = L10n.of(context);

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Center(
        child: AppSemantics.scrollableList(
          label: l10n.labelSectionPerformance,
          itemCount: sections.length,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < sections.length; i++) ...[
                  if (i > 0) SizedBox(width: design.spacing.md),
                  _buildCard(context, sections[i]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, SectionPerformanceOverview section) {
    final design = Design.of(context);
    return AppSemantics.container(
      label: section.name,
      child: Container(
        height: 220,
        padding: EdgeInsets.all(design.spacing.md),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: design.colors.border.withValues(alpha: 0.6),
          ),
        ),
        child: SizedBox(
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DonutChart(
                correct: section.correct,
                incorrect: section.incorrect,
                unanswered: section.unanswered,
                size: 100,
                strokeWidth: 14,
              ),
              SizedBox(height: design.spacing.sm),
              AppText.body(
                section.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
