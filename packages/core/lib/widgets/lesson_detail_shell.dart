import 'package:flutter/widgets.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../design/design_provider.dart';
import '../design/design_config.dart';
import '../accessibility/app_semantics.dart';
import 'app_header.dart';
import 'app_button.dart';
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
          if (title.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
                design.spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.headline(
                    title,
                    color: design.colors.textPrimary,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: design.spacing.xs),
                    AppText.body(
                      subtitle!,
                      color: design.colors.textSecondary,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            ),
          Expanded(child: child),
          if (stickyFooter) _buildFooter(context),
        ],
      ),
    );
  }

  /// Exposed for children to use if [stickyFooter] is false.
  Widget buildFooter(BuildContext context) {
    return buildStaticFooter(
      context,
      onNext: onNext,
      onPrevious: onPrevious,
    );
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
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(
        design.spacing.sm, // Reduced from screenPadding
        design.spacing.md,
        design.spacing.sm, // Reduced from screenPadding
        design.spacing.md,
      ),
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          top: BorderSide(color: design.colors.divider, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: onPrevious != null
                ? AppButton.secondary(
                    label: l10n.navigationPrevious,
                    onPressed: onPrevious,
                    fullWidth: true,
                    leading: const Icon(LucideIcons.arrowLeft, size: 18),
                  )
                : const SizedBox.shrink(),
          ),
          SizedBox(width: design.spacing.md),
          Expanded(
            child: onNext != null
                ? AppButton.primary(
                    label: l10n.navigationNext,
                    onPressed: onNext,
                    fullWidth: true,
                    trailing: const Icon(LucideIcons.arrowRight, size: 18),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DesignConfig design) {
    return AppHeader(
      title: '',
      leading: onBack != null
          ? AppFocusable(
              onTap: onBack!,
              borderRadius: BorderRadius.circular(design.radius.sm),
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
                    const SizedBox(width: 4),
                    AppText.label(
                      'Back',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      actions: [
        if (onMarkAsCompleted != null)
          Padding(
            padding: EdgeInsetsDirectional.only(start: design.spacing.sm),
            child: AppFocusable(
              onTap: onMarkAsCompleted!,
              borderRadius: BorderRadius.circular(design.radius.sm),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isCompleted ? design.colors.success.withValues(alpha: 0.1) : design.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(design.radius.md),
                  border: Border.all(
                    color: isCompleted ? design.colors.success.withValues(alpha: 0.2) : design.colors.divider,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.label(
                      isCompleted ? 'Completed' : 'Mark as completed',
                      color: isCompleted ? design.colors.success : design.colors.textPrimary,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      LucideIcons.check,
                      size: 16,
                      color: isCompleted ? design.colors.success : design.colors.textPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (onBookmarkToggle != null)
          _HeaderButton(
            icon: LucideIcons.bookmark,
            label: isBookmarked ? 'Remove bookmark' : 'Bookmark lesson',
            onTap: onBookmarkToggle!,
          ),
        if (onDownload != null)
          _HeaderButton(
            icon: LucideIcons.download,
            label: 'Download content',
            onTap: onDownload!,
          ),
        if (headerActions != null) ...headerActions!,
      ],
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
          child: Container(
            height: 3,
            color: design.colors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return buildStaticFooter(
      context,
      onNext: onNext,
      onPrevious: onPrevious,
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

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
              color: design.colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
