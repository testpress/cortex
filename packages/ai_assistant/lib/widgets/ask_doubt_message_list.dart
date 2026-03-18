import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

import '../models/ai_models.dart';
import 'ai_message_bubble.dart';

class AskDoubtMessageList extends StatelessWidget {
  const AskDoubtMessageList({
    super.key,
    required this.scrollController,
    required this.messages,
    required this.isThinking,
    required this.bottomPadding,
  });

  final ScrollController scrollController;
  final List<AIMessage> messages;
  final bool isThinking;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(
        design.spacing.md,
        design.spacing.md,
        design.spacing.md,
        bottomPadding,
      ),
      itemCount: messages.length + (isThinking ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return Padding(
            padding: EdgeInsets.only(bottom: design.spacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoadingIndicator(),
                SizedBox(width: design.spacing.sm),
                AppText.caption(
                  l10n.aiDoubtThinking,
                  color: design.colors.textSecondary,
                ),
              ],
            ),
          );
        }

        final message = messages[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - value)),
                child: child,
              ),
            );
          },
          child: AIMessageBubble(message: message),
        );
      },
    );
  }
}
