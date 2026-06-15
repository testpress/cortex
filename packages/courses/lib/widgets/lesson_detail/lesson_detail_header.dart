import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:core/core.dart';

/// Minimalist header for the lesson detail screen.
///
/// Contains a back button, bookmark toggle, and download action.
class LessonDetailHeader extends StatelessWidget {
  const LessonDetailHeader({
    super.key,
    required this.lessonTitle,
    required this.onBack,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.onDownload,
  });

  /// The title of the lesson.
  final String lessonTitle;

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
    final padding = MediaQuery.of(context).padding;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        padding.top + 12,
        16,
        12,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Back button
              Row(
                children: [
                  AppSemantics.button(
                    label: l10n.curriculumBackButton,
                    onTap: onBack,
                    child: AppFocusable(
                      onTap: onBack,
                      borderRadius: design.radius.button,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.chevronLeft,
                            size: 20,
                            color: design.colors.textPrimary,
                          ),
                          const SizedBox(width: 8),
                          AppText.label(
                            l10n.curriculumBackButton,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Lesson Title
              AppText.headline(
                lessonTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Positioned(
            right: 0,
            top:
                -8, // Centers the 36px action buttons against the 20px back button
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeaderActionButton(
                  icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  onTap: onBookmarkToggle,
                  ariaLabel: isBookmarked
                      ? l10n.lessonBookmarkRemove
                      : l10n.lessonBookmarkAdd,
                ),
                SizedBox(width: design.spacing.xs),
                _HeaderActionButton(
                  icon: LucideIcons.download,
                  onTap: onDownload,
                  ariaLabel: l10n.lessonDownload,
                ),
              ],
            ),
          ),
        ],
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
