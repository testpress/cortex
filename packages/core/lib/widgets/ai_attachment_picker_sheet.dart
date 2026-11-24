import 'package:flutter/widgets.dart';

import '../core.dart';

/// Anchored floating popover for choosing an image attachment source (Camera or Gallery)
/// in the AI chat screen, matching web behavior.
class AiAttachmentPickerSheet extends StatelessWidget {
  const AiAttachmentPickerSheet({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onSelectCamera,
    required this.onSelectGallery,
    this.anchorLink,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onSelectCamera;
  final VoidCallback onSelectGallery;
  final LayerLink? anchorLink;

  @override
  Widget build(BuildContext context) {
    if (!isOpen) return const SizedBox.shrink();

    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final content = IntrinsicWidth(
      child: Container(
        constraints: const BoxConstraints(minWidth: 160.0),
        decoration: BoxDecoration(
          color: design.colors.card,
          borderRadius: BorderRadius.circular(design.radius.md),
          border: Border.all(
            color: design.colors.border.withValues(
              alpha: design.isDark ? 0.6 : 0.8,
            ),
          ),
          boxShadow: design.shadows.floating,
        ),
        padding: EdgeInsets.all(design.spacing.xs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOption(
              key: const ValueKey('ai_attach_gallery_option'),
              icon: LucideIcons.image,
              label: l10n.aiComposerAttachImage,
              design: design,
              onTap: onSelectGallery,
            ),
            _buildOption(
              key: const ValueKey('ai_attach_camera_option'),
              icon: LucideIcons.camera,
              label: l10n.aiComposerTakePhoto,
              design: design,
              onTap: onSelectCamera,
            ),
          ],
        ),
      ),
    );

    final semanticContent = AppSemantics.container(
      label: l10n.aiComposerAttachImage,
      child: content,
    );

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            child: AppSemantics.button(
              label: l10n.labelClose,
              onTap: onClose,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onClose,
              ),
            ),
          ),
          if (anchorLink != null)
            CompositedTransformFollower(
              link: anchorLink!,
              showWhenUnlinked: false,
              targetAnchor: isRtl ? Alignment.topRight : Alignment.topLeft,
              followerAnchor: isRtl
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              offset: Offset(0, -design.spacing.xs),
              child: semanticContent,
            )
          else
            PositionedDirectional(
              start: design.spacing.md,
              bottom: design.spacing.xl * 2,
              child: semanticContent,
            ),
        ],
      ),
    );
  }

  Widget _buildOption({
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
        borderRadius: BorderRadius.circular(design.radius.sm),
        child: Container(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs * 1.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: design.iconSize.sm,
                color: design.colors.textPrimary,
              ),
              SizedBox(width: design.spacing.sm),
              ExcludeSemantics(
                child: AppText.label(label, color: design.colors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
