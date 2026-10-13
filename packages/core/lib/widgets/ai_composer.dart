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
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.pill,
        border: Border.all(
          color: design.colors.border.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 40.0,
                maxHeight: 120.0,
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (_controller.text.isEmpty)
                    AppText.body(
                      placeholder,
                      color: design.colors.textTertiary,
                    ),
                  EditableText(
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
                    backgroundCursorColor: const Color(0xFF000000),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 1,
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          AppSemantics.button(
            label: l10n.aiComposerSendMessage,
            enabled: hasText,
            onTap: hasText ? _submit : null,
            child: GestureDetector(
              onTap: hasText ? _submit : null,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 48.0,
                height: 48.0,
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
        ],
      ),
    );
  }
}
