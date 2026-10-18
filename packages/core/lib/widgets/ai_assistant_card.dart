import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../core.dart';

class AiAssistantCard extends StatelessWidget {
  /// Share of the chat column a card may occupy before wrapping.
  static const double maxWidthFactor = 0.75;

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
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final tryAgainButton = AppSemantics.button(
      label: l10n.aiTryAgain,
      onTap: onRetry,
      child: GestureDetector(
        onTap: onRetry,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: 1.0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: design.spacing.sm * 1.5,
                vertical: design.spacing.xs * 1.5,
              ),
              decoration: BoxDecoration(
                color: design.colors.surfaceVariant,
                borderRadius: design.radius.pill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.refreshCw,
                    color: design.colors.onSurface,
                    size: 14.0,
                  ),
                  SizedBox(width: design.spacing.xs * 1.5),
                  AppText.labelSmall(
                    l10n.aiTryAgain,
                    color: design.colors.onSurface,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsets.only(bottom: design.spacing.md),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxCardWidth = constraints.maxWidth * maxWidthFactor;
            final resolvedCardWidth = maxCardWidth > 680.0
                ? 680.0
                : maxCardWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: resolvedCardWidth),
                  padding: EdgeInsets.symmetric(
                    horizontal: design.spacing.md,
                    vertical: design.spacing.sm * 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: design.colors.card,
                    // The tightened top-start corner points at the sender side.
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(design.radius.md),
                      topEnd: Radius.circular(design.radius.xl),
                      bottomStart: Radius.circular(design.radius.xl),
                      bottomEnd: Radius.circular(design.radius.xl),
                    ),
                    border: Border.all(color: design.colors.border, width: 1.0),
                  ),
                  child: hasGenerationError
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.caption(
                              l10n.aiAssistantLabel,
                              color: design.colors.textSecondary,
                              style: design.typography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: design.spacing.xs),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: design.spacing.xs / 2,
                                  ),
                                  child: Icon(
                                    LucideIcons.alertCircle,
                                    color: design.colors.error,
                                    size: design.iconSize.sm,
                                  ),
                                ),
                                SizedBox(width: design.spacing.xs * 1.5),
                                Flexible(
                                  child: AppText.bodySmall(
                                    l10n.aiGenerationError,
                                    color: design.colors.error,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      : AppMarkdown(
                          data: message,
                          textStyle: design.typography.body,
                        ),
                ),
                if (hasGenerationError)
                  tryAgainButton
                else if (isGenerating)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: design.spacing.xs,
                      top: design.spacing.xs * 1.5,
                    ),
                    child: AppText.caption(
                      l10n.aiGeneratingResponse,
                      color: design.colors.textSecondary,
                    ),
                  )
                else ...[
                  // The copy glyph sits in a 48dp touch target; pull the
                  // target toward the card edge so the glyph keeps a 12dp inset.
                  Transform.translate(
                    offset: Offset(
                      isRtl ? design.spacing.xs : -design.spacing.xs,
                      0,
                    ),
                    child: AppIconButton(
                      icon: LucideIcons.copy,
                      size: design.iconSize.sm,
                      color: design.colors.onSurfaceVariant,
                      accessibilityLabel: l10n.aiCopyMessageSemantic,
                      onTap:
                          onCopy ??
                          () {
                            Clipboard.setData(ClipboardData(text: message));
                          },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: design.spacing.xs,
                    ),
                    child: AppText.caption(
                      timestamp,
                      color: design.colors.textSecondary,
                    ),
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
