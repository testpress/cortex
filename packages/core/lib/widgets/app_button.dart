import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../navigation/app_route.dart';
import '../accessibility/app_semantics.dart';
import '../accessibility/app_focusable.dart';
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
    final design = Design.of(context);
    final isDisabled = onPressed == null && onNavigate == null;

    final backgroundColor = variant == AppButtonVariant.primary
        ? (isDisabled ? design.colors.border : design.colors.primary)
        : design.colors.surface;

    final foregroundColor = variant == AppButtonVariant.primary
        ? design.colors.onPrimary
        : (isDisabled ? design.colors.textTertiary : design.colors.primary);

    final borderColor = variant == AppButtonVariant.secondary
        ? (isDisabled ? design.colors.border : design.colors.primary)
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
      child: AppFocusable(
        onTap: isDisabled ? null : handleTap,
        borderRadius: design.radius.button,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 48.0, // WCAG 2.5.5 + Android/iOS accessibility standard
          ),
          child: Container(
            width: fullWidth ? double.infinity : null,
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.lg,
              vertical: design.spacing.md,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: design.radius.button,
              border: Border.all(
                color: borderColor,
                width: variant == AppButtonVariant.secondary ? 1.5 : 0,
              ),
            ),
            child: Center(
              child: AppText(
                label,
                style: design.typography.label,
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
