import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core.dart';

class AiAssistantCard extends StatelessWidget {
  const AiAssistantCard({
    super.key,
    required this.message,
    required this.timestamp,
    this.isGenerating = false,
    this.hasGenerationError = false,
    this.onRetry,
    this.onCopy,
  });

  final String message;
  final String timestamp;

  /// True while the answer is still being streamed. An empty [message] shows
  /// a typing indicator; partial text is rendered as it arrives.
  final bool isGenerating;
  final bool hasGenerationError;
  final VoidCallback? onRetry;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);

    final tryAgainButton = AppSemantics.button(
      label: l10n.aiTryAgain,
      onTap: onRetry,
      child: GestureDetector(
        onTap: onRetry,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.sm,
                vertical: design.spacing.xs / 2,
              ),
              decoration: BoxDecoration(
                color: design.colors.primary.withValues(alpha: 0.12),
                borderRadius: design.radius.card,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.refreshCw,
                    color: design.colors.primary,
                    size: 12.0,
                  ),
                  SizedBox(width: design.spacing.xs / 2),
                  AppText.labelSmall(
                    l10n.aiTryAgain,
                    color: design.colors.primary,
                    style: design.typography.labelSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: design.spacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxCardWidth = constraints.maxWidth * 0.88;
            final resolvedCardWidth = maxCardWidth > 680.0
                ? 680.0
                : maxCardWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: resolvedCardWidth,
                    minHeight: hasGenerationError ? 120.0 : 0.0,
                  ),
                  padding: EdgeInsets.all(design.spacing.md),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    borderRadius: design.radius.card,
                    border: Border.all(
                      color: design.colors.border.withValues(alpha: 0.6),
                      width: 1.0,
                    ),
                  ),
                  child: hasGenerationError
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: AppText.caption(
                            l10n.aiAssistantLabel,
                            color: design.colors.textSecondary,
                            style: design.typography.caption.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : isGenerating && message.isEmpty
                      ? ExcludeSemantics(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: design.spacing.xs,
                            ),
                            child: const _GeneratingIndicator(),
                          ),
                        )
                      : AppMarkdown(data: message),
                ),
                SizedBox(height: design.spacing.xs),
                if (isGenerating && !hasGenerationError) ...[
                  Padding(
                    padding: EdgeInsets.only(left: design.spacing.xs),
                    child: AppText.caption(
                      l10n.aiGeneratingResponse,
                      color: design.colors.textTertiary,
                    ),
                  ),
                ] else if (hasGenerationError) ...[
                  SizedBox(
                    width: resolvedCardWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                                l10n.aiGenerationError,
                                color: design.colors.error,
                                style: design.typography.caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: design.spacing.xs),
                        tryAgainButton,
                      ],
                    ),
                  ),
                ] else ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppIconButton(
                        icon: LucideIcons.copy,
                        size: 18.0,
                        color: design.colors.textSecondary,
                        accessibilityLabel: l10n.aiCopyMessageSemantic,
                        onTap:
                            onCopy ??
                            () {
                              Clipboard.setData(ClipboardData(text: message));
                            },
                      ),
                      SizedBox(width: design.spacing.xs),
                      AppText.caption(
                        timestamp,
                        color: design.colors.textTertiary,
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Three pulsing dots shown while the assistant answer has not produced text.
class _GeneratingIndicator extends StatefulWidget {
  const _GeneratingIndicator();

  @override
  State<_GeneratingIndicator> createState() => _GeneratingIndicatorState();
}

class _GeneratingIndicatorState extends State<_GeneratingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = MotionPreferences.duration(
      context,
      Design.of(context).motion.verySlow,
    );
    if (duration == Duration.zero) {
      _controller.stop();
    } else if (!_controller.isAnimating || _controller.duration != duration) {
      _controller.duration = duration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final animate = MotionPreferences.shouldAnimate(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            // Stagger each dot by a third of the cycle.
            final phase = (_controller.value - index / 3) % 1.0;
            final pulse = animate
                ? (0.35 + 0.65 * (1 - (phase * 2 - 1).abs()))
                : 1.0;
            return Container(
              width: design.spacing.sm,
              height: design.spacing.sm,
              margin: EdgeInsets.symmetric(horizontal: design.spacing.xs / 2),
              decoration: BoxDecoration(
                color: design.colors.textSecondary.withValues(alpha: pulse),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
