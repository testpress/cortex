import 'package:flutter/material.dart';
import 'package:core/core.dart';

class AlreadyDownloadedSheet extends StatelessWidget {
  final VoidCallback onOpenFile;
  final VoidCallback onDownloadAgain;
  final VoidCallback onClose;

  const AlreadyDownloadedSheet({
    super.key,
    required this.onOpenFile,
    required this.onDownloadAgain,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 32),
      decoration: BoxDecoration(
        color: design.colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.title(l10n.alreadyDownloadedTitle,
                  color: design.colors.textPrimary),
              AppSemantics.button(
                label: l10n.commonCloseButton,
                onTap: onClose,
                child: AppFocusable(
                  onTap: onClose,
                  child:
                      Icon(LucideIcons.x, color: design.colors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppText.body(
            l10n.alreadyDownloadedMessage,
            color: design.colors.textSecondary,
          ),
          const SizedBox(height: 32),
          AppButton.primary(
            onPressed: () {
              onClose();
              onOpenFile();
            },
            label: l10n.openFileAction,
            fullWidth: true,
          ),
          const SizedBox(height: 12),
          AppButton.secondary(
            onPressed: () {
              onClose();
              onDownloadAgain();
            },
            label: l10n.downloadAgainAction,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
