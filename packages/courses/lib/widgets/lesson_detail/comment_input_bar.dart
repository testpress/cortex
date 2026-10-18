import 'package:flutter/material.dart'
    show TextField, InputDecoration, InputBorder, Material, MaterialType;
import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';

/// Sticky bottom input bar for writing comments and replies.
class CommentInputBar extends StatefulWidget {
  final CommentDto? replyingTo;
  final ValueChanged<String> onSubmit;
  final VoidCallback onCancelReply;
  final bool isSubmitting;

  const CommentInputBar({
    super.key,
    required this.replyingTo,
    required this.onSubmit,
    required this.onCancelReply,
    this.isSubmitting = false,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_updateCanSubmit);
  }

  @override
  void didUpdateWidget(covariant CommentInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.replyingTo != null &&
        oldWidget.replyingTo?.id != widget.replyingTo?.id) {
      _focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCanSubmit);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateCanSubmit() {
    final text = _controller.text.trim();
    final canSubmit = text.isNotEmpty;
    if (canSubmit != _canSubmit) {
      setState(() => _canSubmit = canSubmit);
    }
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.isSubmitting) return;
    widget.onSubmit(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final targetUser = widget.replyingTo?.user.displayName ??
        widget.replyingTo?.user.username ??
        '';

    return Container(
      decoration: BoxDecoration(
        color: design.colors.surface,
        border: Border(
          top: BorderSide(color: design.colors.divider),
        ),
        boxShadow: design.shadows.floating,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Replying banner
            if (widget.replyingTo != null)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: design.spacing.md,
                  vertical: design.spacing.xs,
                ),
                color: design.colors.surfaceVariant,
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.reply,
                      size: 14,
                      color: design.colors.primary,
                    ),
                    SizedBox(width: design.spacing.xs),
                    Expanded(
                      child: AppText.caption(
                        'Replying to @$targetUser',
                        color: design.colors.textPrimary,
                        maxLines: 1,
                      ),
                    ),
                    AppSemantics.button(
                      label: 'Cancel reply',
                      onTap: widget.onCancelReply,
                      child: AppFocusable(
                        onTap: widget.onCancelReply,
                        borderRadius: design.radius.pill,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.x,
                              size: 16,
                              color: design.colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Input Row
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.md,
                vertical: design.spacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: design.colors.card,
                        borderRadius: BorderRadius.circular(design.radius.lg),
                        border: Border.all(color: design.colors.border),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: design.spacing.md,
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: TextField(
                          focusNode: _focusNode,
                          controller: _controller,
                          maxLines: 4,
                          minLines: 1,
                          style: design.typography.body.copyWith(
                            color: design.colors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.replyingTo != null
                                ? 'Write your reply...'
                                : 'Add a comment...',
                            hintStyle: design.typography.body.copyWith(
                              color: design.colors.textTertiary,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: design.spacing.sm,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: design.spacing.sm),
                  AppSemantics.button(
                    label: 'Send comment',
                    enabled: _canSubmit && !widget.isSubmitting,
                    onTap: _canSubmit && !widget.isSubmitting
                        ? _handleSubmit
                        : null,
                    child: AppFocusable(
                      onTap: _canSubmit && !widget.isSubmitting
                          ? _handleSubmit
                          : null,
                      borderRadius: design.radius.pill,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 48,
                          minHeight: 48,
                        ),
                        child: Center(
                          child: widget.isSubmitting
                              ? SizedBox(
                                  width: design.iconSize.sm,
                                  height: design.iconSize.sm,
                                  child: AppLoadingIndicator(
                                    size: design.iconSize.sm,
                                  ),
                                )
                              : Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _canSubmit
                                        ? design.colors.primary
                                        : design.colors.surfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      LucideIcons.send,
                                      size: 18,
                                      color: _canSubmit
                                          ? design.colors.onPrimary
                                          : design.colors.textTertiary,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
