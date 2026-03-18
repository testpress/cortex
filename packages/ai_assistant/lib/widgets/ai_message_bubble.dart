import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import '../models/ai_models.dart';

class AIMessageBubble extends StatelessWidget {
  final AIMessage message;

  const AIMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final isUser = message.role == AIMessageRole.user;
    final userBubbleColor = design.isDark
        ? design.colors.surfaceVariant
        : design.colors.surfaceVariant;
    final imageWidth = math.min(
      MediaQuery.of(context).size.width * 0.64,
      design.layout.maxDrawerWidth,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: design.spacing.md),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (message.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: design.radius.card,
                        child: Image.network(
                          message.imageUrl!,
                          width: imageWidth,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: design.spacing.xs),
                    ],
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      child: isUser
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: design.spacing.md,
                                vertical: design.spacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: userBubbleColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(design.radius.lg),
                                  topRight: Radius.circular(design.radius.lg),
                                  bottomLeft: Radius.circular(design.radius.lg),
                                  bottomRight: Radius.circular(
                                    design.radius.sm,
                                  ),
                                ),
                              ),
                              child: AppText.body(
                                message.content,
                                color: design.colors.textPrimary,
                              ),
                            )
                          : AppText.body(
                              message.content,
                              color: design.colors.textPrimary,
                            ),
                    ),
                    _buildActions(context, design, isUser),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, DesignConfig design, bool isUser) {
    return Padding(
      padding: EdgeInsets.only(
        top: design.spacing.sm,
        left: isUser ? 0 : design.spacing.sm,
        right: isUser ? design.spacing.sm : 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MessageAction(
            icon: LucideIcons.copy,
            design: design,
            isUser: isUser,
          ),
          if (isUser) ...[
            _MessageAction(
              icon: LucideIcons.pencil,
              design: design,
              isUser: isUser,
            ),
          ] else ...[
            _MessageAction(
              icon: LucideIcons.thumbsUp,
              design: design,
              isUser: isUser,
            ),
            _MessageAction(
              icon: LucideIcons.thumbsDown,
              design: design,
              isUser: isUser,
            ),
            _MessageAction(
              icon: LucideIcons.volume2,
              design: design,
              isUser: isUser,
            ),
            _MessageAction(
              icon: LucideIcons.share2,
              design: design,
              isUser: isUser,
            ),
            _MessageAction(
              icon: LucideIcons.moreHorizontal,
              design: design,
              isUser: isUser,
            ),
          ],
        ],
      ),
    );
  }
}

class _MessageAction extends StatelessWidget {
  final IconData icon;
  final DesignConfig design;
  final bool isUser;

  const _MessageAction({
    required this.icon,
    required this.design,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: isUser ? 0 : design.spacing.md,
        left: isUser ? design.spacing.md : 0,
      ),
      child: GestureDetector(
        onTap: () {}, // No functionality for now
        child: Icon(
          icon,
          size: design.iconSize.sm,
          color: design.colors.textSecondary,
        ),
      ),
    );
  }
}
