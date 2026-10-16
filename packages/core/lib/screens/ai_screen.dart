import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core.dart';

/// Type alias preserving backward compatibility for widget tests and callers.
typedef AiChatMessageItem = GenericAiChatMessage;

/// Direct, conversational generic AI chat screen.
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({
    super.key,
    this.initialMessages = const [],
    this.onBack,
    this.onOpenHistory,
  });

  /// Optional seed messages for testing and state verification.
  final List<AiChatMessageItem> initialMessages;

  /// Optional back navigation callback.
  /// If null, pops if possible ([Navigator.canPop]).
  final VoidCallback? onBack;

  /// Optional menu/history navigation callback.
  /// If null, opens the built-in [AiChatHistorySheet].
  final VoidCallback? onOpenHistory;

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  late final ScrollController _scrollController;
  int _lastMessageCount = 0;
  double _lastBottomInset = 0;
  String? _activeChatId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(genericAiChatProvider.notifier).initialize().ignore();
      if (widget.initialMessages.isNotEmpty) {
        ref
            .read(genericAiChatProvider.notifier)
            .setInitialMessages(widget.initialMessages);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animate = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_scrollController.positions.length != 1) return;
      if (!_scrollController.position.hasContentDimensions) return;
      final maxExtent = _scrollController.position.maxScrollExtent;
      if (maxExtent <= 0) return;

      if (animate && MotionPreferences.shouldAnimate(context)) {
        final design = Design.of(context);
        _scrollController
            .animateTo(
              maxExtent,
              duration: design.motion.normal,
              curve: design.motion.easeOut,
            )
            .then((_) {
              if (mounted) _clampScrollBounds();
            });
      } else {
        _scrollController.jumpTo(maxExtent);
      }

      // Re-verify on subsequent frame to auto-clamp if Markdown/LaTeX reflow causes overscroll
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clampScrollBounds();
      });

      // Secondary check after asynchronous Markdown/LaTeX math layout settles
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) _clampScrollBounds();
      });
    });
  }

  void _clampScrollBounds() {
    if (!mounted || !_scrollController.hasClients) return;
    if (_scrollController.positions.length != 1) return;
    if (!_scrollController.position.hasContentDimensions) return;
    if (_scrollController.position.isScrollingNotifier.value) {
      return;
    }
    final maxExtent = _scrollController.position.maxScrollExtent;
    if (_scrollController.offset > maxExtent) {
      _scrollController.jumpTo(maxExtent);
    }
  }

  void _handleBack() {
    final chatState = ref.read(genericAiChatProvider);
    if (chatState.currentChatId != null || chatState.messages.isNotEmpty) {
      ref.read(genericAiChatProvider.notifier).startNewChat();
      return;
    }
    if (widget.onBack != null) {
      widget.onBack!();
    } else if (context.canPop()) {
      context.pop();
    }
  }

  void _handleMenu() {
    if (widget.onOpenHistory != null) {
      widget.onOpenHistory!();
    } else {
      context.push('/ai/history');
    }
  }

  void _handleSend(String text) {
    ref.read(genericAiChatProvider.notifier).sendMessage(text);
    _scrollToBottom(animate: true);
  }

  void _handleRetry(String messageId, bool isUser) {
    if (isUser) {
      ref
          .read(genericAiChatProvider.notifier)
          .retryLastSend(messageId: messageId);
    } else {
      ref.read(genericAiChatProvider.notifier).retryGeneration();
    }
    _scrollToBottom(animate: true);
  }

  void _handleCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final chatState = ref.watch(genericAiChatProvider);

    final displayMessages = chatState.messages.isNotEmpty
        ? chatState.messages
        : widget.initialMessages;

    if (_activeChatId != chatState.currentChatId) {
      _activeChatId = chatState.currentChatId;
      _lastMessageCount = displayMessages.length;
      if (displayMessages.isNotEmpty) {
        _scrollToBottom(animate: false);
      } else if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    } else if (displayMessages.length != _lastMessageCount) {
      final isFirstLoad = _lastMessageCount == 0;
      _lastMessageCount = displayMessages.length;
      _scrollToBottom(animate: !isFirstLoad);
    }

    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    if (bottomInset > 0 && bottomInset != _lastBottomInset) {
      _lastBottomInset = bottomInset;
      _scrollToBottom(animate: true);
    } else if (bottomInset == 0 && _lastBottomInset > 0) {
      _lastBottomInset = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _clampScrollBounds();
      });
    }

    final isInputBlocked =
        chatState.isSending ||
        chatState.isGenerating ||
        chatState.hasActiveRateLimit ||
        chatState.hasMessagesError;

    return Container(
      color: design.colors.card,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AiChatHeader(onBack: _handleBack, onMenu: _handleMenu),

          if (chatState.hasInitError)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.screenPadding,
                vertical: design.spacing.xs,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 768.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: design.colors.warning.withValues(alpha: 0.12),
                      borderRadius: design.radius.card,
                      border: Border.all(
                        color: design.colors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          size: 16.0,
                          color: design.colors.warning,
                        ),
                        SizedBox(width: design.spacing.xs),
                        Expanded(
                          child: AppText.labelSmall(
                            l10n.aiInitErrorBanner,
                            color: design.colors.textPrimary,
                          ),
                        ),
                        SizedBox(width: design.spacing.xs),
                        AppSemantics.button(
                          label: l10n.labelRetry,
                          onTap: () => ref
                              .read(genericAiChatProvider.notifier)
                              .initialize(),
                          child: GestureDetector(
                            onTap: () => ref
                                .read(genericAiChatProvider.notifier)
                                .initialize(),
                            behavior: HitTestBehavior.opaque,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minWidth: 48.0,
                                minHeight: 48.0,
                              ),
                              child: Center(
                                child: AppText.labelBold(
                                  l10n.labelRetry,
                                  color: design.colors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Chat Canvas / Messages List
          Expanded(
            child: chatState.isLoadingMessages
                ? const Center(child: AppLoadingIndicator())
                : chatState.hasMessagesError && displayMessages.isEmpty
                ? Center(
                    child: AppErrorView(
                      error: chatState.messagesError,
                      backgroundColor: design.colors.card,
                      onRetry: () {
                        if (chatState.currentChatId != null) {
                          ref
                              .read(genericAiChatProvider.notifier)
                              .selectConversation(chatState.currentChatId!);
                        }
                      },
                    ),
                  )
                : displayMessages.isEmpty
                ? const SizedBox.expand()
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 768.0),
                      child: AppSemantics.scrollableList(
                        itemCount: displayMessages.length,
                        label: l10n.aiSupportTitle,
                        child: NotificationListener<ScrollMetricsNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.pixels >
                                    notification.metrics.maxScrollExtent &&
                                notification.metrics.maxScrollExtent >= 0) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _clampScrollBounds();
                              });
                            }
                            return false;
                          },
                          child: ListView.builder(
                            key: ValueKey(
                              chatState.currentChatId ?? 'new_chat',
                            ),
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                              horizontal: design.spacing.screenPadding,
                              vertical: design.spacing.md,
                            ),
                            itemCount: displayMessages.length,
                            itemBuilder: (context, index) {
                              final item = displayMessages[index];
                              if (item.isUser) {
                                return AiUserMessageBubble(
                                  message: item.text,
                                  timestamp: DateFormatter.formatTime(
                                    item.timestamp,
                                  ),
                                  isSending: item.isSending,
                                  hasSendError: item.hasSendError,
                                  onRetry: () => _handleRetry(item.id, true),
                                );
                              }
                              return AiAssistantCard(
                                message: item.text,
                                timestamp: DateFormatter.formatTime(
                                  item.timestamp,
                                ),
                                hasGenerationError: item.hasGenerationError,
                                onRetry: () => _handleRetry(item.id, false),
                                onCopy: () => _handleCopy(item.text),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ),

          // Quota / Rate-limit warning banner if active
          if (chatState.quotaError != null && chatState.hasActiveRateLimit)
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 768.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.screenPadding,
                    vertical: design.spacing.xs,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.xs + 2,
                    ),
                    decoration: BoxDecoration(
                      color: design.colors.warning.withValues(alpha: 0.12),
                      borderRadius: design.radius.card,
                      border: Border.all(
                        color: design.colors.warning.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          size: 16.0,
                          color: design.colors.warning,
                        ),
                        SizedBox(width: design.spacing.xs),
                        Expanded(
                          child: AppText.labelSmall(
                            chatState.quotaError!,
                            color: design.colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Composer pinned to bottom
          SafeArea(
            top: false,
            bottom: bottomInset == 0,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 768.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.screenPadding,
                    vertical: design.spacing.sm,
                  ),
                  child: AiComposer(
                    enabled: !isInputBlocked,
                    onSend: _handleSend,
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
