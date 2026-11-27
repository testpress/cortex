import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../core.dart';

/// Type alias preserving backward compatibility for widget tests and callers.
typedef AiChatMessageItem = GenericAiChatMessage;

/// Direct, conversational generic AI chat screen.
class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({
    super.key,
    this.initialMessages = const [],
    this.onOpenHistory,
    this.imagePicker,
    this.imageCropper,
  });

  static const int maxAttachmentSizeBytes =
      AiAttachmentUtils.maxAttachmentSizeBytes;
  static const Map<String, String> supportedImageFormats =
      AiAttachmentUtils.supportedImageFormats;

  /// Extracts the lowercased file extension from a file path or file name.
  static String extractExtension(String pathOrName) =>
      AiAttachmentUtils.extractExtension(pathOrName);

  /// Validates whether a file format or MIME type is supported for attachment.
  static bool isSupportedImageFile({String? pathOrName, String? mimeType}) =>
      AiAttachmentUtils.isSupportedFile(
        pathOrName: pathOrName,
        mimeType: mimeType,
      );

  /// Optional seed messages for testing and state verification.
  final List<AiChatMessageItem> initialMessages;

  /// Optional menu/history navigation callback; rename intent is not forwarded.
  final VoidCallback? onOpenHistory;

  /// Optional [ImagePicker] instance for test injection.
  final ImagePicker? imagePicker;

  /// Optional [AppImageCropper] instance for test injection.
  final AppImageCropper? imageCropper;

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen>
    with WidgetsBindingObserver {
  late final ScrollController _scrollController;
  late final TextEditingController _composerController;
  late final FocusNode _composerFocusNode;
  int _lastMessageCount = 0;
  int _lastStreamingTextLength = 0;
  double _lastBottomInset = 0;
  String? _activeChatId;
  bool _isAttachmentSheetOpen = false;
  bool _isCroppingImage = false;
  final LayerLink _attachLayerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _composerController.dispose();
    _composerFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      ref.read(genericAiChatProvider.notifier).syncCanonicalState().ignore();
    }
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

  void _handleNewChat() {
    ref.read(genericAiChatProvider.notifier).startNewChat();
  }

  Future<void> _handleDeleteActiveConversation(String chatId) async {
    await confirmAndDeleteConversation(
      context: context,
      ref: ref,
      chatId: chatId,
      title: ref.read(genericAiChatProvider).currentTitle,
    );
  }

  void _handleRenameActiveConversation(String chatId) {
    final chatState = ref.read(genericAiChatProvider);
    if (chatState.hasActiveGeneration(chatId)) {
      AppToast.show(
        context,
        message: L10n.of(context).aiCannotRenameWhileGenerating,
        isError: true,
      );
      return;
    }
    _composerFocusNode.unfocus();
    if (widget.onOpenHistory != null) {
      // Host callback handles drawer opening only; rename intent is not forwarded.
      widget.onOpenHistory!();
    } else {
      context.push('/ai/history', extra: chatId);
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

  void _handleAttachImage() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isAttachmentSheetOpen = true;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isAttachmentSheetOpen = false;
    });
    try {
      final picker = widget.imagePicker ?? ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      if (!AiAttachmentUtils.isSupported(picked)) {
        _showToast(
          L10n.of(context).aiChatUnsupportedImageFormat,
          isError: true,
        );
        return;
      }

      setState(() => _isCroppingImage = true);

      final cropper = widget.imageCropper ?? AppImageCropper();
      final croppedPath = await cropper.crop(context, imagePath: picked.path);
      if (croppedPath == null || !mounted) return;

      final file = XFile(croppedPath);
      final bytes = await file.readAsBytes();
      if (!mounted) return;

      if (bytes.lengthInBytes > AiAttachmentUtils.maxAttachmentSizeBytes) {
        _showToast(
          L10n.of(context).aiChatAttachmentSizeExceeded,
          isError: true,
        );
        return;
      }

      final candidateName = file.name.isNotEmpty
          ? file.name
          : (file.path.isNotEmpty
                ? file.path
                : (picked.name.isNotEmpty ? picked.name : picked.path));
      final extension = AiAttachmentUtils.extractExtension(candidateName);

      final mimeType = AiAttachmentUtils.deriveMimeType(
        pathOrName: candidateName,
        mimeType: picked.mimeType,
      );

      if (mimeType == null) {
        _showToast(
          L10n.of(context).aiChatUnsupportedImageFormat,
          isError: true,
        );
        return;
      }

      final baseFileName = file.name.isNotEmpty
          ? file.name
          : (picked.name.isNotEmpty ? picked.name : 'image');
      final extensionToUse = extension.isNotEmpty
          ? extension
          : (mimeType == 'image/png'
                ? 'png'
                : (mimeType == 'image/webp' ? 'webp' : 'jpg'));
      final fileName = baseFileName.contains('.')
          ? baseFileName
          : '$baseFileName.$extensionToUse';

      ref
          .read(genericAiChatProvider.notifier)
          .stageAttachment(
            bytes: bytes,
            fileName: fileName,
            mimeType: mimeType,
          );
    } on PlatformException catch (e) {
      if (!mounted) return;
      final isPermission =
          e.code == 'camera_access_denied' ||
          e.code == 'photo_access_denied' ||
          e.code.toLowerCase().contains('permission');
      if (isPermission) {
        _showToast(L10n.of(context).aiChatPermissionRequired, isError: true);
      } else {
        ref.read(sentryServiceProvider).captureException(e);
        _showToast(
          L10n.of(context).aiComposerAttachmentUploadFailed,
          isError: true,
        );
      }
    } catch (e, stack) {
      if (!mounted) return;
      ref.read(sentryServiceProvider).captureException(e, stackTrace: stack);
      _showToast(
        L10n.of(context).aiComposerAttachmentUploadFailed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isCroppingImage = false);
      }
    }
  }

  void _showToast(String message, {bool isError = false}) {
    if (!mounted) return;
    final fToast = FToast()..init(context);
    fToast.removeCustomToast();

    final design = Design.of(context);
    final padding = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);

    final bottomOffset = viewInsets.bottom > 0
        ? viewInsets.bottom + design.spacing.md
        : padding.bottom + design.spacing.md;

    fToast.showToast(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: design.spacing.md,
          vertical: design.spacing.sm * 1.5,
        ),
        decoration: BoxDecoration(
          color: design.colors.textPrimary,
          borderRadius: BorderRadius.circular(design.radius.xl),
          boxShadow: design.shadows.floating,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isError ? LucideIcons.alertTriangle : LucideIcons.check,
              size: 20,
              color: isError ? design.colors.error : design.colors.success,
            ),
            SizedBox(width: design.spacing.sm),
            Flexible(
              child: AppText.labelBold(
                message,
                color: design.colors.textInverse,
              ),
            ),
          ],
        ),
      ),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          bottom: bottomOffset,
          left: 24.0,
          right: 24.0,
          child: child,
        );
      },
      toastDuration: const Duration(milliseconds: 2500),
    );
  }

  void _handleRemoveAttachment(String localId) {
    ref.read(genericAiChatProvider.notifier).removeAttachment(localId).ignore();
  }

  void _handleRetryAttachment(String localId) {
    ref.read(genericAiChatProvider.notifier).retryAttachment(localId).ignore();
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

    ref.listen<GenericAiChatState>(genericAiChatProvider, (previous, next) {
      final prevErrors =
          previous?.stagedAttachments.where((a) => a.hasError).length ?? 0;
      final nextErrors = next.stagedAttachments.where((a) => a.hasError).length;
      if (nextErrors > prevErrors) {
        _showToast(
          L10n.of(context).aiComposerAttachmentUploadFailed,
          isError: true,
        );
      }
    });

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

    final isAccessRestricted = chatState.hasAccessDenied;

    final isInputBlocked =
        chatState.isSending ||
        chatState.isGenerating ||
        chatState.hasActiveRateLimit ||
        chatState.hasMessagesError ||
        isAccessRestricted;

    final showEmptyState =
        displayMessages.isEmpty &&
        !chatState.isLoadingMessages &&
        !chatState.hasMessagesError;

    final hasActiveContent =
        chatState.currentChatId != null || displayMessages.isNotEmpty;
    final canvasColor = aiChatCanvasColor(design);

    final noticeBanner = isAccessRestricted
        ? _AiNoticeCard(
            icon: LucideIcons.lock,
            title: l10n.aiAccessRestrictedTitle,
            message: l10n.aiAccessRestrictedMessage,
          )
        : (chatState.quotaError != null && chatState.hasActiveRateLimit
              ? _AiNoticeCard(message: chatState.quotaError!)
              : null);

    Widget buildComposer() {
      return AiComposer(
        enabled: !isInputBlocked,
        stagedAttachments: chatState.stagedAttachments,
        onSend: _handleSend,
        onAttachImage: chatState.imageAttachmentsEnabled
            ? _handleAttachImage
            : null,
        onRemoveAttachment: _handleRemoveAttachment,
        onRetryAttachment: _handleRetryAttachment,
        controller: _composerController,
        focusNode: _composerFocusNode,
        attachLayerLink: _attachLayerLink,
      );
    }

    return Container(
      color: canvasColor,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AiChatHeader(
                  onMenu: _handleMenu,
                  title: chatState.currentTitle,
                  onNewChat: hasActiveContent ? _handleNewChat : null,
                  onRename: chatState.currentChatId != null
                      ? () => _handleRenameActiveConversation(
                          chatState.currentChatId!,
                        )
                      : null,
                  onDelete: chatState.currentChatId != null
                      ? () => _handleDeleteActiveConversation(
                          chatState.currentChatId!,
                        )
                      : null,
                ),

                if (chatState.hasInitError)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.xs,
                    ),
                    child: _AiNoticeCard(
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
                                    .selectConversation(
                                      chatState.currentChatId!,
                                    );
                              }
                            },
                          ),
                        )
                      : displayMessages.isEmpty
                      ? SafeArea(
                          top: false,
                          bottom: bottomInset == 0,
                          child: _AiEmptyState(
                            notice: noticeBanner,
                            composer: buildComposer(),
                            onSuggestion: isInputBlocked
                                ? null
                                : _handleSuggestion,
                          ),
                        )
                      : AppSemantics.scrollableList(
                          itemCount: displayMessages.length,
                          label: l10n.aiSupportTitle,
                          child:
                              NotificationListener<ScrollMetricsNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.pixels >
                                          notification
                                              .metrics
                                              .maxScrollExtent &&
                                      notification.metrics.maxScrollExtent >=
                                          0) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
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
                                    horizontal: design.spacing.md,
                                    vertical: design.spacing.sm * 1.5,
                                  ),
                                  itemCount: displayMessages.length,
                                  itemBuilder: (context, index) {
                                    final item = displayMessages[index];
                                    if (item.isUser) {
                                      return AiUserMessageBubble(
                                        message: item.text,
                                        attachments: item.attachments,
                                        timestamp: DateFormatter.formatTime(
                                          item.timestamp,
                                        ),
                                        isSending: item.isSending,
                                        hasSendError: item.hasSendError,
                                        onRetry: () =>
                                            _handleRetry(item.id, true),
                                      );
                                    }
                                    final status = item.hasGenerationError
                                        ? AiAssistantStatus.failed
                                        : item.isStreaming
                                        ? AiAssistantStatus.generating
                                        : item.isStopped
                                        ? AiAssistantStatus.stopped
                                        : AiAssistantStatus.completed;

                                    return AiAssistantCard(
                                      message: item.text,
                                      timestamp: DateFormatter.formatTime(
                                        item.timestamp,
                                      ),
                                      status: status,
                                      onRetry: () =>
                                          _handleRetry(item.id, false),
                                      onCopy: () => _handleCopy(item.text),
                                    );
                                  },
                                ),
                              ),
                        ),
                ),

                if (!showEmptyState) ...[
                  // Quota / Rate-limit warning banner if active
                  if (noticeBanner != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                        vertical: design.spacing.xs,
                      ),
                      child: noticeBanner,
                    ),

                  // Composer docked to bottom
                  Container(
                    decoration: BoxDecoration(
                      color: canvasColor,
                      border: Border(
                        top: BorderSide(
                          color: design.colors.border,
                          width: 1.0,
                        ),
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
          ),
          AiAttachmentPickerSheet(
            isOpen: _isAttachmentSheetOpen,
            anchorLink: _attachLayerLink,
            onClose: () => setState(() => _isAttachmentSheetOpen = false),
            onSelectCamera: () => _pickImage(ImageSource.camera),
            onSelectGallery: () => _pickImage(ImageSource.gallery),
          ),
          if (_isCroppingImage)
            Positioned.fill(
              key: const ValueKey('ai_crop_loading_overlay'),
              child: Container(
                color: design.colors.surface.withValues(alpha: 0.7),
                child: const Center(child: AppLoadingIndicator()),
              ),
            ),
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
                        SizedBox(height: design.spacing.md),
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

/// Shared notice card for warning, restriction, and connection states in AI chat.
class _AiNoticeCard extends StatelessWidget {
  const _AiNoticeCard({
    required this.message,
    this.title,
    this.icon = LucideIcons.alertTriangle,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final String? title;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final color = design.colors.warning;
    final actionLabel = this.actionLabel;
    final hasTitle = title != null && title!.isNotEmpty;

    return AppSemantics.container(
      label: hasTitle ? '$title. $message' : message,
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: design.radius.card,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: design.spacing.xs, color: color),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: design.spacing.md,
                      vertical: design.spacing.sm + design.spacing.xs,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: hasTitle
                              ? design.iconSize.lg
                              : design.iconSize.sm,
                          color: color,
                        ),
                        SizedBox(width: design.spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasTitle) ...[
                                AppText.cardTitle(title!),
                                SizedBox(height: design.spacing.xs),
                                AppText.caption(
                                  message,
                                  color: design.colors.textSecondary,
                                ),
                              ] else
                                AppText.labelSmall(
                                  message,
                                  color: design.colors.textPrimary,
                                ),
                            ],
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
