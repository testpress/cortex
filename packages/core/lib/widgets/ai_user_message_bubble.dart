import 'package:flutter/widgets.dart';
import '../core.dart';

class AiUserMessageBubble extends StatelessWidget {
  const AiUserMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    this.isSending = false,
    this.hasSendError = false,
    this.onRetry,
  });

  final String message;
  final String timestamp;
  final bool isSending;
  final bool hasSendError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxBubbleWidth = constraints.maxWidth * 0.8;
                return Container(
                  constraints: BoxConstraints(
                    maxWidth: maxBubbleWidth > 560.0 ? 560.0 : maxBubbleWidth,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm * 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: design.colors.surfaceVariant,
                    borderRadius: design.radius.card,
                  ),
                  child: AppText.body(
                    message,
                    color: design.colors.textPrimary,
                  ),
                );
              },
            ),
            SizedBox(height: design.spacing.xs / 2),
            if (!hasSendError)
              Padding(
                padding: EdgeInsets.only(right: design.spacing.xs),
                child: AppText.caption(
                  isSending ? l10n.aiMessageSending : timestamp,
                  color: isSending
                      ? design.colors.primary
                      : design.colors.textTertiary,
                ),
              ),
            if (hasSendError) ...[
              SizedBox(height: design.spacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    color: design.colors.error,
                    size: 14.0,
                  ),
                  SizedBox(width: design.spacing.xs / 2),
                  AppText.caption(
                    l10n.aiMessageSendFailed,
                    color: design.colors.error,
                  ),
                  AppSemantics.button(
                    label: l10n.aiRetrySendMessageSemantic,
                    onTap: onRetry,
                    child: GestureDetector(
                      onTap: onRetry,
                      behavior: HitTestBehavior.opaque,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 48.0,
                          minHeight: 48.0,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          widthFactor: 1.0,
                          child: AppText.caption(
                            l10n.aiTapToRetry,
                            color: design.colors.error,
                            style: design.typography.caption.copyWith(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
