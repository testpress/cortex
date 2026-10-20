import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core.dart';

/// Conversation history, presented as a start-side drawer over a dimmed chat.
///
/// Expects to be shown on a non-opaque route so the chat stays visible behind
/// the scrim; the drawer animates itself from the route animation.
class AiChatHistoryScreen extends ConsumerStatefulWidget {
  const AiChatHistoryScreen({super.key});

  @override
  ConsumerState<AiChatHistoryScreen> createState() =>
      _AiChatHistoryScreenState();
}

class _AiChatHistoryScreenState extends ConsumerState<AiChatHistoryScreen> {
  /// Share of the screen the drawer may cover on narrow phones.
  static const double _maxWidthFactor = 0.85;

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

  void _dismiss() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/ai');
    }
  }

  void _startNewChat() {
    ref.read(genericAiChatProvider.notifier).startNewChat();
    _dismiss();
  }

  void _openConversation(String chatId) {
    ref.read(genericAiChatProvider.notifier).selectConversation(chatId);
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final routeAnimation = ModalRoute.of(context)?.animation;
    final animation =
        routeAnimation != null && MotionPreferences.shouldAnimate(context)
        ? routeAnimation
        : kAlwaysCompleteAnimation;
    final slide = animation.drive(
      Tween<Offset>(
        begin: Offset(isRtl ? 1.0 : -1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: design.motion.easeOut)),
    );

    final screenWidth = MediaQuery.sizeOf(context).width;
    final maxDrawerWidth = screenWidth * _maxWidthFactor;
    final drawerWidth = design.layout.drawerWidth > maxDrawerWidth
        ? maxDrawerWidth
        : design.layout.drawerWidth;

    return Stack(
      children: [
        Positioned.fill(
          child: AppSemantics.button(
            label: l10n.labelClose,
            onTap: _dismiss,
            child: GestureDetector(
              onTap: _dismiss,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: animation,
                child: ColoredBox(color: design.colors.overlay),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SlideTransition(
            position: slide,
            child: Container(
              key: const ValueKey('ai_chat_history_drawer'),
              width: drawerWidth,
              height: double.infinity,
              color: design.colors.card,
              child: SafeArea(
                left: !isRtl,
                right: isRtl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: design.spacing.md,
                        // The close icon sits in a 48dp touch target; trim
                        // the inset so the glyph lands near the content edge.
                        end: design.spacing.sm,
                        top: design.spacing.sm,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppSemantics.header(
                              label: l10n.aiChatHistoryTitle,
                              child: ExcludeSemantics(
                                child: AppText.title(
                                  l10n.aiChatHistoryTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          AppIconButton(
                            icon: LucideIcons.x,
                            size: design.iconSize.md,
                            color: design.colors.onSurfaceVariant,
                            accessibilityLabel: l10n.labelClose,
                            onTap: _dismiss,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        design.spacing.md,
                        design.spacing.xs,
                        design.spacing.md,
                        design.spacing.sm * 1.5,
                      ),
                      child: _NewChatButton(onTap: _startNewChat),
                    ),
                    Container(height: 1.0, color: design.colors.border),
                    Expanded(child: _buildBody(context)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final chatState = ref.watch(genericAiChatProvider);
    final history = chatState.conversationHistory;

    if (chatState.hasHistoryError && history.isEmpty) {
      return Center(
        child: AppErrorView(
          error: chatState.historyError,
          backgroundColor: design.colors.card,
          padding: EdgeInsets.all(design.spacing.md),
          onRetry: () => ref
              .read(genericAiChatProvider.notifier)
              .loadConversations(refresh: true),
        ),
      );
    }

    if (chatState.isLoadingHistory && history.isEmpty) {
      return const Center(child: AppLoadingIndicator());
    }

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(design.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.history,
                size: 40.0,
                color: design.colors.textTertiary,
              ),
              SizedBox(height: design.spacing.md),
              AppText.bodySmall(
                l10n.aiNoChatHistory,
                color: design.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final rowDivider = Container(
      height: 1.0,
      color: design.colors.border.withValues(alpha: 0.5),
    );

    return AppSemantics.scrollableList(
      itemCount: history.length,
      label: l10n.aiChatHistoryTitle,
      child: AppScroll(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        children: [
          for (final session in history) ...[
            _HistoryItem(
              title: session.title.trim().isNotEmpty
                  ? session.title
                  : l10n.aiNewChatHeader,
              timestamp: session.updatedAt != null
                  ? DateFormatter.formatTimeAgo(session.updatedAt!)
                  : '',
              onTap: () => _openConversation(session.chatId),
            ),
            rowDivider,
          ],
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
    );
  }
}

class _NewChatButton extends StatelessWidget {
  const _NewChatButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.aiStartNewChat,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48.0),
          child: Center(
            heightFactor: 1.0,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 40.0),
              padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: design.colors.textPrimary,
                borderRadius: design.radius.button,
              ),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.plus,
                      size: design.iconSize.sm,
                      color: design.colors.textInverse,
                    ),
                    SizedBox(width: design.spacing.xs * 1.5),
                    Flexible(
                      child: AppText.label(
                        l10n.aiNewChatHeader,
                        color: design.colors.textInverse,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.title,
    required this.timestamp,
    required this.onTap,
  });

  final String title;
  final String timestamp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return AppSemantics.button(
      label: l10n.openChatSession(title),
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: const BoxConstraints(minHeight: 48.0),
          padding: EdgeInsets.symmetric(
            horizontal: design.spacing.md,
            vertical: design.spacing.sm * 1.5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText.bodySmall(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (timestamp.isNotEmpty) ...[
                SizedBox(height: design.spacing.xs),
                AppText.caption(timestamp, color: design.colors.textTertiary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
