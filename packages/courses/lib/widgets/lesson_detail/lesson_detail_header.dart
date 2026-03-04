import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

/// Minimalist header for the lesson detail screen.
///
/// Contains a back button, bookmark toggle, and download action.
class LessonDetailHeader extends StatelessWidget {
  const LessonDetailHeader({
    super.key,
    required this.onBack,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onDownload,
  });

  /// Callback when the back button is pressed.
  final VoidCallback onBack;

  /// Whether the current lesson is bookmarked.
  final bool isBookmarked;

  /// Callback to toggle the bookmark state.
  final VoidCallback onBookmarkToggle;

  /// Callback to trigger content download.
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm,
          ),
          child: Row(
            children: [
              AppFocusable(
                onTap: onBack,
                borderRadius: BorderRadius.circular(design.radius.md),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.xs,
                    vertical: design.spacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.chevronLeft,
                        size: 20,
                        color: design.colors.textPrimary,
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.label(
                        l10n.curriculumBackButton,
                        color: design.colors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              _HeaderActionButton(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                onTap: onBookmarkToggle,
                ariaLabel: isBookmarked
                    ? l10n.lessonBookmarkRemove
                    : l10n.lessonBookmarkAdd,
              ),
              SizedBox(width: design.spacing.sm),
              _HeaderActionButton(
                icon: LucideIcons.download,
                onTap: onDownload,
                ariaLabel: l10n.lessonDownload,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
    required this.ariaLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String ariaLabel;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return AppSemantics.button(
      label: ariaLabel,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: design.colors.surface,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 16, color: design.colors.textPrimary),
          ),
        ),
      ),
    );
  }
}
