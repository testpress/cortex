import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../localization/l10n_helper.dart';
import 'app_text.dart';
import 'app_button.dart';

/// A reusable error view with optional title, message, and retry action.
///
/// Uses design tokens for consistent spacing and typography.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.padding,
  });

  /// Optional title for the error. Defaults to l10n.errorGenericTitle.
  final String? title;

  /// Optional message for the error. Defaults to l10n.errorGenericMessage.
  final String? message;

  /// Optional retry callback. If provided, a retry button is shown.
  final VoidCallback? onRetry;

  /// Optional padding for the view.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.surface,
      child: Padding(
        padding: padding ?? EdgeInsets.all(design.spacing.xl),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.alertCircle,
                size: 48,
                color: design.colors.error,
              ),
              SizedBox(height: design.spacing.md),
              AppText.title(
                title ?? l10n.errorGenericTitle,
                color: design.colors.textPrimary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: design.spacing.sm),
              AppText.body(
                message ?? l10n.errorGenericMessage,
                color: design.colors.textPrimary,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: design.spacing.lg),
                AppButton.primary(label: l10n.labelRetry, onPressed: onRetry!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
