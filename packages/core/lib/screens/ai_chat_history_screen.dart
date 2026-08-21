import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';
import '../data/ai_chat_mock_data.dart';

class AiChatHistoryScreen extends ConsumerWidget {
  const AiChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(
            title: l10n.aiChatHistoryTitle,
            leading: AppBackButton(onTap: () => context.pop()),
          ),
          Expanded(
            child: AppSemantics.scrollableList(
              itemCount: mockChatSessions.length,
              label: l10n.aiChatHistoryTitle,
              child: AppScroll(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.lg,
                ),
                children: [
                  ...mockChatSessions.map((session) {
                    final isLast = session == mockChatSessions.last;
                    final lastHumanMessage = session.messages
                        .lastWhere((msg) => msg.role == MessageRole.user)
                        .content;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HistoryItem(
                          sessionId: session.id,
                          title: session.title,
                          lastMessage: lastHumanMessage,
                          timestamp: DateFormatter.formatTimeAgo(
                            session.modifiedAt,
                          ),
                        ),
                        if (!isLast) SizedBox(height: design.spacing.xs),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.sessionId,
    required this.title,
    this.lastMessage,
    required this.timestamp,
  });

  final String sessionId;
  final String title;
  final String? lastMessage;
  final String timestamp;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.openDetailedLesson(title),
      onTap: () => context.push('/ai/chat?id=$sessionId'),
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        onTap: () => context.push('/ai/chat?id=$sessionId'),
        child: Row(
          children: [
            SizedBox(width: design.spacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.cardTitle(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: design.spacing.xs),
                  if (lastMessage != null) ...[
                    AppText.cardSubtitle(
                      lastMessage!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: design.spacing.xs),
                  ],
                  AppText.cardCaption(timestamp),
                ],
              ),
            ),
            SizedBox(width: design.spacing.xs),
            Icon(
              LucideIcons.chevronRight,
              color: design.colors.textTertiary,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}
