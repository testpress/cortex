import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core/core.dart';
import 'dart:math' as math;

import '../widgets/ai_doubt_input_bar.dart';
import '../widgets/ask_doubt_empty_state.dart';
import '../widgets/ask_doubt_header.dart';
import '../widgets/ask_doubt_history_drawer.dart';
import '../widgets/ask_doubt_message_list.dart';
import '../widgets/ask_doubt_overlays.dart';
import '../providers/doubt_session_provider.dart';

class AskDoubtScreen extends ConsumerStatefulWidget {
  const AskDoubtScreen({super.key});

  @override
  ConsumerState<AskDoubtScreen> createState() => _AskDoubtScreenState();
}

class _AskDoubtScreenState extends ConsumerState<AskDoubtScreen> {
  static const _mockAttachmentImageUrl = 'https://picsum.photos/400/300';

  final GlobalKey _composerKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _renameController = TextEditingController();

  bool _isDrawerOpen = false;
  String? _menuSessionId;
  Offset? _menuOffset;
  String? _renamingSessionId;
  double _composerHeight = 0;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _renameController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final l10n = L10n.of(context);
    ref
        .read(doubtSessionProvider.notifier)
        .sendMessage(
          text,
          newChatTitle: l10n.aiDoubtNewChat,
          defaultResponse: l10n.aiDoubtMockResponseDefault,
        );
    _textController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _updateComposerHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _composerKey.currentContext;
      if (context == null) return;

      final size = context.size;
      if (size == null || size.height == _composerHeight) return;

      setState(() {
        _composerHeight = size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final sessionState = ref.watch(doubtSessionProvider);
    final activeSession = sessionState.activeSession;
    final messages = activeSession?.messages ?? [];
    final isThinking = sessionState.isThinking;
    _updateComposerHeight();

    // Scroll to bottom when new messages arrive or thinking state changes
    ref.listen(doubtSessionProvider, (_, __) => _scrollToBottom());

    return Container(
      color: design.colors.surface,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final composerHeight = _composerHeight > 0
              ? _composerHeight
              : design.spacing.xxxl + design.spacing.md;
          final effectiveKeyboardInset = viewInsets > 0 && !isLandscape
              ? math.max(0.0, viewInsets - (design.spacing.xl + design.spacing.sm))
              : viewInsets;
          final visibleBottom = math.max(
            0.0,
            constraints.maxHeight - effectiveKeyboardInset,
          );
          final composerGap = viewInsets > 0
              ? (isLandscape ? design.spacing.xs : 0.0)
              : design.spacing.sm;
          final composerTop = math.max(
            0.0,
            visibleBottom - composerHeight - composerGap,
          );
          final contentBottomPadding =
              constraints.maxHeight - composerTop + design.spacing.sm;

          return Stack(
            children: [
              Container(
                color: design.colors.surface,
                child: Column(
                  children: [
                    AskDoubtHeader(
                      onBack: () => Navigator.of(context).pop(),
                      onOpenMenu: () => setState(() => _isDrawerOpen = true),
                    ),
                    Expanded(
                      child: messages.isEmpty && !isThinking
                          ? Padding(
                              padding: EdgeInsets.only(
                                bottom: contentBottomPadding,
                              ),
                              child: AskDoubtEmptyState(
                                onExplainConcept: () => _handleSuggestion(
                                  l10n.aiDoubtSuggestionExplainPrompt,
                                  response: l10n.aiDoubtMockResponseConcept,
                                ),
                                onSolveProblem: () => _handleSuggestion(
                                  l10n.aiDoubtSuggestionSolvePrompt,
                                  response: l10n.aiDoubtMockResponseSolve,
                                ),
                                onPracticeQuestions: () => _handleSuggestion(
                                  l10n.aiDoubtSuggestionPracticePrompt,
                                  response: l10n.aiDoubtMockResponsePractice,
                                ),
                                onStudyTips: () => _handleSuggestion(
                                  l10n.aiDoubtSuggestionTipsPrompt,
                                  response: l10n.aiDoubtMockResponseTips,
                                ),
                              ),
                            )
                          : AskDoubtMessageList(
                              scrollController: _scrollController,
                              messages: messages,
                              isThinking: isThinking,
                              bottomPadding: contentBottomPadding,
                            ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: design.motion.normal,
                curve: design.motion.easeOut,
                left: 0,
                right: 0,
                top: composerTop,
                child: KeyedSubtree(
                  key: _composerKey,
                  child: AIDoubtInputBar(
                    controller: _textController,
                    onSend: _handleSend,
                    leftSafeArea: false,
                    rightSafeArea: false,
                    onAttach: () {
                      ref.read(doubtSessionProvider.notifier).addImageMessage(
                        _mockAttachmentImageUrl,
                        l10n.aiDoubtImagePrompt,
                        newChatTitle: l10n.aiDoubtNewChat,
                        imageResponse: l10n.aiDoubtImageResponse,
                      );
                    },
                  ),
                ),
              ),
              AskDoubtHistoryDrawer(
                isOpen: _isDrawerOpen,
                sessionState: sessionState,
                onDismiss: () => setState(() => _isDrawerOpen = false),
                onNewChat: () {
                  ref
                      .read(doubtSessionProvider.notifier)
                      .createNewChat(newChatTitle: l10n.aiDoubtNewChat);
                  setState(() => _isDrawerOpen = false);
                },
                onSelectSession: (sessionId) {
                  ref
                      .read(doubtSessionProvider.notifier)
                      .selectSession(sessionId);
                  setState(() => _isDrawerOpen = false);
                },
                onOpenSessionMenu: (sessionId, globalPosition) {
                  setState(() {
                    _menuSessionId = sessionId;
                    _menuOffset = globalPosition;
                  });
                },
              ),
              AskDoubtOverlays(
                menuSessionId: _menuSessionId,
                menuOffset: _menuOffset,
                renamingSessionId: _renamingSessionId,
                sessionState: sessionState,
                renameController: _renameController,
                onDismissMenu: () => setState(() => _menuSessionId = null),
                onDismissRename: () => setState(() => _renamingSessionId = null),
                onTogglePin: (sessionId) {
                  ref
                      .read(doubtSessionProvider.notifier)
                      .togglePinSession(sessionId);
                  setState(() => _menuSessionId = null);
                },
                onDelete: (sessionId) {
                  ref.read(doubtSessionProvider.notifier).deleteSession(sessionId);
                  setState(() => _menuSessionId = null);
                },
                onStartRename: (sessionId, title) {
                  _renameController.text = title;
                  setState(() {
                    _renamingSessionId = sessionId;
                    _menuSessionId = null;
                  });
                },
                onSubmitRename: (sessionId, title) {
                  if (title.isNotEmpty) {
                    ref
                        .read(doubtSessionProvider.notifier)
                        .renameSession(sessionId, title);
                  }
                  setState(() => _renamingSessionId = null);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleSuggestion(String text, {required String response}) {
    final l10n = L10n.of(context);
    ref
        .read(doubtSessionProvider.notifier)
        .sendMessage(
          text,
          newChatTitle: l10n.aiDoubtNewChat,
          defaultResponse: l10n.aiDoubtMockResponseDefault,
          assistantResponse: response,
        );
    _scrollToBottom();
  }
}
