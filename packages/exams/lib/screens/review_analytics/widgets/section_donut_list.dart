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
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        separatorBuilder: (_, index) => SizedBox(width: design.spacing.md),
        itemBuilder: (context, index) {
          final section = sections[index];
          return Container(
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  DonutChart(
                    correct: section.correct,
                    incorrect: section.incorrect,
                    unanswered: section.unanswered,
                    size: 120,
                    strokeWidth: 14,
                  ),
                  SizedBox(height: design.spacing.sm),
                  AppText.body(
                    section.name,
                    textAlign: TextAlign.center,
                    color: design.colors.textPrimary,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
