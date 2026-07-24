import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import '../../utils/watermark_params.dart';

class WatermarkOverlay extends StatelessWidget {
  static const _kWatermarkAlignmentX = -0.1;

  final String text;
  final Color color;

  const WatermarkOverlay({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Positioned.fill(
      child: ExcludeSemantics(
        child: IgnorePointer(
          child: Align(
            alignment: const Alignment(_kWatermarkAlignmentX, 0),
            child: Transform.rotate(
              angle: WatermarkParams.angleDeg * math.pi / 180,
              child: AppText(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: WatermarkParams.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
