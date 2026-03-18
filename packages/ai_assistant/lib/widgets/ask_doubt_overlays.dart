import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

import '../models/ai_models.dart';
import '../providers/doubt_session_provider.dart';

class AskDoubtOverlays extends StatelessWidget {
  const AskDoubtOverlays({
    super.key,
    required this.menuSessionId,
    required this.menuOffset,
    required this.renamingSessionId,
    required this.sessionState,
    required this.renameController,
    required this.onDismissMenu,
    required this.onDismissRename,
    required this.onTogglePin,
    required this.onDelete,
    required this.onStartRename,
    required this.onSubmitRename,
  });

  final String? menuSessionId;
  final Offset? menuOffset;
  final String? renamingSessionId;
  final DoubtSessionState sessionState;
  final TextEditingController renameController;
  final VoidCallback onDismissMenu;
  final VoidCallback onDismissRename;
  final ValueChanged<String> onTogglePin;
  final ValueChanged<String> onDelete;
  final void Function(String sessionId, String title) onStartRename;
  final void Function(String sessionId, String title) onSubmitRename;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final currentSession = _findMenuSession();
    final menuSurfaceColor = design.isDark
        ? design.colors.surfaceVariant
        : design.colors.card;

    return Stack(
      children: [
        if (menuSessionId != null && menuOffset != null) ...[
          GestureDetector(
            onTap: onDismissMenu,
            child: Container(color: design.colors.overlay.withValues(alpha: 0)),
          ),
          Positioned(
            right:
                MediaQuery.of(context).size.width -
                menuOffset!.dx +
                design.spacing.xs,
            top: menuOffset!.dy - design.spacing.lg,
            child: Container(
              width: design.layout.drawerWidth * 0.5,
              padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
              decoration: BoxDecoration(
                color: menuSurfaceColor,
                borderRadius: design.radius.dialog,
                boxShadow: design.shadows.floating,
                border: Border.all(color: design.colors.border),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuItem(
                    icon: LucideIcons.pin,
                    label: currentSession?.isPinned == true
                        ? l10n.aiDoubtUnpin
                        : l10n.aiDoubtPin,
                    onTap: () => onTogglePin(menuSessionId!),
                  ),
                  _MenuItem(
                    icon: LucideIcons.pencil,
                    label: l10n.aiDoubtRename,
                    onTap: () {
                      final session = sessionState.history.firstWhere(
                        (s) => s.id == menuSessionId,
                      );
                      onStartRename(session.id, session.title);
                    },
                  ),
                  _MenuItem(
                    icon: LucideIcons.share2,
                    label: l10n.certificatesShare,
                    onTap: onDismissMenu,
                  ),
                  _MenuItem(
                    icon: LucideIcons.trash2,
                    label: l10n.aiDoubtDelete,
                    isDestructive: true,
                    onTap: () => onDelete(menuSessionId!),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (renamingSessionId != null) ...[
          GestureDetector(
            onTap: onDismissRename,
            child: Container(color: design.colors.overlay),
          ),
          Center(
            child: Container(
              width:
                  design.layout.drawerWidth +
                  design.spacing.md +
                  design.spacing.xs,
              padding: EdgeInsets.all(design.spacing.md),
              decoration: BoxDecoration(
                color: design.colors.surface,
                borderRadius: design.radius.card,
                boxShadow: design.shadows.floating,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.title(l10n.aiDoubtRenameTitle),
                  SizedBox(height: design.spacing.md),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.sm,
                      vertical: design.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: design.colors.card,
                      borderRadius: BorderRadius.circular(design.radius.sm),
                      border: Border.all(color: design.colors.border),
                    ),
                    child: EditableText(
                      controller: renameController,
                      focusNode: FocusNode()..requestFocus(),
                      cursorColor: design.colors.primary,
                      backgroundCursorColor: design.colors.textPrimary,
                      style: design.typography.body.copyWith(
                        color: design.colors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: design.spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: onDismissRename,
                        child: AppText.labelBold(
                          l10n.labelCancel,
                          color: design.colors.textSecondary,
                        ),
                      ),
                      SizedBox(width: design.spacing.lg),
                      GestureDetector(
                        onTap: () => onSubmitRename(
                          renamingSessionId!,
                          renameController.text,
                        ),
                        child: AppText.labelBold(
                          l10n.editProfileSave,
                          color: design.colors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  AIChatSession? _findMenuSession() {
    final sessionId = menuSessionId;
    if (sessionId == null) return null;

    for (final session in sessionState.history) {
      if (session.id == sessionId) return session;
    }

    return null;
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final foregroundColor = isDestructive
        ? design.colors.error
        : design.colors.textPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.sm,
          vertical: design.spacing.sm,
        ),
        color: design.colors.overlay.withValues(alpha: 0),
        child: Row(
          children: [
            Icon(icon, size: design.iconSize.action, color: foregroundColor),
            SizedBox(width: design.spacing.sm),
            AppText.bodySmall(label, color: foregroundColor),
          ],
        ),
      ),
    );
  }
}
