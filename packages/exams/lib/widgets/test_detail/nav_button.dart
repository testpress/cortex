import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// A reusable navigation button shared by the test and assessment screens.
///
/// Handles three visual states automatically:
///  - **Back** (`isBack: true`): outlined card-colored button, icon on the left.
///  - **Forward** (default): filled dark button, icon on the right.
///  - **Disabled** (`onTap: null`): muted border and text, no interaction.
class NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isBack;
  final bool loading;

  const NavButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isBack = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final bool isDisabled = (onTap == null) || loading;

    final Color bgColor = isBack || isDisabled
        ? design.colors.card
        : design.colors.textPrimary;
    final Color textColor = isDisabled
        ? design.colors.border
        : (isBack ? design.colors.textPrimary : design.colors.textInverse);
    final Color borderColor = isDisabled
        ? design.colors.border.withValues(alpha: 0.5)
        : (isBack ? design.colors.textSecondary : design.colors.textPrimary);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: AppLoadingIndicator(
                  color: textColor,
                ),
              ),
              const SizedBox(width: 8),
            ] else if (isBack) ...[
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
            ],
            AppText.body(
              label,
              color: textColor,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            if (!isBack && !loading) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
