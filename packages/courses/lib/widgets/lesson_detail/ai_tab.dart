import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'package:core/data/config/app_config.dart';
import '../../models/course_content.dart';
import '../../providers/learnlens_provider.dart';

class AITab extends ConsumerStatefulWidget {
  final Lesson lesson;
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

  const _ChatMessage({
    required this.text,
    required this.isAi,
    this.isLoading = false,
  });
}

class _AITabState extends ConsumerState<AITab>
    with AutomaticKeepAliveClientMixin {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = [];
  String _conversationId = '';
  bool _isSubmitting = false;

  @override
  bool get wantKeepAlive => true;

  bool _hasAddedGreeting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasAddedGreeting) {
      _hasAddedGreeting = true;
      _messages.add(
        _ChatMessage(
          text: L10n.of(context).videoAiGreeting,
          isAi: true,
        ),
      );
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

  Future<void> _sendMessage() async {
    final query = _controller.text.trim();
    if (query.isEmpty || _isSubmitting) return;
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

    final contentId = int.tryParse(widget.lesson.id) ?? 0;
    final sessionMap =
        await ref.read(learnlensSessionProvider(contentId).future);

    final sessionToken = sessionMap?['session_token'] as String? ?? '';
    final orgUuid = AppConfig.learnLensOrgUuid;
    final assetId = widget.lesson.learnlensAssetId ??
        widget.lesson.contentUrl ??
        widget.lesson.id;

    if (sessionToken.isEmpty) {
      setState(() {
        if (_messages.isNotEmpty && _messages.last.isLoading) {
          _messages.removeLast();
        }
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
        orgUuid: orgUuid,
        assetId: assetId,
        sessionToken: sessionToken,
        query: query,
        conversationId: _conversationId,
      );

      setState(() {
        _conversationId = chatResponse.conversationId;
        if (_messages.isNotEmpty && _messages.last.isLoading) {
          _messages.removeLast();
        }
        _messages.add(_ChatMessage(text: chatResponse.answer, isAi: true));
        _isSubmitting = false;
      });
      _scrollToBottom(design);
    } catch (e) {
      debugPrint('Error sending AI chat message: $e');
      setState(() {
        if (_messages.isNotEmpty && _messages.last.isLoading) {
          _messages.removeLast();
        }
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
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: design.motion.normal,
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
          child: AppSemantics.scrollableList(
            itemCount: _messages.length,
            label: 'AI Chat Messages',
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
                    accessibilityLabel: 'Send Message',
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
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: AppLoadingIndicator(
                            color: design.colors.accent2,
                          ),
                        ),
                        SizedBox(width: design.spacing.sm),
                        AppText.caption(
                          L10n.of(context).videoAiThinking,
                          color: design.colors.textSecondary,
                        ),
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
                          style: const TextStyle(fontSize: 13, height: 1.4),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
