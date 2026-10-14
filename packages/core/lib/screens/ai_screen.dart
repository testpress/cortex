import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../core.dart';
import '../data/ai_chat_mock_data.dart';

class AiChatMessageItem {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isSending;
  final bool hasSendError;
  final bool hasGenerationError;

  const AiChatMessageItem({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isSending = false,
    this.hasSendError = false,
    this.hasGenerationError = false,
  });
}

class AiScreen extends StatefulWidget {
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
  /// If null, navigates to the default history route.
  final VoidCallback? onOpenHistory;

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  late final List<AiChatMessageItem> _messages;
  late final ScrollController _scrollController;
  bool _isGenerating = false;
  int _messageCounter = 0;

  String _nextId() => 'msg_${++_messageCounter}';

  @override
  void initState() {
    super.initState();
    _messages = List.of(widget.initialMessages);
    _messageCounter = _messages.length;
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      final design = Design.of(context);
      if (MotionPreferences.shouldAnimate(context)) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: design.motion.normal,
          curve: design.motion.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _handleBack() {
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
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    final isSendErrorTrigger = isMockSendErrorTrigger(cleanText);
    final isGenErrorTrigger = isMockGenerationErrorTrigger(cleanText);
    final messageId = _nextId();

    final userMessage = AiChatMessageItem(
      id: messageId,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      isSending: !isSendErrorTrigger,
      hasSendError: isSendErrorTrigger,
    );

    setState(() {
      _messages.add(userMessage);
      _isGenerating = !isSendErrorTrigger;
    });
    _scrollToBottom();

    if (isSendErrorTrigger) {
      return;
    }

    // Simulate realistic generation delay (~1.2 seconds)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      setState(() {
        _isGenerating = false;
        final userIndex = _messages.indexWhere((m) => m.id == messageId);
        if (userIndex != -1) {
          _messages[userIndex] = AiChatMessageItem(
            id: userMessage.id,
            text: userMessage.text,
            isUser: true,
            timestamp: DateTime.now(),
            isSending: false,
          );
        }
        _messages.add(
          AiChatMessageItem(
            id: _nextId(),
            text: isGenErrorTrigger ? '' : generateMockAiResponse(cleanText),
            isUser: false,
            timestamp: DateTime.now(),
            hasGenerationError: isGenErrorTrigger,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _handleRetry(String messageId) {
    if (_isGenerating) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final message = _messages[index];
    if (message.hasSendError) {
      // Clear send error and deliver message
      setState(() {
        _messages[index] = AiChatMessageItem(
          id: message.id,
          text: message.text,
          isUser: true,
          timestamp: DateTime.now(),
          isSending: true,
          hasSendError: false,
        );
        _isGenerating = true;
      });
      _scrollToBottom();

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _isGenerating = false;
          final userIndex = _messages.indexWhere((m) => m.id == messageId);
          if (userIndex != -1) {
            _messages[userIndex] = AiChatMessageItem(
              id: message.id,
              text: message.text,
              isUser: true,
              timestamp: DateTime.now(),
              isSending: false,
            );
          }
          _messages.add(
            AiChatMessageItem(
              id: _nextId(),
              text: generateMockAiResponse(message.text),
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      });
    } else if (message.hasGenerationError) {
      // Find the user prompt that preceded this assistant response
      String prompt = '';
      for (int i = index - 1; i >= 0; i--) {
        if (_messages[i].isUser) {
          prompt = _messages[i].text;
          break;
        }
      }

      // Retry AI generation
      setState(() {
        _isGenerating = true;
      });

      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _isGenerating = false;
          _messages[index] = AiChatMessageItem(
            id: message.id,
            text: generateMockAiResponse(
              prompt.isNotEmpty ? prompt : message.text,
            ),
            isUser: false,
            timestamp: DateTime.now(),
            hasGenerationError: false,
          );
        });
        _scrollToBottom();
      });
    }
  }

  void _handleCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Container(
      color: design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AiChatHeader(onBack: _handleBack, onMenu: _handleMenu),
          Expanded(
            child: _messages.isEmpty
                ? const SizedBox.expand()
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 768.0),
                      child: AppSemantics.scrollableList(
                        itemCount: _messages.length,
                        label: l10n.aiSupportTitle,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(
                            horizontal: design.spacing.screenPadding,
                            vertical: design.spacing.md,
                          ),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final item = _messages[index];
                            if (item.isUser) {
                              return AiUserMessageBubble(
                                message: item.text,
                                timestamp: DateFormatter.formatTime(
                                  item.timestamp,
                                ),
                                isSending: item.isSending,
                                hasSendError: item.hasSendError,
                                onRetry: () => _handleRetry(item.id),
                              );
                            }
                            return AiAssistantCard(
                              message: item.text,
                              timestamp: DateFormatter.formatTime(
                                item.timestamp,
                              ),
                              hasGenerationError: item.hasGenerationError,
                              onRetry: () => _handleRetry(item.id),
                              onCopy: () => _handleCopy(item.text),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),
          SafeArea(
            top: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 768.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.screenPadding,
                    vertical: design.spacing.sm,
                  ),
                  child: AiComposer(
                    enabled: !_isGenerating,
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
