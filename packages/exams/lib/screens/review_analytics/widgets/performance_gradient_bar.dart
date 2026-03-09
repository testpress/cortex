import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

class PerformanceGradientBar extends StatelessWidget {
  const PerformanceGradientBar({super.key, required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);
    final clamped = percentage.clamp(0, 100).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 16,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final markerX = constraints.maxWidth * (clamped / 100);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 2,
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(design.radius.full),
                        gradient: LinearGradient(
                          colors: [
                            design.colors.error,
                            design.colors.warning,
                            design.colors.rank1,
                            design.colors.success,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: markerX - 2,
                    top: 0,
                    child: Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: design.colors.textPrimary,
                        borderRadius: BorderRadius.circular(design.radius.full),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: design.spacing.xs),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.caption('Bad', color: design.colors.textSecondary),
            AppText.caption('Average', color: design.colors.textSecondary),
            AppText.caption('Good', color: design.colors.textSecondary),
            AppText.caption('Excellent', color: design.colors.textSecondary),
          ],
        ),
      ],
    );
  }
}
