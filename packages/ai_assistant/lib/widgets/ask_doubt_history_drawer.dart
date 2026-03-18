import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

import '../models/ai_models.dart';
import '../providers/doubt_session_provider.dart';

class AskDoubtHistoryDrawer extends StatelessWidget {
  const AskDoubtHistoryDrawer({
    super.key,
    required this.isOpen,
    required this.sessionState,
    required this.onDismiss,
    required this.onNewChat,
    required this.onSelectSession,
    required this.onOpenSessionMenu,
  });

  final bool isOpen;
  final DoubtSessionState sessionState;
  final VoidCallback onDismiss;
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelectSession;
  final void Function(String sessionId, Offset globalPosition)
  onOpenSessionMenu;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isOpen
          ? Stack(
              children: [
                GestureDetector(
                  onTap: onDismiss,
                  child: Container(color: design.colors.overlay),
                ),
                TweenAnimationBuilder<Offset>(
                  tween: Tween(begin: const Offset(1, 0), end: Offset.zero),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  builder: (context, offset, child) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: FractionalTranslation(
                        translation: offset,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: design.layout.drawerWidth,
                    decoration: BoxDecoration(
                      color: design.colors.surface,
                      border: Border(
                        left: BorderSide(color: design.colors.border),
                      ),
                    ),
                    child: SafeArea(
                      left: false,
                      right: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(design.spacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText.title(l10n.chapterStatusHistory),
                                GestureDetector(
                                  onTap: onDismiss,
                                  child: Icon(
                                    LucideIcons.x,
                                    size: design.iconSize.action,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.md,
                            ),
                            child: GestureDetector(
                              onTap: onNewChat,
                              child: Container(
                                padding: EdgeInsets.all(design.spacing.sm),
                                decoration: BoxDecoration(
                                  color: design.colors.card,
                                  borderRadius: BorderRadius.circular(
                                    design.radius.lg,
                                  ),
                                  border: Border.all(
                                    color: design.colors.border,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      LucideIcons.plus,
                                      size: design.iconSize.action,
                                    ),
                                    SizedBox(width: design.spacing.sm),
                                    AppText.labelBold(l10n.aiDoubtNewChat),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: design.spacing.md),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.spacing.md,
                              ),
                              itemCount: sessionState.history.length,
                              itemBuilder: (context, index) {
                                final session = sessionState.history[index];
                                final isActive =
                                    session.id == sessionState.activeSessionId;
                                return _HistoryRow(
                                  session: session,
                                  isActive: isActive,
                                  onTap: () => onSelectSession(session.id),
                                  onMenuTapDown: (details) => onOpenSessionMenu(
                                    session.id,
                                    details.globalPosition,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.session,
    required this.isActive,
    required this.onTap,
    required this.onMenuTapDown,
  });

  final AIChatSession session;
  final bool isActive;
  final VoidCallback onTap;
  final GestureTapDownCallback onMenuTapDown;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: design.spacing.xs),
        padding: EdgeInsets.all(design.spacing.sm),
        decoration: BoxDecoration(
          color: isActive ? design.colors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(design.radius.md),
        ),
        child: Row(
          children: [
            Icon(
              session.isPinned ? LucideIcons.pin : LucideIcons.messageSquare,
              size: design.iconSize.sm,
              color: session.isPinned
                  ? design.colors.primary
                  : design.colors.textSecondary,
            ),
            SizedBox(width: design.spacing.sm),
            Expanded(
              child: AppText.bodySmall(
                session.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: isActive
                    ? design.colors.textPrimary
                    : design.colors.textSecondary,
              ),
            ),
            GestureDetector(
              onTapDown: onMenuTapDown,
              child: Icon(
                LucideIcons.moreHorizontal,
                size: design.iconSize.sm,
                color: design.colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
