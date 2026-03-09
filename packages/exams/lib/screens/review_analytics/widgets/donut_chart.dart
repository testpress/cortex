import 'dart:math' as math;

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    this.size = 160,
    this.strokeWidth = 16,
  });

  final int correct;
  final int incorrect;
  final int unanswered;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DonutChartPainter(
          correct: correct,
          incorrect: incorrect,
          unanswered: unanswered,
          strokeWidth: strokeWidth,
          correctColor: design.colors.accent4,
          incorrectColor: design.colors.accent5,
          unansweredColor: design.colors.accent3,
          trackColor: design.colors.border.withValues(alpha: 0.32),
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  _DonutChartPainter({
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.strokeWidth,
    required this.correctColor,
    required this.incorrectColor,
    required this.unansweredColor,
    required this.trackColor,
  });

  final int correct;
  final int incorrect;
  final int unanswered;
  final double strokeWidth;
  final Color correctColor;
  final Color incorrectColor;
  final Color unansweredColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - (strokeWidth / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    canvas.drawArc(rect, 0, 2 * math.pi, false, trackPaint);

    final total = correct + incorrect + unanswered;
    if (total <= 0) {
      return;
    }

    final segments = [
      _Segment(value: correct, color: correctColor),
      _Segment(value: incorrect, color: incorrectColor),
      _Segment(value: unanswered, color: unansweredColor),
    ];

    var startAngle = -math.pi / 2;
    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweep = (segment.value / total) * (2 * math.pi);
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.correct != correct ||
        oldDelegate.incorrect != incorrect ||
        oldDelegate.unanswered != unanswered ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.correctColor != correctColor ||
        oldDelegate.incorrectColor != incorrectColor ||
        oldDelegate.unansweredColor != unansweredColor ||
        oldDelegate.trackColor != trackColor;
  }
}

class _Segment {
  const _Segment({required this.value, required this.color});

  final int value;
  final Color color;
}
