import 'package:flutter/widgets.dart';

import '../core.dart';

class AiComposer extends StatefulWidget {
  const AiComposer({
    super.key,
    this.onSend,
    this.onAttachImage,
    this.onRemoveAttachment,
    this.onRetryAttachment,
    this.stagedAttachments = const [],
    this.maxAttachments = 4,
    this.enabled = true,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onNewChat,
  });

  final ValueChanged<String>? onSend;
  final VoidCallback? onAttachImage;
  final ValueChanged<String>? onRemoveAttachment;
  final ValueChanged<String>? onRetryAttachment;
  final List<StagedAttachment> stagedAttachments;
  final int maxAttachments;
  final bool enabled;
  final String? hintText;

  /// Optional externally owned controller, for callers that prefill the input.
  final TextEditingController? controller;

  /// Optional externally owned focus node, for callers that focus the input.
  final FocusNode? focusNode;

  /// When provided, a circular new-chat action is shown before the input.
  ///
  /// The 36dp circle is centered in a 48dp touch target, so callers aligning
  /// the circle to a content edge should trim 6dp from that inset.
  final VoidCallback? onNewChat;

  @override
  State<AiComposer> createState() => _AiComposerState();
}

class _AiComposerState extends State<AiComposer> {
  static const double _touchTarget = 48.0;
  static const double _sendButtonSize = 32.0;
  static const double _newChatButtonSize = 36.0;
  static const double _maxInputHeight = 120.0;

  TextEditingController? _ownController;
  FocusNode? _ownFocusNode;
  late final ScrollController _textScrollController;

  TextEditingController get _controller =>
      widget.controller ?? (_ownController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _textScrollController = ScrollController();
  }

  @override
  void dispose() {
    _ownController?.dispose();
    _ownFocusNode?.dispose();
    _textScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AiComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled) {
      _focusNode.unfocus();
    }
  }

  void _submit() {
    if (!widget.enabled) return;
    final hasUploading = widget.stagedAttachments.any((a) => a.isUploading);
    if (hasUploading) return;

    final hasError = widget.stagedAttachments.any((a) => a.hasError);
    if (hasError) return;

    final text = _controller.text.trim();
    if (text.isNotEmpty || widget.stagedAttachments.isNotEmpty) {
      widget.onSend?.call(text);
      _controller.clear();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final placeholder = widget.hintText ?? l10n.aiComposerPlaceholder;
    final onNewChat = widget.onNewChat;
    final onAttachImage = widget.onAttachImage;
    final textInset = design.spacing.sm + design.spacing.xs;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (onNewChat != null) ...[
          AppSemantics.button(
            label: l10n.aiStartNewChat,
            onTap: onNewChat,
            child: GestureDetector(
              onTap: onNewChat,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: _touchTarget,
                height: _touchTarget,
                child: Center(
                  child: Container(
                    width: _newChatButtonSize,
                    height: _newChatButtonSize,
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        LucideIcons.plus,
                        color: design.colors.onSurface,
                        size: design.iconSize.md,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: design.spacing.xs / 2),
        ],
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: design.colors.card,
              borderRadius: BorderRadius.circular(design.radius.xxl),
              border: Border.all(color: design.colors.border, width: 1.0),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: onAttachImage != null
                    ? design.spacing.xs
                    : design.spacing.md + design.spacing.xs,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.stagedAttachments.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: design.spacing.sm,
                        end: design.spacing.sm,
                        top: design.spacing.xs,
                        bottom: design.spacing.xs / 2,
                      ),
                      child: SizedBox(
                        height: 64.0,
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.stagedAttachments.length,
                          separatorBuilder: (_, _) =>
                              SizedBox(width: design.spacing.xs),
                          itemBuilder: (context, index) {
                            final staged = widget.stagedAttachments[index];
                            return AiAttachmentThumbnail(
                              attachment: staged,
                              onRemove: widget.onRemoveAttachment != null
                                  ? () => widget.onRemoveAttachment!(
                                      staged.localId,
                                    )
                                  : null,
                              onRetry: widget.onRetryAttachment != null
                                  ? () => widget.onRetryAttachment!(
                                      staged.localId,
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (onAttachImage != null) ...[
                        Builder(
                          builder: (context) {
                            final canAttach =
                                widget.enabled &&
                                widget.stagedAttachments.length <
                                    widget.maxAttachments;
                            return AppSemantics.button(
                              label: l10n.aiComposerAttachImage,
                              enabled: canAttach,
                              onTap: canAttach ? onAttachImage : null,
                              child: GestureDetector(
                                key: const ValueKey(
                                  'ai_composer_attach_button',
                                ),
                                onTap: canAttach ? onAttachImage : null,
                                behavior: HitTestBehavior.opaque,
                                child: SizedBox(
                                  width: _touchTarget,
                                  height: _touchTarget,
                                  child: Center(
                                    child: Icon(
                                      LucideIcons.plus,
                                      color: canAttach
                                          ? design.colors.textSecondary
                                          : design.colors.textTertiary,
                                      size: design.iconSize.md,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                      Expanded(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: _touchTarget,
                            maxHeight: _maxInputHeight,
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: textInset,
                                ),
                                child: EditableText(
                                  key: const ValueKey(
                                    'ai_composer_editable_text',
                                  ),
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  scrollController: _textScrollController,
                                  readOnly: !widget.enabled,
                                  style: design.typography.body.copyWith(
                                    color: widget.enabled
                                        ? design.colors.textPrimary
                                        : design.colors.textTertiary,
                                  ),
                                  cursorColor: design.colors.primary,
                                  cursorWidth: 2.0,
                                  cursorHeight: 20.0,
                                  cursorRadius: const Radius.circular(1.0),
                                  backgroundCursorColor:
                                      design.colors.textSecondary,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 4,
                                  minLines: 1,
                                ),
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _controller,
                                builder: (context, value, _) {
                                  if (value.text.isNotEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  return IgnorePointer(
                                    child: AppText.body(
                                      placeholder,
                                      color: design.colors.textSecondary,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: design.spacing.xs),
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _controller,
                        builder: (context, value, _) {
                          final hasText = value.text.trim().isNotEmpty;
                          final hasAttachments =
                              widget.stagedAttachments.isNotEmpty;
                          final hasUploading = widget.stagedAttachments.any(
                            (a) => a.isUploading,
                          );
                          final hasUploadError = widget.stagedAttachments.any(
                            (a) => a.hasError,
                          );
                          final canSend =
                              (hasText || hasAttachments) &&
                              !hasUploading &&
                              !hasUploadError &&
                              widget.enabled;

                          return AppSemantics.button(
                            label: l10n.aiComposerSendMessage,
                            enabled: canSend,
                            onTap: canSend ? _submit : null,
                            child: GestureDetector(
                              onTap: canSend ? _submit : null,
                              behavior: HitTestBehavior.opaque,
                              child: SizedBox(
                                width: _touchTarget,
                                height: _touchTarget,
                                child: Center(
                                  child: Container(
                                    width: _sendButtonSize,
                                    height: _sendButtonSize,
                                    decoration: BoxDecoration(
                                      color: canSend
                                          ? design.colors.textPrimary
                                          : design.colors.textPrimary
                                                .withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        LucideIcons.arrowUp,
                                        color: design.colors.textInverse,
                                        size: design.iconSize.sm,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
