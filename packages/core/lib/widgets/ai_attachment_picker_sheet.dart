import 'package:flutter/widgets.dart';

import '../core.dart';

/// Modal bottom sheet for choosing an image attachment source (Camera or Gallery)
/// in the AI chat screen.
class AiAttachmentPickerSheet extends StatelessWidget {
  const AiAttachmentPickerSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onSelectCamera,
    required this.onSelectGallery,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onSelectCamera;
  final VoidCallback onSelectGallery;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppBottomSheet(
      isOpen: isOpen,
      onClose: onClose,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          design.spacing.sm,
          0,
          design.spacing.sm,
          design.spacing.md,
        ),
        child: SafeArea(
          top: false,
          child: Container(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle Bar
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: design.spacing.xl * 1.5,
                    height: 4,
                    decoration: BoxDecoration(
                      color: design.colors.border,
                      borderRadius: BorderRadius.circular(design.radius.full),
                    ),
                  ),
                ),
                SizedBox(height: design.spacing.md),
                _buildSheetOption(
                  key: const ValueKey('ai_attach_camera_option'),
                  icon: LucideIcons.camera,
                  label: l10n.aiComposerTakePhoto,
                  design: design,
                  onTap: onSelectCamera,
                ),
                _buildSheetOption(
                  key: const ValueKey('ai_attach_gallery_option'),
                  icon: LucideIcons.image,
                  label: l10n.aiComposerAttachImage,
                  design: design,
                  onTap: onSelectGallery,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetOption({
    Key? key,
    required IconData icon,
    required String label,
    required DesignConfig design,
    required VoidCallback onTap,
  }) {
    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        key: key,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: design.spacing.md),
          child: Row(
            children: [
              Icon(icon, size: 20, color: design.colors.textPrimary),
              SizedBox(width: design.spacing.md),
              AppText.bodySmall(
                label,
                color: design.colors.textPrimary,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
