import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Floating action button with an expandable actions menu for PDF lessons.
///
/// When both AI and Doubt actions are enabled, tapping the FAB expands
/// a speed-dial menu allowing the user to choose between "Ask AI (PDF)"
/// and "Ask Doubt".
///
/// When only the AI action is enabled, tapping triggers [onAskAi] directly.
class PdfActionsFab extends StatelessWidget {
  const PdfActionsFab({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onAskAi,
    this.onAskDoubt,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAskAi;
  final VoidCallback? onAskDoubt;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final hasMenu = onAskDoubt != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isExpanded && hasMenu) ...[
          Container(
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.xl),
              border: Border.all(color: design.colors.border),
              boxShadow: design.shadows.floating,
            ),
            padding: EdgeInsets.symmetric(
              vertical: design.spacing.xs,
              horizontal: design.spacing.xs,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ActionMenuItem(
                  key: const ValueKey('action_ask_ai_pdf'),
                  icon: LucideIcons.fileText,
                  label: l10n.labelAskAiPdf,
                  onTap: onAskAi,
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: design.spacing.sm),
                  color: design.colors.divider.withValues(alpha: 0.5),
                ),
                _ActionMenuItem(
                  key: const ValueKey('action_ask_doubt'),
                  icon: LucideIcons.helpCircle,
                  label: l10n.labelAskDoubt,
                  onTap: onAskDoubt!,
                ),
              ],
            ),
          ),
          SizedBox(height: design.spacing.md),
        ],
        AppSemantics.button(
          label: isExpanded
              ? l10n.commonCloseButton
              : (hasMenu ? l10n.labelAskAiPdf : l10n.labelAskAi),
          onTap: hasMenu ? onToggle : onAskAi,
          child: AppFocusable(
            onTap: hasMenu ? onToggle : onAskAi,
            borderRadius: BorderRadius.circular(design.radius.full),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: design.colors.primary,
                shape: BoxShape.circle,
                boxShadow: design.shadows.floating,
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: design.motion.fast,
                child: Icon(
                  isExpanded ? LucideIcons.x : LucideIcons.sparkles,
                  key: ValueKey(isExpanded),
                  color: design.colors.onPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionMenuItem extends StatelessWidget {
  const _ActionMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: design.spacing.md,
              vertical: design.spacing.sm + 2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: design.colors.primary,
                  size: 20,
                ),
                SizedBox(width: design.spacing.sm + 2),
                AppText.labelBold(
                  label,
                  color: design.colors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
