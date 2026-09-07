import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

/// Circular progress gauge used on the QOTD overview card.
class QotdCompletionGauge extends StatelessWidget {
  final int percentage;

  const QotdCompletionGauge({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    return AppSemantics.progressValue(
      value: (percentage / 100).clamp(0.0, 1.0),
      label: l10n.qotdProgressLabel,
      child: SizedBox(
        width: 92,
        height: 92,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(92, 92),
              painter: _GaugePainter(
                percentage: percentage,
                progressColor: design.colors.success,
                trackColor: design.colors.success.withValues(alpha: 0.12),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.headline(
                  '$percentage%',
                  color: design.colors.textPrimary,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                AppText.labelSmall(
                  l10n.qotdProgressLabel,
                  color: design.colors.textSecondary,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 9.0,
                    letterSpacing: 0.3,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int percentage;
  final Color progressColor;
  final Color trackColor;

  _GaugePainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    const strokeWidth = 7.0;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = 0.75 * math.pi;
    const sweepAngleTotal = 1.5 * math.pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngleTotal,
      false,
      trackPaint,
    );

    final sweepAngleProgress =
        sweepAngleTotal * (percentage / 100).clamp(0.0, 1.0);
    if (sweepAngleProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngleProgress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor;
  }
}
