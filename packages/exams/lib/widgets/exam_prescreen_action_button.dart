import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamPrescreenActionButton extends StatelessWidget {
  final bool isButtonEnabled;

  /// Shows "Resume Exam Online" — user has an active running attempt.
  final bool isResuming;

  /// Shows "Retake Exam Online" — user has completed attempts but no running one.
  /// [isResuming] takes precedence over [isRetaking].
  final bool isRetaking;

  final VoidCallback? onTap;

  /// Triggered only when the "Retake Incorrect" button is tapped in the retake scenario.
  final VoidCallback? onRetakeIncorrectTap;

  const ExamPrescreenActionButton({
    super.key,
    required this.isButtonEnabled,
    required this.isResuming,
    this.isRetaking = false,
    this.onTap,
    this.onRetakeIncorrectTap,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    if (isResuming || !isRetaking) {
      final label = isResuming ? l10n.resumeExamOnline : l10n.startExamOnline;
      return Skeleton.ignore(
        child: AppButton.primary(
          label: label,
          onPressed: isButtonEnabled ? onTap : null,
          fullWidth: true,
        ),
      );
    }

    // Retaking scenario: Split horizontally into two buttons
    return Skeleton.ignore(
      child: Row(
        children: [
          Expanded(
            child: AppButton.secondary(
              label: l10n.retakeExamOnline,
              onPressed: isButtonEnabled ? onTap : null,
              borderColor: design.colors.primary,
              foregroundColor: design.colors.primary,
              fullWidth: true,
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppButton.primary(
              label: l10n.retakeIncorrectExamOnline,
              onPressed: isButtonEnabled ? onRetakeIncorrectTap : null,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
