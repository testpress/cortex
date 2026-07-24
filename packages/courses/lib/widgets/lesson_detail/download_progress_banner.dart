import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Floating banner displayed at the bottom of the screen to show PDF download progress.
class DownloadProgressBanner extends StatelessWidget {
  final bool isCompleted;
  final int progress;
  final VoidCallback? onView;

  const DownloadProgressBanner({
    super.key,
    required this.isCompleted,
    required this.progress,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: design.colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isCompleted)
            Icon(LucideIcons.checkCircle2,
                color: design.colors.success, size: 24)
          else
            SizedBox(
              width: 24,
              height: 24,
              child: AppLoadingIndicator(color: design.colors.primary),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: AppText.body(
              isCompleted ? l10n.downloadCompleted : l10n.downloadingFile,
              color: design.colors.textPrimary,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (isCompleted)
            AppSemantics.button(
              label: l10n.viewAction,
              onTap: onView,
              child: AppFocusable(
                onTap: onView,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: AppText.label(
                    l10n.viewAction,
                    color: design.colors.primary,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
