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

  /// Optional fallback for back navigation when no conversation is active.
  /// The landing header hides Back; conversation Back resets the chat first.
  /// If null, the fallback pops if possible ([Navigator.canPop]).
  final VoidCallback? onBack;

  /// Optional menu/history navigation callback.
  /// If null, opens the [AiChatHistoryScreen] drawer.
  final VoidCallback? onOpenHistory;

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  late final ScrollController _scrollController;
  late final TextEditingController _composerController;
  late final FocusNode _composerFocusNode;
  int _lastMessageCount = 0;
  int _lastStreamingTextLength = 0;
  double _lastBottomInset = 0;
  String? _activeChatId;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _composerController = TextEditingController();
    _composerFocusNode = FocusNode();
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
    _composerController.dispose();
    _composerFocusNode.dispose();
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
      Future.delayed(Design.of(context).motion.fast, () {
        if (mounted) _clampScrollBounds();
      });
    });
  }

  /// Whether the list is scrolled close enough to the end that streamed text
  /// should keep the newest content in view.
  static const double _autoScrollProximity = 96.0;

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return true;
    if (_scrollController.positions.length != 1) return false;
    final position = _scrollController.position;
    if (!position.hasContentDimensions) return true;
    return position.maxScrollExtent - position.pixels < _autoScrollProximity;
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
    _composerFocusNode.unfocus();
    if (widget.onOpenHistory != null) {
      widget.onOpenHistory!();
    } else {
      context.push('/ai/history');
    }
  }

  // Reserved for future attachment support in the composer.
  // void _handleNewChat() {
  //   ref.read(genericAiChatProvider.notifier).startNewChat();
  // }

  /// Prefills the composer with a starter prompt for the student to finish.
  void _handleSuggestion(String prompt) {
    _composerController.value = TextEditingValue(
      text: prompt,
      selection: TextSelection.collapsed(offset: prompt.length),
    );
    _composerFocusNode.requestFocus();
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
      _lastStreamingTextLength = 0;
      _scrollToBottom(animate: !isFirstLoad);
    } else if (displayMessages.isNotEmpty &&
        displayMessages.last.isStreaming &&
        displayMessages.last.text.length != _lastStreamingTextLength) {
      // Follow streamed text as it grows, unless the user scrolled up to read.
      _lastStreamingTextLength = displayMessages.last.text.length;
      if (_isNearBottom()) {
        _scrollToBottom(animate: false);
      }
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

    final showEmptyState =
        displayMessages.isEmpty &&
        !chatState.isLoadingMessages &&
        !chatState.hasMessagesError;

    final showBack =
        chatState.currentChatId != null || displayMessages.isNotEmpty;
    final canvasColor = aiChatCanvasColor(design);

    final quotaBanner =
        chatState.quotaError != null && chatState.hasActiveRateLimit
        ? _AiNoticeBanner(message: chatState.quotaError!)
        : null;

    Widget buildComposer() {
      return AiComposer(
        enabled: !isInputBlocked,
        onSend: _handleSend,
        controller: _composerController,
        focusNode: _composerFocusNode,
        // onNewChat: _handleNewChat, // Reserved for future attachments.
      );
    }

    return Container(
      color: canvasColor,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AiChatHeader(
            onBack: showBack ? _handleBack : null,
            onMenu: _handleMenu,
          ),

          if (chatState.hasInitError)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.xs,
              ),
              child: _AiNoticeBanner(
                message: l10n.aiInitErrorBanner,
                actionLabel: l10n.labelRetry,
                onAction: () =>
                    ref.read(genericAiChatProvider.notifier).initialize(),
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
                      backgroundColor: canvasColor,
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
                ? SafeArea(
                    top: false,
                    bottom: bottomInset == 0,
                    child: _AiEmptyState(
                      notice: quotaBanner,
                      composer: buildComposer(),
                      onSuggestion: isInputBlocked ? null : _handleSuggestion,
                    ),
                  )
                : AppSemantics.scrollableList(
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
                        key: ValueKey(chatState.currentChatId ?? 'new_chat'),
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                          vertical: design.spacing.sm * 1.5,
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
                            timestamp: DateFormatter.formatTime(item.timestamp),
                            isGenerating: item.isStreaming,
                            hasGenerationError: item.hasGenerationError,
                            onRetry: () => _handleRetry(item.id, false),
                            onCopy: () => _handleCopy(item.text),
                          );
                        },
                      ),
                    ),
                  ),
          ),

          if (!showEmptyState) ...[
            // Quota / Rate-limit warning banner if active
            if (quotaBanner != null)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.xs,
                ),
                child: quotaBanner,
              ),

            // Composer docked to bottom
            Container(
              decoration: BoxDecoration(
                color: canvasColor,
                border: Border(
                  top: BorderSide(color: design.colors.border, width: 1.0),
                ),
              ),
              child: SafeArea(
                top: false,
                bottom: bottomInset == 0,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: design.spacing.md,
                    end: design.spacing.md,
                    top: design.spacing.sm * 1.5,
                    bottom: design.spacing.sm * 1.5,
                  ),
                  child: buildComposer(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Guided empty state: heading, prompt starters, and the composer.
class _AiEmptyState extends StatelessWidget {
  const _AiEmptyState({
    required this.composer,
    required this.onSuggestion,
    this.notice,
  });

  final Widget composer;

  /// Receives the starter prompt of the tapped card. Null disables the cards.
  final ValueChanged<String>? onSuggestion;

  /// Optional banner shown directly above the composer.
  final Widget? notice;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final gap = design.spacing.sm * 1.5;

    Widget card(IconData icon, Color color, String label, String prompt) {
      return AiSuggestionCard(
        icon: icon,
        iconColor: color,
        label: label,
        onTap: onSuggestion == null ? null : () => onSuggestion!(prompt),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Reversed so the composer stays in view when the keyboard leaves
        // less room than the content needs.
        return SingleChildScrollView(
          reverse: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: design.layout.tabletBreakpoint,
                ),
                child: Padding(
                  padding: EdgeInsets.all(design.spacing.md),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSemantics.header(
                        label: l10n.aiEmptyStateTitle,
                        child: ExcludeSemantics(
                          child: AppText.display(
                            l10n.aiEmptyStateTitle,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: design.spacing.xl + design.spacing.xs),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: card(
                                      LucideIcons.bookOpen,
                                      design.colors.accent4,
                                      l10n.aiSuggestionExplainConcept,
                                      l10n.aiSuggestionExplainConceptPrompt,
                                    ),
                                  ),
                                  SizedBox(height: gap),
                                  Expanded(
                                    child: card(
                                      LucideIcons.fileQuestionMark,
                                      design.colors.accent1,
                                      l10n.aiSuggestionPracticeQuestions,
                                      l10n.aiSuggestionPracticeQuestionsPrompt,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: gap),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: card(
                                      LucideIcons.calculator,
                                      design.colors.accent2,
                                      l10n.aiSuggestionSolveProblem,
                                      l10n.aiSuggestionSolveProblemPrompt,
                                    ),
                                  ),
                                  SizedBox(height: gap),
                                  Expanded(
                                    child: card(
                                      LucideIcons.lightbulb,
                                      design.colors.accent3,
                                      l10n.aiSuggestionStudyTips,
                                      l10n.aiSuggestionStudyTipsPrompt,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: design.spacing.lg),
                      if (notice != null) ...[
                        notice!,
                        SizedBox(height: design.spacing.sm),
                      ],
                      composer,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Inline warning banner for connection and quota notices.
class _AiNoticeBanner extends StatelessWidget {
  const _AiNoticeBanner({
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final actionLabel = this.actionLabel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: design.spacing.md,
        vertical: actionLabel != null
            ? design.spacing.xs
            : design.spacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: design.colors.warning.withValues(alpha: 0.12),
        borderRadius: design.radius.card,
        border: Border.all(color: design.colors.warning.withValues(alpha: 0.3)),
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
              message,
              color: design.colors.textPrimary,
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(width: design.spacing.xs),
            AppSemantics.button(
              label: actionLabel,
              onTap: onAction,
              child: GestureDetector(
                onTap: onAction,
                behavior: HitTestBehavior.opaque,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                  child: Center(
                    child: AppText.labelBold(
                      actionLabel,
                      color: design.colors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
