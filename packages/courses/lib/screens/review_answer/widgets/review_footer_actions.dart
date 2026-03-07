import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class ReviewFooterActions extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onAskDoubt;
  final VoidCallback onComment;
  final VoidCallback onReport;

  const ReviewFooterActions({
    super.key,
    required this.l10n,
    required this.onAskDoubt,
    required this.onComment,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: design.spacing.sm,
      ),
      padding: EdgeInsets.all(design.spacing.md),
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(color: design.colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FooterActionButton(
              label: l10n.labelAskDoubt,
              icon: LucideIcons.helpCircle,
              bg: design.colors.accent2.withValues(
                alpha: design.isDark ? 0.2 : 0.08,
              ),
              textColor: design.colors.accent2,
              borderColor: design.colors.accent2.withValues(
                alpha: design.isDark ? 0.4 : 0.2,
              ),
              onTap: onAskDoubt,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _FooterActionButton(
              label: l10n.labelComment,
              icon: LucideIcons.messageCircle,
              bg: design.colors.surfaceVariant.withValues(
                alpha: design.isDark ? 0.5 : 1.0,
              ),
              textColor: design.colors.textSecondary,
              borderColor: design.colors.border,
              onTap: onComment,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _FooterActionButton(
              label: l10n.labelReport,
              icon: LucideIcons.flag,
              bg: design.colors.accent5.withValues(
                alpha: design.isDark ? 0.2 : 0.08,
              ),
              textColor: design.colors.accent5,
              borderColor: design.colors.accent5.withValues(
                alpha: design.isDark ? 0.4 : 0.2,
              ),
              onTap: onReport,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _FooterActionButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 6),
            AppText.caption(label, color: textColor),
          ],
        ),
      ),
    );
  }
}
