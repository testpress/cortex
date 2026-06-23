import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamPrescreenActionButton extends StatelessWidget {
  final bool isButtonEnabled;
  final bool isResuming;
  final VoidCallback? onTap;

  const ExamPrescreenActionButton({
    super.key,
    required this.isButtonEnabled,
    required this.isResuming,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Skeleton.ignore(
      child: AppSemantics.button(
        label: isResuming ? 'Resume Exam Online' : 'Start Exam Online',
        onTap: onTap,
        enabled: isButtonEnabled,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(design.spacing.md),
            decoration: BoxDecoration(
              color: isButtonEnabled
                  ? design.colors.primary
                  : design.colors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(design.radius.lg),
            ),
            child: AppText.body(
              isResuming ? l10n.resumeExamOnline : l10n.startExamOnline,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isButtonEnabled
                    ? design.colors.onPrimary
                    : design.colors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
