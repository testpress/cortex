import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';

class AiChatHistoryScreen extends ConsumerStatefulWidget {
  const AiChatHistoryScreen({super.key});

  @override
  ConsumerState<AiChatHistoryScreen> createState() =>
      _AiChatHistoryScreenState();
}

class _AiChatHistoryScreenState extends ConsumerState<AiChatHistoryScreen> {
  static const double _maxContentWidth = 768.0;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(genericAiChatProvider.notifier).loadConversations(refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.maxScrollExtent <= 0 || position.pixels <= 0) return;

    if (position.pixels >= position.maxScrollExtent - 200) {
      final state = ref.read(genericAiChatProvider);
      if (!state.isLoadingHistory && state.hasMoreHistory) {
        ref.read(genericAiChatProvider.notifier).loadConversations();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final chatState = ref.watch(genericAiChatProvider);
    final history = chatState.conversationHistory;

    return Container(
      color: design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: design.colors.card,
            child: SafeArea(
              bottom: false,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.screenPadding,
                      vertical: design.spacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppSemantics.button(
                          label: l10n.commonBackSemantic,
                          onTap: () => context.pop(),
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            behavior: HitTestBehavior.opaque,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 48.0,
                                minHeight: 48.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Icon(
                                      LucideIcons.arrowLeft,
                                      color: design.colors.textPrimary,
                                      size: 20.0,
                                    ),
                                  ),
                                  SizedBox(width: design.spacing.xs),
                                  AppText.title(
                                    l10n.aiChatHistoryTitle,
                                    color: design.colors.textPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        AppIconButton(
                          icon: LucideIcons.plus,
                          size: 22.0,
                          color: design.colors.textPrimary,
                          accessibilityLabel: l10n.aiStartNewChat,
                          onTap: () {
                            ref
                                .read(genericAiChatProvider.notifier)
                                .startNewChat();
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/ai');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (chatState.hasHistoryError && history.isEmpty)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: AppErrorView(
                    error: chatState.historyError,
                    backgroundColor: design.colors.card,
                    onRetry: () => ref
                        .read(genericAiChatProvider.notifier)
                        .loadConversations(refresh: true),
                  ),
                ),
              ),
            )
          else if (chatState.isLoadingHistory && history.isEmpty)
            const Expanded(child: Center(child: AppLoadingIndicator()))
          else if (history.isEmpty)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.all(design.spacing.xl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.history,
                          size: 48.0,
                          color: design.colors.textTertiary,
                        ),
                        SizedBox(height: design.spacing.md),
                        AppText.body(
                          l10n.aiNoChatHistory,
                          color: design.colors.textSecondary,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: AppSemantics.scrollableList(
                    itemCount: history.length,
                    label: l10n.aiChatHistoryTitle,
                    child: AppScroll(
                      controller: _scrollController,
                      padding: EdgeInsets.fromLTRB(
                        design.spacing.screenPadding,
                        design.spacing.sm,
                        design.spacing.screenPadding,
                        design.spacing.lg,
                      ),
                      children: [
                        ...history.map((session) {
                          final isLast = session == history.last;
                          final displayTitle = session.title.trim().isNotEmpty
                              ? session.title
                              : 'New Chat';
                          final timestamp = session.updatedAt != null
                              ? DateFormatter.formatTimeAgo(session.updatedAt!)
                              : '';
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _HistoryItem(
                                sessionId: session.chatId,
                                title: displayTitle,
                                timestamp: timestamp,
                                onTap: () {
                                  ref
                                      .read(genericAiChatProvider.notifier)
                                      .selectConversation(session.chatId);
                                  context.pop();
                                },
                              ),
                              if (!isLast) SizedBox(height: design.spacing.xs),
                            ],
                          );
                        }),
                        if (chatState.isLoadingHistory)
                          Padding(
                            padding: EdgeInsets.all(design.spacing.md),
                            child: const Center(child: AppLoadingIndicator()),
                          ),
                        if (chatState.hasHistoryError)
                          Padding(
                            padding: EdgeInsets.all(design.spacing.md),
                            child: Center(
                              child: AppButton.secondary(
                                label: l10n.labelRetry,
                                onPressed: () => ref
                                    .read(genericAiChatProvider.notifier)
                                    .loadConversations(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
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
    required this.timestamp,
    this.onTap,
  });

  final String sessionId;
  final String title;
  final String timestamp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final handleTap = onTap ?? () => context.push('/ai/chat?id=$sessionId');

    return AppSemantics.button(
      label: l10n.openChatSession(title),
      onTap: handleTap,
      child: AppCard(
        padding: EdgeInsets.all(design.spacing.md),
        onTap: handleTap,
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
                  if (timestamp.isNotEmpty) AppText.cardCaption(timestamp),
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
