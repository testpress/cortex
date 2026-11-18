import 'package:flutter/widgets.dart';

import '../core.dart';

class AiChatHeader extends StatefulWidget {
  const AiChatHeader({
    super.key,
    required this.onMenu,
    this.title,
    this.onNewChat,
    this.onDelete,
  });

  final VoidCallback onMenu;
  final String? title;
  final VoidCallback? onNewChat;
  final VoidCallback? onDelete;

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
                onDelete: () {
                  Navigator.of(dialogContext).pop();
                  widget.onDelete?.call();
                },
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
              if (widget.onDelete != null)
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
  const _HeaderOptionsPopup({required this.onDelete});

  final VoidCallback onDelete;

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
            AppSemantics.button(
              label: l10n.aiDeleteConversationAction,
              onTap: onDelete,
              child: AppFocusable(
                onTap: onDelete,
                borderRadius: BorderRadius.circular(design.radius.sm),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
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
                      Icon(
                        LucideIcons.trash2,
                        size: design.iconSize.sm,
                        color: design.colors.error,
                      ),
                      SizedBox(width: design.spacing.sm),
                      ExcludeSemantics(
                        child: AppText.bodySmall(
                          l10n.aiDeleteConversationAction,
                          color: design.colors.error,
                        ),
                      ),
                    ],
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
