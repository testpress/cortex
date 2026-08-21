import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';
import '../data/ai_chat_mock_data.dart';

class AiChatImmersiveScreen extends ConsumerStatefulWidget {
  const AiChatImmersiveScreen({super.key});

  @override
  ConsumerState<AiChatImmersiveScreen> createState() =>
      _AiChatImmersiveScreenState();
}

class _AiChatImmersiveScreenState extends ConsumerState<AiChatImmersiveScreen> {
  late final ScrollController _scrollController;
  final List<AiChatMessage> _messages = [];
  bool _initialized = false;
  bool _isTyping = false;
  Timer? _typewriterTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom({bool animate = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final design = Design.of(context);
        final shouldAnimate =
            animate && MotionPreferences.shouldAnimate(context);
        if (shouldAnimate) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: design.motion.normal,
            curve: design.motion.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  void _onSendMessage(String text) {
    setState(() {
      _messages.add(
        AiChatMessage(
          content: text,
          timestamp: DateTime.now(),
          role: MessageRole.user,
        ),
      );
      _isTyping = true;
    });
    _scrollToBottom();

    // Show 3 dots bouncing for 1500ms
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add(
          AiChatMessage(
            content: '',
            timestamp: DateTime.now(),
            role: MessageRole.ai,
          ),
        );
      });
      _scrollToBottom();

      const reply =
          "I am an **AI assistant** designed for:\n\n- 🙋‍♂️ **Answering doubts** in real-time\n- 🧠 **Clearing concepts** with examples\n- 🚀 **Learning faster** and more efficiently";
      final replyChars = reply.characters;
      int charIndex = 0;
      _typewriterTimer = Timer.periodic(const Duration(milliseconds: 30), (
        timer,
      ) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (charIndex < replyChars.length) {
          charIndex++;
          setState(() {
            final lastIndex = _messages.length - 1;
            _messages[lastIndex] = AiChatMessage(
              content: replyChars.take(charIndex).toString(),
              timestamp: _messages[lastIndex].timestamp,
              role: MessageRole.ai,
            );
          });
          _scrollToBottom();
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    // Load initial mock messages once
    if (!_initialized) {
      final state = GoRouterState.of(context);
      final sessionId = state.uri.queryParameters['id'];
      if (sessionId != null) {
        final session = mockChatSessions.firstWhere(
          (s) => s.id == sessionId,
          orElse: () => mockChatSessions.first,
        );
        _messages.addAll(session.messages);
      }
      _initialized = true;
      _scrollToBottom(animate: false);
    }

    final hasMessages = _messages.isNotEmpty || _isTyping;
    final state = GoRouterState.of(context);
    final sessionId = state.uri.queryParameters['id'];
    final session = sessionId != null
        ? mockChatSessions.firstWhere(
            (s) => s.id == sessionId,
            orElse: () => mockChatSessions.first,
          )
        : null;

    final headerTitle = session != null ? session.title : l10n.aiNewChatHeader;

    return Container(
      color: design.colors.card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(
            title: headerTitle,
            leading: AppBackButton(onTap: () => context.pop()),
            actions: [
              AppIconButton(
                icon: LucideIcons.history,
                onTap: () => context.push('/ai/history'),
                accessibilityLabel: l10n.aiChatHistoryTitle,
                size: design.iconSize.action,
                color: design.colors.textSecondary,
              ),
            ],
          ),
          Expanded(
            child: hasMessages
                ? AppScroll(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.screenPadding,
                      vertical: design.spacing.lg,
                    ),
                    children: [
                      ..._messages.map((message) {
                        final isUser = message.role == MessageRole.user;
                        if (isUser) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  margin: EdgeInsets.only(
                                    bottom: design.spacing.md,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth * 0.75,
                                  ),
                                  padding: EdgeInsets.all(design.spacing.sm),
                                  decoration: BoxDecoration(
                                    color: design.colors.primary,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: AppText.bodySmall(
                                    message.content,
                                    color: design.colors.textInverse,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(bottom: design.spacing.lg),
                            child: AppMarkdown(data: message.content),
                          );
                        }
                      }),
                      if (_isTyping)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: design.spacing.lg),
                            child: const _TypingIndicator(),
                          ),
                        ),
                    ],
                  )
                : Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.bot,
                            size: 64.0,
                            color: design.colors.primary,
                          ),
                          SizedBox(height: design.spacing.md),
                          AppText.title(
                            l10n.aiComposerGreeting,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: design.spacing.lg),
                          AiComposer(onSend: _onSendMessage),
                        ],
                      ),
                    ),
                  ),
          ),
          if (hasMessages)
            SafeArea(
              top: false,
              left: false,
              right: false,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.lg,
                ),
                child: AiComposer(onSend: _onSendMessage),
              ),
            ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(vsync: this);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final design = Design.of(context);

    for (var controller in _controllers) {
      controller.duration = design.motion.normal;
    }

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: -8.0).animate(
        CurvedAnimation(parent: controller, curve: design.motion.easeInOut),
      );
    }).toList();

    if (!_animationStarted) {
      _animationStarted = true;
      _startAnimation();
    }
  }

  void _startAnimation() async {
    if (!MotionPreferences.shouldAnimate(context)) return;
    final design = Design.of(context);
    for (int i = 0; i < 3; i++) {
      if (!mounted) return;
      _controllers[i].repeat(reverse: true);
      await Future.delayed(design.motion.fast);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isAnimated = MotionPreferences.shouldAnimate(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            final yOffset = isAnimated ? _animations[index].value : 0.0;
            return Transform.translate(
              offset: Offset(0, yOffset),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: design.spacing.xs / 2),
                decoration: BoxDecoration(
                  color: design.colors.textSecondary,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
