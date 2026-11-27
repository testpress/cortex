import 'package:flutter/widgets.dart';

import '../core.dart';

class AiChatHeader extends StatefulWidget {
  const AiChatHeader({
    super.key,
    required this.onMenu,
    this.title,
    this.onNewChat,
    this.onDelete,
    this.onRename,
  });

  final VoidCallback onMenu;
  final String? title;
  final VoidCallback? onNewChat;
  final VoidCallback? onDelete;
  final VoidCallback? onRename;

  @override
  State<AiChatHeader> createState() => _AiChatHeaderState();
}

class _AiChatHeaderState extends State<AiChatHeader> {
  final LayerLink _layerLink = LayerLink();

  void _showOptionsMenu() {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: l10n.labelClose,
      barrierColor: design.colors.transparent,
      transitionDuration: MotionPreferences.duration(
        context,
        design.motion.fast,
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        if (!MotionPreferences.shouldAnimate(context)) {
          return child;
        }
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: MotionPreferences.curve(context, design.motion.easeOut),
          ),
          child: child,
        );
      },
      pageBuilder: (dialogContext, anim1, anim2) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(dialogContext).pop(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: isRtl
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
              followerAnchor: isRtl ? Alignment.topLeft : Alignment.topRight,
              offset: Offset(0, design.spacing.xs),
              child: _HeaderOptionsPopup(
                onRename: widget.onRename != null
                    ? () {
                        Navigator.of(dialogContext).pop();
                        widget.onRename?.call();
                      }
                    : null,
                onDelete: widget.onDelete != null
                    ? () {
                        Navigator.of(dialogContext).pop();
                        widget.onDelete?.call();
                      }
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final displayTitle =
        (widget.title != null && widget.title!.trim().isNotEmpty)
        ? widget.title!.trim()
        : l10n.aiSupportTitle;

    return Container(
      color: aiChatCanvasColor(design),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: design.spacing.xs,
            end: design.spacing.xs,
            top: design.spacing.xs,
            bottom: design.spacing.xs,
          ),
          child: Row(
            children: [
              AppIconButton(
                icon: LucideIcons.menu,
                size: design.iconSize.md,
                color: design.colors.onSurface,
                accessibilityLabel: l10n.aiChatHistoryTitle,
                onTap: widget.onMenu,
              ),
              SizedBox(width: design.spacing.xs),
              Expanded(
                child: AppText.title(
                  displayTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.onNewChat != null)
                AppIconButton(
                  icon: LucideIcons.squarePen,
                  size: design.iconSize.md,
                  color: design.colors.onSurface,
                  accessibilityLabel: l10n.aiStartNewChat,
                  onTap: widget.onNewChat!,
                ),
              if (widget.onDelete != null || widget.onRename != null)
                CompositedTransformTarget(
                  link: _layerLink,
                  child: AppIconButton(
                    icon: LucideIcons.moreVertical,
                    size: design.iconSize.md,
                    color: design.colors.onSurface,
                    accessibilityLabel: l10n.aiMoreActionsSemantic(
                      displayTitle,
                    ),
                    onTap: _showOptionsMenu,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderOptionsPopup extends StatelessWidget {
  const _HeaderOptionsPopup({this.onRename, this.onDelete});

  final VoidCallback? onRename;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return IntrinsicWidth(
      child: Container(
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
            if (onRename != null) ...[
              AiMenuPopupItem(
                label: l10n.aiRenameConversationAction,
                icon: LucideIcons.pencil,
                color: design.colors.textPrimary,
                onTap: onRename!,
              ),
              if (onDelete != null) SizedBox(height: design.spacing.xs),
            ],
            if (onDelete != null)
              AiMenuPopupItem(
                label: l10n.aiDeleteConversationAction,
                icon: LucideIcons.trash2,
                color: design.colors.error,
                onTap: onDelete!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Shared popup item for header and conversation options menus.
class AiMenuPopupItem extends StatelessWidget {
  const AiMenuPopupItem({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return AppSemantics.button(
      label: label,
      onTap: onTap,
      child: AppFocusable(
        onTap: onTap,
        borderRadius: BorderRadius.circular(design.radius.sm),
        child: Container(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.sm,
            vertical: design.spacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(design.radius.sm),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: design.iconSize.sm, color: color),
              SizedBox(width: design.spacing.sm),
              ExcludeSemantics(child: AppText.bodySmall(label, color: color)),
            ],
          ),
        ),
      ),
    );
  }
}
