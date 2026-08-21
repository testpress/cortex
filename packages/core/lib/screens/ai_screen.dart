import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';
import '../data/ai_chat_mock_data.dart';

class AiScreen extends ConsumerWidget {
  const AiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: l10n.aiSupportTitle),
          Expanded(
            child: AppScroll(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.lg,
              ),
              children: [
                const _WelcomeSection(),
                SizedBox(height: design.spacing.md),
                const _RecentHelpSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 120.0,
            child: OverflowBox(
              maxHeight: 250.0,
              minHeight: 250.0,
              child: Image.asset(
                'assets/images/ai_bot.png',
                width: 250.0,
                height: 250.0,
              ),
            ),
          ),
        ),
        SizedBox(height: design.spacing.sm),
        AppSemantics.header(
          label: l10n.aiStudyCompanionTitle,
          child: AppText.title(
            l10n.aiStudyCompanionTitle,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: design.spacing.sm),
        AppText.bodySmall(
          l10n.aiWelcomeSubtitle,
          textAlign: TextAlign.center,
          color: design.colors.textSecondary,
        ),
        SizedBox(height: design.spacing.md),
        AppButton.primary(
          label: l10n.aiStartNewChat,
          onPressed: () => context.push('/ai/chat'),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
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

class _RecentHelpSection extends StatelessWidget {
  const _RecentHelpSection();

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppSemantics.header(
              label: l10n.aiRecentChatsHeader,
              child: AppText.title(l10n.aiRecentChatsHeader),
            ),
            AppSemantics.button(
              label: l10n.aiViewAllRecentChats,
              onTap: () => context.push('/ai/history'),
              child: GestureDetector(
                onTap: () => context.push('/ai/history'),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.sm,
                    vertical: design.spacing.md,
                  ),
                  child: AppText.labelBold(
                    l10n.aiViewAllRecentChats,
                    color: design.colors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: design.spacing.sm),
        AppSemantics.scrollableList(
          itemCount: mockChatSessions.length,
          label: l10n.aiRecentChatsHeader,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: mockChatSessions.map((session) {
              final isLast = session == mockChatSessions.last;
              final lastHumanMessage = session.messages
                  .lastWhere((msg) => msg.role == MessageRole.user)
                  .content;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HistoryCard(
                    sessionId: session.id,
                    title: session.title,
                    lastMessage: lastHumanMessage,
                    timestamp: DateFormatter.formatTimeAgo(session.modifiedAt),
                  ),
                  if (!isLast) SizedBox(height: design.spacing.xs),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
