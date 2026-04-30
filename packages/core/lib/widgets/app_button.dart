import 'package:flutter/widgets.dart';
import '../design/design_provider.dart';
import '../navigation/app_route.dart';
import '../accessibility/app_semantics.dart';
import '../accessibility/app_focusable.dart';
import 'app_text.dart';
import 'app_loading_indicator.dart';

/// Platform-neutral button widget with semantic variants.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.variant = AppButtonVariant.primary,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48.0,
    this.padding,
    this.leading,
    this.trailing,
    this.borderColor,
    this.labelStyle,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? onNavigate; // If provided, navigates to this widget
  final AppButtonVariant variant;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? labelStyle;
  final bool loading;

  // Semantic constructors
  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48.0,
    this.padding,
    this.leading,
    this.trailing,
    this.borderColor,
    this.labelStyle,
    this.loading = false,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.onNavigate,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 48.0,
    this.padding,
    this.leading,
    this.trailing,
    this.borderColor,
    this.labelStyle,
    this.loading = false,
  }) : variant = AppButtonVariant.secondary;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isDisabled = (onPressed == null && onNavigate == null) || loading;

    final effectiveBackgroundColor =
        backgroundColor ??
        (variant == AppButtonVariant.primary
            ? (isDisabled ? design.colors.border : design.colors.primary)
            : design.colors.surface);

    final effectiveForegroundColor =
        foregroundColor ??
        (variant == AppButtonVariant.primary
            ? design.colors.onPrimary
            : (isDisabled
                  ? design.colors.textTertiary
                  : design.colors.primary));

    final effectiveBorderColor =
        borderColor ??
        (variant == AppButtonVariant.secondary
            ? (isDisabled ? design.colors.border : design.colors.primary)
            : const Color(0x00000000)); // Transparent

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
          constraints: BoxConstraints(minHeight: height),
          child: Container(
            width: fullWidth ? double.infinity : null,
            padding:
                padding ??
                EdgeInsetsDirectional.symmetric(
                  horizontal: design.spacing.lg,
                  vertical: design.spacing.md,
                ),
            decoration: BoxDecoration(
              color: effectiveBackgroundColor,
              borderRadius: design.radius.button,
              border: Border.all(
                color: effectiveBorderColor,
                width: variant == AppButtonVariant.secondary ? 1.5 : 0,
              ),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: effectiveForegroundColor,
                size: design.iconSize.md,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Original Content (Hidden but keeps size if not loading)
                  Opacity(
                    opacity: loading ? 0.0 : 1.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leading != null) ...[
                          leading!,
                          SizedBox(width: design.spacing.sm),
                        ],
                        Flexible(
                          child: AppText.labelBold(
                            label,
                            color: effectiveForegroundColor,
                            style: labelStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (trailing != null) ...[
                          SizedBox(width: design.spacing.sm),
                          trailing!,
                        ],
                      ],
                    ),
                  ),

                  // Loading Indicator
                  if (loading)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: AppLoadingIndicator(
                        color: effectiveForegroundColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum AppButtonVariant { primary, secondary }
