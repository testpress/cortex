import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../../models/assessment_model.dart';

class AssessmentHeader extends StatelessWidget {
  final Assessment assessment;
  final int answeredCount;
  final VoidCallback onExit;

  const AssessmentHeader({
    super.key,
    required this.assessment,
    required this.answeredCount,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        MediaQuery.of(context).padding.top + design.spacing.md,
        design.spacing.md,
        design.spacing.md,
      ),
      color: design.colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onExit,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.chevronLeft,
                      color: design.colors.textPrimary,
                      size: 20,
                    ),
                    SizedBox(width: design.spacing.xs),
                    AppText.body(
                      l10n.assessmentExit,
                      color: design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: design.spacing.md),
          AppText.headline(
            assessment.title,
            style: TextStyle(
              fontSize: design.typographyScale.xl.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
