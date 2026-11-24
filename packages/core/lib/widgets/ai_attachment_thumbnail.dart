import 'package:flutter/widgets.dart';

import '../core.dart';

/// Thumbnail preview card for a staged image attachment in the AI chat composer.
class AiAttachmentThumbnail extends StatelessWidget {
  const AiAttachmentThumbnail({
    super.key,
    required this.attachment,
    this.onRemove,
    this.onRetry,
  });

  final StagedAttachment attachment;
  final VoidCallback? onRemove;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    Widget imageContent = Container(
      width: 56.0,
      height: 56.0,
      decoration: BoxDecoration(
        color: design.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(design.radius.md),
        border: Border.all(
          color: attachment.hasError
              ? design.colors.error
              : design.colors.border,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(design.radius.md),
        child: attachment.bytes != null
            ? Image.memory(
                attachment.bytes!,
                fit: BoxFit.cover,
                width: 56.0,
                height: 56.0,
              )
            : Center(
                child: Icon(
                  LucideIcons.image,
                  color: design.colors.textSecondary,
                  size: design.iconSize.sm,
                ),
              ),
      ),
    );

    if (attachment.hasError) {
      final childWidget = onRetry != null
          ? GestureDetector(
              onTap: onRetry,
              behavior: HitTestBehavior.opaque,
              child: imageContent,
            )
          : imageContent;
      imageContent = AppSemantics.button(
        label: l10n.aiComposerAttachmentUploadFailed,
        onTap: onRetry,
        child: childWidget,
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 6.0, end: 6.0),
      child: SizedBox(
        width: 56.0,
        height: 56.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            imageContent,
            if (attachment.isUploading)
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: design.colors.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(design.radius.md),
                ),
                child: const Center(child: AppLoadingIndicator()),
              ),
            if (onRemove != null)
              PositionedDirectional(
                top: -20.0,
                end: -20.0,
                child: AppSemantics.button(
                  label: l10n.aiComposerDeleteAttachment,
                  onTap: onRemove,
                  child: GestureDetector(
                    onTap: onRemove,
                    behavior: HitTestBehavior.opaque,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 48.0,
                        minHeight: 48.0,
                      ),
                      child: Center(
                        child: Container(
                          width: 20.0,
                          height: 20.0,
                          decoration: BoxDecoration(
                            color: design.colors.textPrimary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: design.colors.surface,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.x,
                              size: 11.0,
                              color: design.colors.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            if (attachment.hasError)
              PositionedDirectional(
                bottom: 2.0,
                end: 2.0,
                child: IgnorePointer(
                  child: Container(
                    width: 16.0,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: design.colors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.alertCircle,
                        size: 10.0,
                        color: design.colors.surface,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
