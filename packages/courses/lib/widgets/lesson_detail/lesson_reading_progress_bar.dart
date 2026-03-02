import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Progress bar indicator that shows lesson reading progress.
///
/// Typically placed directly below the header to indicate how much of the
/// lesson has been scrolled through.
class LessonReadingProgressBar extends StatelessWidget {
  const LessonReadingProgressBar({
    super.key,
    required this.progress,
    this.foregroundColor,
  });

  /// The reading progress as a fraction between 0.0 and 1.0.
  /// (e.g., 0.35 for 35%)
  final double progress;

  /// Optional foreground color override (e.g., for subject-specific branding).
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final activeColor = foregroundColor ?? design.colors.progressForeground;

    return Container(
      width: double.infinity,
      height: 4,
      color: design.colors.progressBackground,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: activeColor,
                  // Subtle top border to separate from the header divider
                  border: Border(
                    top: BorderSide(
                      color: activeColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
