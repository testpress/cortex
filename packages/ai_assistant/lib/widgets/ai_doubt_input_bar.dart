import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:core/core.dart';

class AIDoubtInputBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  final bool leftSafeArea;
  final bool rightSafeArea;

  const AIDoubtInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttach,
    this.leftSafeArea = true,
    this.rightSafeArea = true,
  });

  @override
  State<AIDoubtInputBar> createState() => _AIDoubtInputBarState();
}

class _AIDoubtInputBarState extends State<AIDoubtInputBar> {
  bool _hasText = false;
  final GlobalKey<EditableTextState> _editableTextKey =
      GlobalKey<EditableTextState>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final keyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;
    final screenSize = MediaQuery.sizeOf(context);
    final isLandscape = screenSize.width > screenSize.height;

    return Container(
      padding: EdgeInsets.only(
        left: design.spacing.sm,
        right: design.spacing.sm,
        top: 0,
        bottom: keyboardVisible
            ? (isLandscape ? design.spacing.xs : 0)
            : design.spacing.sm,
      ),
      decoration: BoxDecoration(
        color: design.colors.overlay.withValues(alpha: 0),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        left: widget.leftSafeArea,
        right: widget.rightSafeArea,
        child: Container(
          padding: EdgeInsets.all(design.spacing.xs),
          decoration: BoxDecoration(
            color: design.colors.card,
            borderRadius: design.radius.pill,
            border: Border.all(
              color: design.colors.border.withValues(alpha: 0.8),
            ),
            boxShadow: design.shadows.floating,
          ),
          child: Row(
            children: [
              // Attachment Button
              GestureDetector(
                onTap: widget.onAttach,
                child: AppSemantics.button(
                  label: l10n.aiDoubtAttachAction,
                  child: Container(
                    padding: EdgeInsets.all(design.spacing.sm),
                    decoration: BoxDecoration(
                      color: design.colors.surfaceVariant.withValues(
                        alpha: 0.5,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.plus,
                      color: design.colors.textPrimary,
                      size: design.iconSize.action,
                    ),
                  ),
                ),
              ),
              SizedBox(width: design.spacing.sm),

              // TextField (Neutral replacement)
              Expanded(
                child: Listener(
                  behavior: HitTestBehavior.translucent,
                  onPointerDown: (_) => _showKeyboard(),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      if (!_hasText)
                        AppText.body(
                          l10n.aiDoubtPlaceholder,
                          color: design.colors.textTertiary,
                        ),
                      EditableText(
                        key: _editableTextKey,
                        controller: widget.controller,
                        focusNode: _focusNode,
                        cursorColor: design.colors.primary,
                        backgroundCursorColor: design.colors.textSecondary,
                        style: design.typography.body.copyWith(
                          color: design.colors.textPrimary,
                          height: 1.2,
                        ),
                        maxLines: 4,
                        minLines: 1,
                        onSubmitted: (_) => widget.onSend(),
                      ),
                    ],
                  ),
                ),
              ),

              // Voice Button (Placeholder)
              AppSemantics.button(
                label: l10n.aiDoubtVoiceAction,
                child: Padding(
                  padding: EdgeInsets.all(design.spacing.sm),
                  child: Icon(
                    LucideIcons.mic,
                    color: design.colors.textTertiary,
                    size: design.iconSize.action,
                  ),
                ),
              ),

              // Send Button
              GestureDetector(
                onTap: widget.onSend,
                child: AppSemantics.button(
                  label: l10n.aiDoubtSendAction,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(design.spacing.sm),
                    decoration: BoxDecoration(
                      color: _hasText
                          ? design.colors.textPrimary
                          : design.colors.textTertiary.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.arrowUp,
                      color: _hasText
                          ? design.colors.textInverse
                          : design.colors.textPrimary.withValues(alpha: 0.4),
                      size: design.iconSize.action,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKeyboard() {
    final editableTextState = _editableTextKey.currentState;
    if (editableTextState != null) {
      editableTextState.requestKeyboard();
      return;
    }

    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
      return;
    }

    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }
}
