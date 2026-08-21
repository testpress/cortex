import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core.dart';

class AiComposer extends ConsumerStatefulWidget {
  const AiComposer({super.key, this.onSend});

  final ValueChanged<String>? onSend;

  @override
  ConsumerState<AiComposer> createState() => _AiComposerState();
}

class _AiComposerState extends ConsumerState<AiComposer> {
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

    return Container(
      decoration: BoxDecoration(
        color: design.colors.card,
        borderRadius: design.radius.card,
        border: Border.all(color: design.colors.border),
      ),
      padding: EdgeInsets.only(
        left: design.spacing.sm,
        right: design.spacing.sm,
        top: design.spacing.sm,
        bottom: design.spacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: design.spacing.xs),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 100.0),
              child: RawScrollbar(
                controller: _textScrollController,
                thumbColor: design.colors.textTertiary.withValues(alpha: 0.5),
                thickness: 4.0,
                radius: const Radius.circular(2.0),
                thumbVisibility: true,
                child: Stack(
                  children: [
                    if (_controller.text.isEmpty)
                      AppText.body(
                        l10n.aiComposerPlaceholder,
                        color: design.colors.textTertiary,
                      ),
                    EditableText(
                      controller: _controller,
                      focusNode: _focusNode,
                      scrollController: _textScrollController,
                      style: design.typography.body.copyWith(
                        color: design.colors.textPrimary,
                      ),
                      cursorColor: design.colors.primary,
                      backgroundCursorColor: const Color(0xFF000000),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: design.spacing.xs / 2),
          Row(
            children: [
              AppIconButton(
                icon: LucideIcons.image,
                onTap: () {},
                accessibilityLabel: l10n.aiComposerAttachImage,
                color: design.colors.textSecondary,
                size: 20,
              ),
              AppIconButton(
                icon: LucideIcons.camera,
                onTap: () {},
                accessibilityLabel: l10n.aiComposerTakePhoto,
                color: design.colors.textSecondary,
                size: 20,
              ),
              const Spacer(),
              AppSemantics.button(
                label: l10n.aiComposerSendMessage,
                onTap: _submit,
                child: GestureDetector(
                  onTap: _submit,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(
                      child: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: design.colors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            LucideIcons.send,
                            color: design.colors.textInverse,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
