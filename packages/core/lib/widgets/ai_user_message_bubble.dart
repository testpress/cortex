import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

import '../core.dart';

class AiUserMessageBubble extends StatelessWidget {
  /// Share of the chat column a bubble may occupy before wrapping.
  static const double maxWidthFactor = 0.75;

  const AiUserMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    this.attachments = const [],
    this.isSending = false,
    this.hasSendError = false,
    this.onRetry,
  });

  final String message;
  final String timestamp;
  final List<AiAttachmentDto> attachments;
  final bool isSending;
  final bool hasSendError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: EdgeInsets.only(bottom: design.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final maxBubbleWidth = constraints.maxWidth * maxWidthFactor;
                final resolvedMaxWidth = maxBubbleWidth > 560.0
                    ? 560.0
                    : maxBubbleWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (attachments.isNotEmpty) ...[
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: design.spacing.xs,
                        runSpacing: design.spacing.xs,
                        children: [
                          for (final attachment in attachments)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                design.radius.lg,
                              ),
                              child:
                                  attachment.url != null &&
                                      attachment.url!.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: attachment.url!,
                                      width: attachments.length == 1
                                          ? 180.0
                                          : 88.0,
                                      height: attachments.length == 1
                                          ? 135.0
                                          : 88.0,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: attachments.length == 1
                                            ? 180.0
                                            : 88.0,
                                        height: attachments.length == 1
                                            ? 135.0
                                            : 88.0,
                                        color: design.colors.surface,
                                        child: const Center(
                                          child: AppLoadingIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            width: attachments.length == 1
                                                ? 180.0
                                                : 88.0,
                                            height: attachments.length == 1
                                                ? 135.0
                                                : 88.0,
                                            color: design.colors.surface,
                                            child: Center(
                                              child: Icon(
                                                LucideIcons.imageOff,
                                                color:
                                                    design.colors.textSecondary,
                                                size: design.iconSize.sm,
                                              ),
                                            ),
                                          ),
                                    )
                                  : Container(
                                      width: attachments.length == 1
                                          ? 180.0
                                          : 88.0,
                                      height: attachments.length == 1
                                          ? 135.0
                                          : 88.0,
                                      color: design.colors.surface,
                                      child: Center(
                                        child: Icon(
                                          LucideIcons.imageOff,
                                          color: design.colors.textSecondary,
                                          size: design.iconSize.sm,
                                        ),
                                      ),
                                    ),
                            ),
                        ],
                      ),
                      if (message.isNotEmpty)
                        SizedBox(height: design.spacing.xs),
                    ],
                    if (message.isNotEmpty)
                      Container(
                        constraints: BoxConstraints(maxWidth: resolvedMaxWidth),
                        padding: EdgeInsets.symmetric(
                          horizontal: design.spacing.md,
                          vertical: design.spacing.sm * 1.25,
                        ),
                        decoration: BoxDecoration(
                          color: design.colors.surfaceVariant,
                          borderRadius: BorderRadiusDirectional.only(
                            topStart: Radius.circular(design.radius.xl),
                            topEnd: Radius.circular(design.radius.md),
                            bottomStart: Radius.circular(design.radius.xl),
                            bottomEnd: Radius.circular(design.radius.xl),
                          ),
                        ),
                        child: AppText.body(
                          message,
                          color: design.colors.textPrimary,
                        ),
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: design.spacing.xs * 1.5),
            if (!hasSendError)
              AppText.caption(
                isSending ? l10n.aiMessageSending : timestamp,
                color: design.colors.textSecondary,
              ),
            if (hasSendError) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.alertCircle,
                    color: design.colors.error,
                    size: 14.0,
                  ),
                  SizedBox(width: design.spacing.xs / 2),
                  Flexible(
                    child: AppText.caption(
                      l10n.aiMessageSendFailed,
                      color: design.colors.error,
                    ),
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
