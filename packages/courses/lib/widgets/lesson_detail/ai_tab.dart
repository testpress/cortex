import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import '../../providers/learnlens_provider.dart';

class AITab extends ConsumerStatefulWidget {
  final LessonDto lesson;
  final ValueChanged<Duration>? onSeek;
  final WidgetBuilder? footerBuilder;

  const AITab({
    super.key,
    required this.lesson,
    this.onSeek,
    this.footerBuilder,
  });

  @override
  ConsumerState<AITab> createState() => _AITabState();
}

class _ChatMessage {
  final String text;
  final bool isAi;
  final bool isLoading;
  final String messageType;
  final List<dynamic>? citations;

  const _ChatMessage({
    required this.text,
    required this.isAi,
    this.isLoading = false,
    this.messageType = 'text',
    this.citations,
  });
}

class _AITabState extends ConsumerState<AITab>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  String _chatId = '';
  bool _isSubmitting = false;
  bool _isLoadingHistory = true;
  String? _historyError;
  bool _hasStartedHydration = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasStartedHydration) {
      _hasStartedHydration = true;
      _hydrateChatHistory();
    }
  }

  @override
  void didUpdateWidget(AITab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lesson.id != oldWidget.lesson.id) {
      _controller.clear();
      _chatId = '';
      _messages.clear();
      _hydrateChatHistory();
    }
  }

  Future<void> _hydrateChatHistory({bool forceRefresh = false}) async {
    final requestedLessonId = widget.lesson.id;
    setState(() {
      _isLoadingHistory = true;
      _historyError = null;
    });

    try {
      final session = await resolveLearnLensSession(
        ref,
        widget.lesson,
        forceRefresh: forceRefresh,
      );

      if (!mounted || widget.lesson.id != requestedLessonId) {
        return;
      }

      if (session == null) {
        setState(() {
          _isLoadingHistory = false;
          _historyError = L10n.of(context).videoAiSessionError;
        });
        return;
      }

      final repository = ref.read(learnLensRepositoryProvider);
      final chatHistory = await repository.fetchLatestChatHistory(
        orgUuid: session.orgUuid,
        assetId: session.assetId,
        sessionToken: session.sessionToken,
        contentId: session.contentId,
      );

      if (!mounted || widget.lesson.id != requestedLessonId) {
        return;
      }

      _chatId = chatHistory.chatId;
      List<_ChatMessage> loaded = chatHistory.messages
          .map((m) => _ChatMessage(
                text: m.content,
                isAi: m.isAi,
                messageType: m.messageType,
                citations: m.citations,
              ))
          .toList();

      if (loaded.isEmpty) {
        loaded = [
          _ChatMessage(
            text: L10n.of(context).videoAiGreeting,
            isAi: true,
          ),
        ];
      }

      setState(() {
        _messages
          ..clear()
          ..addAll(loaded);
        _isLoadingHistory = false;
      });

      final design = Design.of(context);
      _scrollToBottom(design);
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (!mounted || widget.lesson.id != requestedLessonId) return;
      setState(() {
        _isLoadingHistory = false;
        _historyError = L10n.of(context).videoAiError;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _processMarkdown(String raw) {
    var processed =
        raw.replaceAll(RegExp(r'<style>.*?</style>', dotAll: true), '');
    processed = processed.replaceAllMapped(
      RegExp(r'<span class="video-timestamp">(.*?)</span>'),
      (match) => '[${match.group(1)}](timestamp:${match.group(1)})',
    );
    return processed;
  }

  void _removeLoadingMessage() {
    if (_messages.isNotEmpty && _messages.last.isLoading) {
      _messages.removeLast();
    }
  }

  Future<void> _sendMessage() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _isSubmitting || _isLoadingHistory) return;
    final currentLessonId = widget.lesson.id;
    final design = Design.of(context);
    final l10n = L10n.of(context);

    _controller.clear();
    setState(() {
      _messages.add(_ChatMessage(text: query, isAi: false));
      _messages.add(
        const _ChatMessage(text: '', isAi: true, isLoading: true),
      );
      _isSubmitting = true;
    });
    _scrollToBottom(design);

    final session = await resolveLearnLensSession(ref, widget.lesson);
    if (!mounted || widget.lesson.id != currentLessonId) {
      return;
    }

    if (session == null) {
      setState(() {
        _removeLoadingMessage();
        _messages.add(
          _ChatMessage(
            text: l10n.videoAiSessionError,
            isAi: true,
          ),
        );
        _isSubmitting = false;
      });
      return;
    }

    try {
      final repository = ref.read(learnLensRepositoryProvider);
      final chatResponse = await repository.submitChat(
        orgUuid: session.orgUuid,
        assetId: session.assetId,
        sessionToken: session.sessionToken,
        query: query,
        chatId: _chatId,
        contentId: session.contentId,
      );

      if (!mounted || widget.lesson.id != currentLessonId) {
        return;
      }

      setState(() {
        _chatId = chatResponse.chatId;
        _removeLoadingMessage();
        _messages.add(_ChatMessage(
          text: chatResponse.answer,
          isAi: true,
          messageType: chatResponse.messageType,
          citations: chatResponse.citations,
        ));
        _isSubmitting = false;
      });
      _scrollToBottom(design);
    } catch (e, stack) {
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      if (!mounted || widget.lesson.id != currentLessonId) return;
      setState(() {
        _removeLoadingMessage();
        _messages.add(
          _ChatMessage(
            text: l10n.videoAiError,
            isAi: true,
          ),
        );
        _isSubmitting = false;
      });
    }
  }

  final _scrollController = ScrollController();

  void _scrollToBottom(DesignConfig design) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_scrollController.hasClients) {
        final duration = MotionPreferences.duration(
          context,
          design.motion.normal,
        );
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: duration,
          curve: design.motion.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scrollable messages area
        Expanded(
          child: _isLoadingHistory
              ? Center(
                  child: AppLoadingIndicator(
                    color: design.colors.accent2,
                  ),
                )
              : _historyError != null
                  ? AppErrorView(
                      message: _historyError,
                      onRetry: () => _hydrateChatHistory(forceRefresh: true),
                    )
                  : AppSemantics.scrollableList(
                      itemCount: _messages.length,
                      label: l10n.aiSupportTitle,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(design.spacing.md),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return _buildChatBubble(_messages[index], design);
                        },
                      ),
                    ),
        ),
        // Pinned composer at bottom
        Container(
          padding: EdgeInsets.fromLTRB(
            design.spacing.md,
            design.spacing.sm,
            design.spacing.md,
            design.spacing.sm + bottomInset,
          ),
          decoration: BoxDecoration(
            color: design.colors.surface,
            border: Border(
              top: BorderSide(
                color: design.colors.divider.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, _) {
              final isDirty = value.text.trim().isNotEmpty;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppTextField(
                      label: '',
                      controller: _controller,
                      hintText: l10n.videoLessonAiHint,
                      onSubmitted: _isSubmitting ? null : (_) => _sendMessage(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.sm,
                      ),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppIconButton(
                    icon: LucideIcons.sendHorizontal,
                    onTap: isDirty && !_isSubmitting ? _sendMessage : () {},
                    accessibilityLabel: l10n.videoAiSendMessage,
                    color: isDirty && !_isSubmitting
                        ? design.colors.accent2
                        : design.colors.textTertiary,
                  ),
                ],
              );
            },
          ),
        ),
        if (widget.footerBuilder != null && !isKeyboardOpen)
          widget.footerBuilder!(context),
      ],
    );
  }

  Widget _buildChatBubble(_ChatMessage message, DesignConfig design) {
    final isAI = message.isAi;
    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI)
            Container(
              width: 28,
              height: 28,
              margin: EdgeInsets.only(right: design.spacing.sm, top: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [design.colors.accent2, design.colors.accent1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(design.radius.sm),
              ),
              child: Center(
                child: Icon(
                  LucideIcons.sparkles,
                  size: 14,
                  color: design.colors.textInverse,
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(design.spacing.sm),
              decoration: BoxDecoration(
                color: isAI ? design.colors.card : design.colors.accent2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isAI ? 0 : design.radius.md),
                  topRight: Radius.circular(isAI ? design.radius.md : 0),
                  bottomLeft: Radius.circular(design.radius.md),
                  bottomRight: Radius.circular(design.radius.md),
                ),
                border: isAI ? Border.all(color: design.colors.divider) : null,
              ),
              child: message.isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.caption(
                          L10n.of(context).videoAiThinking,
                          color: design.colors.textSecondary,
                        ),
                        SizedBox(width: design.spacing.xs),
                        _ThreeDotWavingIndicator(
                            color: design.colors.textSecondary),
                      ],
                    )
                  : isAI
                      ? AppMarkdown(
                          data: _processMarkdown(message.text),
                          selectable: true,
                          onTapLink: (url) {
                            if (url.startsWith('timestamp:')) {
                              final timeStr =
                                  url.substring('timestamp:'.length);
                              final duration =
                                  TimeFormatter.parseDuration(timeStr);
                              widget.onSeek?.call(duration);
                            }
                          },
                        )
                      : AppText.body(
                          message.text,
                          color: design.colors.textInverse,
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeDotWavingIndicator extends StatefulWidget {
  final Color color;

  const _ThreeDotWavingIndicator({required this.color});

  @override
  State<_ThreeDotWavingIndicator> createState() =>
      __ThreeDotWavingIndicatorState();
}

class __ThreeDotWavingIndicatorState extends State<_ThreeDotWavingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final design = Design.of(context);
    final duration = MotionPreferences.duration(
      context,
      design.motion.slow,
    );
    _controller.duration = duration;

    if (MotionPreferences.shouldAnimate(context)) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shouldAnimate = MotionPreferences.shouldAnimate(context);

    // When reduced motion is on, render three static dots with no animation.
    if (!shouldAnimate) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Container(
              width: 3.5,
              height: 3.5,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = (_controller.value - delay) % 1.0;
            final double dy =
                (value < 0.5) ? (value * 2 * -4.0) : ((1.0 - value) * 2 * -4.0);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Transform.translate(
                offset: Offset(0, dy.clamp(-4.0, 0.0)),
                child: Container(
                  width: 3.5,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
