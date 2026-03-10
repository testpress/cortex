import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// A premium, centered logout confirmation bottom sheet.
class LogoutConfirmationSheet extends StatelessWidget {
  const LogoutConfirmationSheet({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        design.spacing.sm,
        0,
        design.spacing.sm,
        design.spacing.lg,
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
              design.spacing.lg,
              design.spacing.md,
              design.spacing.lg,
              design.spacing.lg,
            ),
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.all(
                Radius.circular(design.radius.xxl),
              ),
              boxShadow: design.shadows.floating,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle Bar
                Container(
                  width: design.spacing.xl * 1.5,
                  height: 4,
                  decoration: BoxDecoration(
                    color: design.colors.border,
                    borderRadius: BorderRadius.circular(design.radius.full),
                  ),
                ),

                SizedBox(height: design.spacing.lg),

                // Icon
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: design.colors.error.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(design.radius.lg),
                  ),
                  child: Icon(
                    LucideIcons.alertTriangle,
                    color: design.colors.error,
                  ),
                ),
                SizedBox(height: design.spacing.md),

                // Text section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.body(
                      l10n.logoutConfirmationTitle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: design.spacing.xs),
                    AppText.caption(
                      l10n.logoutConfirmationMessage,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: design.spacing.lg),

                // Actions
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton.primary(
                      label: l10n.logoutButtonLabel,
                      fullWidth: true,
                      backgroundColor: design.colors.error,
                      leading: const Icon(LucideIcons.logOut),
                      onPressed: onConfirm,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: design.spacing.sm),
                    AppButton.secondary(
                      label: l10n.labelCancel,
                      fullWidth: true,
                      backgroundColor: design.colors.surfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                      foregroundColor: design.colors.textPrimary,
                      borderColor: const Color(0x00000000),
                      onPressed: onCancel,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
