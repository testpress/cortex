import 'package:flutter/widgets.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../tokens/typography.dart';
import '../navigation/app_route.dart';
import '../accessibility/app_semantics.dart';
import 'app_text.dart';

/// Platform-neutral button widget with semantic variants.
///
/// Replaces Material's ElevatedButton/TextButton and Cupertino's
/// CupertinoButton with a custom implementation that looks identical
/// on all platforms.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? onNavigate; // If provided, navigates to this widget
  final AppButtonVariant variant;
  final bool fullWidth;

  // Semantic constructors
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.fullWidth = false,
  }) : variant = AppButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null && onNavigate == null;

    final backgroundColor = variant == AppButtonVariant.primary
        ? (isDisabled ? AppColors.border : AppColors.primary)
        : AppColors.surface;

    final foregroundColor = variant == AppButtonVariant.primary
        ? AppColors.onPrimary
        : (isDisabled ? AppColors.textTertiary : AppColors.primary);

    final borderColor = variant == AppButtonVariant.secondary
        ? (isDisabled ? AppColors.border : AppColors.primary)
        : const Color(0x00000000); // Transparent

    void handleTap() {
      if (onNavigate != null) {
        Navigator.of(context).push(AppRoute(page: onNavigate!));
      } else if (onPressed != null) {
        onPressed!();
      }
    }

    return AppSemantics.button(
      label: label,
      onTap: handleTap,
      enabled: !isDisabled,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 48.0, // WCAG 2.5.5 + Android/iOS accessibility standard
        ),
        child: GestureDetector(
          onTap: isDisabled ? null : handleTap,
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
            child: Center(
              child: AppText(
                label,
                style: AppTypography.label,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary }
