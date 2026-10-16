import 'package:flutter/widgets.dart';
import '../core.dart';

class AiComposer extends StatefulWidget {
  const AiComposer({
    super.key,
    this.onSend,
    this.enabled = true,
    this.hintText,
  });

  final ValueChanged<String>? onSend;
  final bool enabled;
  final String? hintText;

  @override
  State<AiComposer> createState() => _AiComposerState();
}

class _AiComposerState extends State<AiComposer> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final ScrollController _textScrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _textScrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _textScrollController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!widget.enabled) return;
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend?.call(text);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final placeholder = widget.hintText ?? l10n.aiComposerPlaceholder;
    final hasText = _controller.text.trim().isNotEmpty && widget.enabled;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: design.colors.border.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 36.0,
                maxHeight: 120.0,
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (_controller.text.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: AppText.body(
                        placeholder,
                        color: design.colors.textTertiary,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: EditableText(
                      controller: _controller,
                      focusNode: _focusNode,
                      scrollController: _textScrollController,
                      readOnly: !widget.enabled,
                      style: design.typography.body.copyWith(
                        color: widget.enabled
                            ? design.colors.textPrimary
                            : design.colors.textTertiary,
                        height: 1.4,
                      ),
                      cursorColor: design.colors.primary,
                      cursorWidth: 2.0,
                      cursorHeight: 18.0,
                      cursorRadius: const Radius.circular(1.0),
                      backgroundCursorColor: const Color(0xFF000000),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: AppSemantics.button(
              label: l10n.aiComposerSendMessage,
              enabled: hasText,
              onTap: hasText ? _submit : null,
              child: GestureDetector(
                onTap: hasText ? _submit : null,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 36.0,
                  height: 36.0,
                  child: Center(
                    child: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: hasText
                            ? design.colors.primary
                            : design.colors.primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          LucideIcons.arrowUp,
                          color: hasText
                              ? design.colors.textInverse
                              : design.colors.primary.withValues(alpha: 0.4),
                          size: 18.0,
                        ),
                      ),
                    ),
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
