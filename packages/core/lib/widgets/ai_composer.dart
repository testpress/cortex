import 'package:flutter/widgets.dart';

import '../core.dart';

class AiComposer extends StatefulWidget {
  const AiComposer({
    super.key,
    this.onSend,
    this.enabled = true,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onNewChat,
  });

  final ValueChanged<String>? onSend;
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
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
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
                start: design.spacing.md + design.spacing.xs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                            padding: EdgeInsets.symmetric(vertical: textInset),
                            child: EditableText(
                              key: const ValueKey('ai_composer_editable_text'),
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
                              backgroundCursorColor: const Color(0xFF000000),
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
                      final hasText =
                          value.text.trim().isNotEmpty && widget.enabled;
                      return AppSemantics.button(
                        label: l10n.aiComposerSendMessage,
                        enabled: hasText,
                        onTap: hasText ? _submit : null,
                        child: GestureDetector(
                          onTap: hasText ? _submit : null,
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: _touchTarget,
                            height: _touchTarget,
                            child: Center(
                              child: Container(
                                width: _sendButtonSize,
                                height: _sendButtonSize,
                                decoration: BoxDecoration(
                                  color: hasText
                                      ? design.colors.textPrimary
                                      : design.colors.textPrimary.withValues(
                                          alpha: 0.3,
                                        ),
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
            ),
          ),
        ),
      ],
    );
  }
}
