import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.correctPct,
    required this.incorrectPct,
    required this.unansweredPct,
    required this.correctColor,
    required this.incorrectColor,
    required this.unansweredColor,
    this.strokeWidth,
    this.size,
  });

  final double correctPct;
  final double incorrectPct;
  final double unansweredPct;
  final Color correctColor;
  final Color incorrectColor;
  final Color unansweredColor;
  final double? strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final resolvedSize = size ?? (design.spacing.xxxl + design.spacing.sm); // 72px (64 + 8)
    final resolvedStrokeWidth = strokeWidth ?? design.spacing.sm; // 8px

    return SizedBox(
      width: resolvedSize,
      height: resolvedSize,
      child: CustomPaint(
        painter: _DonutPainter(
          correctPct: correctPct,
          incorrectPct: incorrectPct,
          unansweredPct: unansweredPct,
          correctColor: correctColor,
          incorrectColor: incorrectColor,
          unansweredColor: unansweredColor,
          strokeWidth: resolvedStrokeWidth,
          emptyColor: design.colors.divider,
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.correctPct,
    required this.incorrectPct,
    required this.unansweredPct,
    required this.correctColor,
    required this.incorrectColor,
    required this.unansweredColor,
    required this.strokeWidth,
    required this.emptyColor,
  });

  final double correctPct;
  final double incorrectPct;
  final double unansweredPct;
  final Color correctColor;
  final Color incorrectColor;
  final Color unansweredColor;
  final double strokeWidth;
  final Color emptyColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final total = correctPct + incorrectPct + unansweredPct;
    if (total == 0) {
      // Draw a default ring using theme empty color
      paint.color = emptyColor;
      canvas.drawArc(rect, 0, 2 * math.pi, false, paint);
      return;
    }

    double startAngle = -math.pi / 2; // Start from top center

    void drawSlice(double pct, Color color) {
      if (pct > 0) {
        final sweepAngle = (pct / total) * 2 * math.pi;
        paint.color = color;
        canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
        startAngle += sweepAngle;
      }
    }

    drawSlice(correctPct, correctColor);
    drawSlice(incorrectPct, incorrectColor);
    drawSlice(unansweredPct, unansweredColor);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.correctPct != correctPct ||
        oldDelegate.incorrectPct != incorrectPct ||
        oldDelegate.unansweredPct != unansweredPct ||
        oldDelegate.correctColor != correctColor ||
        oldDelegate.incorrectColor != incorrectColor ||
        oldDelegate.unansweredColor != unansweredColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.emptyColor != emptyColor;
  }
}
