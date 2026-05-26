import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class PauseConfirmationDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onPause;
  final VoidCallback onEnd;
  final bool disablePause;

  const PauseConfirmationDialog({
    super.key,
    required this.onCancel,
    required this.onPause,
    required this.onEnd,
    this.disablePause = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.overlay,
      alignment: Alignment.center,
      padding: EdgeInsets.all(design.spacing.xl),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: design.colors.surface,
          borderRadius: BorderRadius.circular(design.radius.xl),
          boxShadow: [
            BoxShadow(
              color: design.colors.shadow,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.all(design.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.logOut, size: 48, color: design.colors.accent2),
            SizedBox(height: design.spacing.lg),
            AppText.title(
              'Exit Exam',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: design.spacing.sm),
            AppText.body(
              disablePause
                  ? 'Are you sure you want to exit? You cannot pause this exam, so exiting will end it immediately.'
                  : 'Are you sure you want to exit? You can pause to resume later, or end the exam now.',
              textAlign: TextAlign.center,
              color: design.colors.textSecondary,
            ),
            SizedBox(height: design.spacing.xl),
            Row(
              children: [
                AppButton(
                  label: l10n.labelCancel,
                  onPressed: onCancel,
                  variant: AppButtonVariant.secondary,
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm,
                  ),
                ),
                const Spacer(),
                if (!disablePause) ...[
                  AppButton(
                    label: 'Pause',
                    onPressed: onPause,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm,
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                ],
                AppButton(
                  label: 'End',
                  backgroundColor: design.colors.error,
                  foregroundColor: design.colors.onError,
                  onPressed: onEnd,
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
