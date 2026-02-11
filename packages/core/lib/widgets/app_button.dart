import 'package:flutter/widgets.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';

/// Platform-neutral button widget with semantic variants.
///
/// Replaces Material's ElevatedButton/TextButton and Cupertino's
/// CupertinoButton with a custom implementation that looks identical
/// on all platforms.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool fullWidth;

  // Semantic constructors
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    final backgroundColor = variant == AppButtonVariant.primary
        ? (isDisabled ? AppColors.border : AppColors.primary)
        : AppColors.surface;

    final foregroundColor = variant == AppButtonVariant.primary
        ? AppColors.onPrimary
        : (isDisabled ? AppColors.textTertiary : AppColors.primary);

    final borderColor = variant == AppButtonVariant.secondary
        ? (isDisabled ? AppColors.border : AppColors.primary)
        : Colors.transparent;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.button,
          border: Border.all(
            color: borderColor,
            width: variant == AppButtonVariant.secondary ? 1.5 : 0,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.label.copyWith(color: foregroundColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary }
