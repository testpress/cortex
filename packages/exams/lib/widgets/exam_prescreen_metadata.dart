import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'exam_prescreen_vertical_stat.dart';
import 'exam_prescreen_timeline.dart';
import 'exam_prescreen_mark_card.dart';

class ExamPrescreenMetadata extends StatelessWidget {
  final bool isMetadataLoading;
  final String? title;
  final String startDateStr;
  final String endDateStr;
  final String questionCountStr;
  final String durationVal;
  final String? durationSuffix;
  final String totalMarksVal;
  final String correctMarks;
  final String wrongMarks;

  const ExamPrescreenMetadata({
    super.key,
    required this.isMetadataLoading,
    this.title,
    required this.startDateStr,
    required this.endDateStr,
    required this.questionCountStr,
    required this.durationVal,
    this.durationSuffix,
    required this.totalMarksVal,
    required this.correctMarks,
    required this.wrongMarks,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Skeletonizer(
      enabled: isMetadataLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            AppText.headline(
              title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: design.colors.textPrimary,
              ),
            ),
            SizedBox(height: design.spacing.md),
          ],
          ExamPrescreenTimeline(
            design: design,
            startDateStr: startDateStr,
            endDateStr: endDateStr,
          ),
          if (startDateStr.isNotEmpty || endDateStr.isNotEmpty) ...[
            const SizedBox(height: 24),
            Container(
              height: 1,
              width: double.infinity,
              color: design.colors.border.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
          ],
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ExamPrescreenVerticalStat(
                    design: design,
                    icon: LucideIcons.fileQuestion,
                    label: 'Total Questions',
                    value: questionCountStr,
                  ),
                ),
                Container(
                  width: 1,
                  color: design.colors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: ExamPrescreenVerticalStat(
                    design: design,
                    icon: LucideIcons.clock,
                    label: 'Duration',
                    value: durationVal,
                    suffix: durationSuffix,
                  ),
                ),
                Container(
                  width: 1,
                  color: design.colors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: ExamPrescreenVerticalStat(
                    design: design,
                    icon: LucideIcons.award,
                    label: 'Total Marks',
                    value: totalMarksVal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: design.colors.card,
              border: Border.all(
                color: design.colors.border.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(design.radius.xl),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ExamPrescreenMarkCard(
                    design: design,
                    icon: LucideIcons.checkCircle2,
                    color: design.colors.success,
                    label: 'Correct Answer',
                    value: correctMarks,
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: design.colors.border.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: ExamPrescreenMarkCard(
                    design: design,
                    icon: LucideIcons.xCircle,
                    color: design.colors.error,
                    label: 'Wrong Answer',
                    value: wrongMarks,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
