import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import '../accessibility/app_semantics.dart';
import 'app_text.dart';
import '../localization/l10n_helper.dart';
import '../accessibility/app_focusable.dart';

/// A premium, unified scaffold for lesson-like detail screens.
///
/// Provides a consistent header with actions and a sticky navigation footer
/// with "Next" and "Previous" capabilities. This ensures a seamless UX across
/// Videos, PDFs, HTML, and Exam content.
class LessonDetailShell extends StatelessWidget {
  const LessonDetailShell({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isBookmarked = false,
    this.onBookmarkToggle,
    this.onMarkAsCompleted,
    this.onBack,
    this.onNext,
    this.onPrevious,
    this.onDownload,
    this.headerActions,
    this.bottomBar,
    this.progress,
    this.isCompleted = false,
    this.stickyFooter = true,
  });

  /// The main title of the lesson.
  final String title;

  /// Optional subtitle (e.g. "Chapter 1 • Lesson 4").
  final String? subtitle;

  /// The specific content viewer (Video, PDF, Test, etc.).
  final Widget child;

  /// Whether the current lesson is bookmarked.
  final bool isBookmarked;

  /// Whether the current lesson is marked as completed.
  final bool isCompleted;

  /// Callback to toggle the bookmark state.
  final VoidCallback? onBookmarkToggle;

  /// Callback to mark the lesson as completed.
  final VoidCallback? onMarkAsCompleted;

  /// Callback for the back button.
  final VoidCallback? onBack;

  /// Callback for the "Next" action.
  final VoidCallback? onNext;

  /// Callback for the "Previous" action.
  final VoidCallback? onPrevious;

  /// Optional callback for content download.
  final VoidCallback? onDownload;

  /// Optional list of extra actions for the header.
  final List<Widget>? headerActions;

  /// Optional custom bottom bar (replaces the default navigation footer).
  final Widget? bottomBar;

  /// Optional progress value (0.0 to 1.0) for the top progress bar.
  final double? progress;

  /// Whether the footer should be fixed at the bottom.
  final bool stickyFooter;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return Container(
      color: design.colors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, design),
          if (progress != null) _buildProgressBar(design),

          Expanded(child: child),
          if (stickyFooter) _buildFooter(context),
        ],
      ),
    );
  }

  /// Exposed for children to use if [stickyFooter] is false.
  Widget buildFooter(BuildContext context) {
    return buildStaticFooter(context, onNext: onNext, onPrevious: onPrevious);
  }

  /// Static helper to build the navigation footer anywhere.
  static Widget buildStaticFooter(
    BuildContext context, {
    VoidCallback? onNext,
    VoidCallback? onPrevious,
  }) {
    if (onNext == null && onPrevious == null) return const SizedBox.shrink();
    final l10n = L10n.of(context);
    final design = Design.of(context);

    if (onPrevious == null && onNext != null) {
      return Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          design.spacing.md,
          design.spacing.md,
          design.spacing.md,
          design.spacing.md,
        ),
        decoration: BoxDecoration(color: design.colors.surface),
        child: _buildNavButton(
          context,
          label: l10n.videoLessonContinueNext,
          icon: LucideIcons.chevronRight,
          onTap: onNext,
          isBack: false,
          fullWidth: true,
        ),
      );
    }

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
      ),
      decoration: BoxDecoration(color: design.colors.surface),
      child: Row(
        children: [
          if (onPrevious != null) ...[
            Expanded(
              child: _buildNavButton(
                context,
                label: l10n.navigationPrevious,
                icon: LucideIcons.chevronLeft,
                onTap: onPrevious,
                isBack: true,
                fullWidth: true,
              ),
            ),
            if (onNext != null) SizedBox(width: design.spacing.md),
          ],
          if (onNext != null)
            Expanded(
              child: _buildNavButton(
                context,
                label: l10n.navigationNext,
                icon: LucideIcons.chevronRight,
                onTap: onNext,
                isBack: false,
                fullWidth: true,
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildNavButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    bool isBack = false,
    bool fullWidth = false,
  }) {
    final design = Design.of(context);
    final isDisabled = onTap == null;
    final bgColor = isDisabled
        ? design.colors.surfaceVariant
        : (isBack ? design.colors.surfaceVariant : design.colors.textPrimary);
    final textColor = isDisabled
        ? design.colors.border
        : (isBack ? design.colors.textPrimary : design.colors.textInverse);
    final borderColor = isDisabled
        ? design.colors.border.withValues(alpha: 0.5)
        : (isBack ? const Color(0x00000000) : design.colors.textPrimary);

    return AppFocusable(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(design.radius.md),
      child: Container(
        width: fullWidth ? double.infinity : null,
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
          mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isBack) ...[
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: AppText.body(
                label,
                color: textColor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            if (!isBack) ...[
              const SizedBox(width: 8),
              Icon(icon, color: textColor, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DesignConfig design) {
    final padding = MediaQuery.of(context).padding;
    final l10n = L10n.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: design.colors.card,
        border: Border(
          bottom: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(16, padding.top + 12, 16, 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Back Button
              Row(
                children: [
                  if (onBack != null)
                    AppSemantics.button(
                      label: l10n.curriculumBackButton,
                      onTap: onBack ?? () {},
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
                    )
                  else
                    const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 12),
              // Row 2: Lesson Title
              AppText.headline(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                AppText.cardCaption(subtitle!),
              ],
            ],
          ),
          Positioned(
            right: 0,
            top:
                -8, // Centers taller action buttons relative to the 20px tall back button
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onMarkAsCompleted != null)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: design.spacing.sm,
                    ),
                    child: AppFocusable(
                      onTap: onMarkAsCompleted!,
                      borderRadius: BorderRadius.circular(design.radius.sm),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                          vertical: design.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? design.colors.success.withValues(alpha: 0.1)
                              : design.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(design.radius.md),
                          border: Border.all(
                            color: isCompleted
                                ? design.colors.success.withValues(alpha: 0.2)
                                : design.colors.divider,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.label(
                              isCompleted ? 'Completed' : 'Mark as completed',
                              color: isCompleted
                                  ? design.colors.success
                                  : design.colors.textPrimary,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              LucideIcons.check,
                              size: 16,
                              color: isCompleted
                                  ? design.colors.success
                                  : design.colors.textPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (onBookmarkToggle != null)
                  _HeaderButton(
                    icon: isBookmarked
                        ? LucideIcons.bookmarkOff
                        : LucideIcons.bookmark,
                    label: isBookmarked ? 'Remove bookmark' : 'Bookmark lesson',
                    onTap: onBookmarkToggle!,
                    iconColor: isBookmarked ? design.colors.primary : null,
                  ),
                if (onDownload != null)
                  _HeaderButton(
                    icon: LucideIcons.download,
                    label: 'Download content',
                    onTap: onDownload!,
                  ),
                if (headerActions != null) ...headerActions!,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(DesignConfig design) {
    return AppSemantics.progressValue(
      value: progress ?? 0,
      label: 'Lesson progress',
      child: Container(
        width: double.infinity,
        height: 3,
        color: design.colors.divider.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: (progress ?? 0).clamp(0.005, 1.0),
          child: Container(height: 3, color: design.colors.primary),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return buildStaticFooter(context, onNext: onNext, onPrevious: onPrevious);
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(start: design.spacing.sm),
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.md),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: iconColor ?? design.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
