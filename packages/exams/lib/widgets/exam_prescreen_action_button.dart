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
        child: AppSemantics.button(
          label: label,
          onTap: onTap,
          enabled: isButtonEnabled,
          child: _buildButtonContainer(context, label, onTap, isPrimary: true),
        ),
      );
    }

    // Retaking scenario: Split horizontally into two buttons
    return Skeleton.ignore(
      child: Row(
        children: [
          Expanded(
            child: AppSemantics.button(
              label: l10n.retakeExamOnline,
              onTap: onTap,
              enabled: isButtonEnabled,
              child: _buildButtonContainer(
                context,
                l10n.retakeExamOnline,
                onTap,
                isPrimary: false,
              ),
            ),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: AppSemantics.button(
              label: l10n.retakeIncorrectExamOnline,
              onTap: onRetakeIncorrectTap,
              enabled: isButtonEnabled,
              child: _buildButtonContainer(
                context,
                l10n.retakeIncorrectExamOnline,
                onRetakeIncorrectTap,
                isPrimary: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonContainer(
    BuildContext context,
    String label,
    VoidCallback? action, {
    required bool isPrimary,
  }) {
    final design = Design.of(context);

    final Color bgColor;
    final Color textColor;
    final Border? border;

    if (!isButtonEnabled) {
      bgColor = design.colors.border.withValues(alpha: 0.5);
      textColor = design.colors.textSecondary;
      border = null;
    } else if (isPrimary) {
      bgColor = design.colors.primary;
      textColor = design.colors.onPrimary;
      border = null;
    } else {
      bgColor = design.colors.surface;
      textColor = design.colors.primary;
      border = Border.all(color: design.colors.primary, width: 1.5);
    }

    return GestureDetector(
      onTap: isButtonEnabled ? action : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(design.spacing.md),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.lg),
          border: border,
        ),
        child: AppText.body(
          label,
          textAlign: TextAlign.center,
          style: design.typography.body.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
