import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('Motion Accessibility with Design Context', () {
    testWidgets('MotionPreferences reflects Design context override', (
      tester,
    ) async {
      final noAnimationConfig = DesignConfig(
        colors: DesignColors.light(),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: const DesignMotion(
          shouldAnimate: false, // Override to disable animations
          fast: Duration(milliseconds: 150),
          normal: Duration(milliseconds: 250),
          slow: Duration(milliseconds: 400),
          verySlow: Duration(milliseconds: 600),
          easeIn: Curves.easeIn,
          easeOut: Curves.easeOut,
          easeInOut: Curves.easeInOut,
          emphasized: Curves.easeInOutCubic,
          spring: Curves.easeOutCubic,
        ),
        radius: DesignRadius.defaults(),
        subjectPalette: DesignSubjectPalette.light(),
        statusColors: DesignStatusColors.light(),
      );

      bool? shouldAnimate;
      Duration? duration;

      await tester.pumpWidget(
        DesignProvider(
          config: noAnimationConfig,
          child: Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              duration = MotionPreferences.duration(
                context,
                const Duration(milliseconds: 300),
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(shouldAnimate, false);
      expect(duration, Duration.zero);
    });

    testWidgets('MotionPreferences respects enabled animations', (
      tester,
    ) async {
      final animationConfig = DesignConfig(
        colors: DesignColors.light(),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: const DesignMotion(
          shouldAnimate: true, // Animations enabled
          fast: Duration(milliseconds: 150),
          normal: Duration(milliseconds: 250),
          slow: Duration(milliseconds: 400),
          verySlow: Duration(milliseconds: 600),
          easeIn: Curves.easeIn,
          easeOut: Curves.easeOut,
          easeInOut: Curves.easeInOut,
          emphasized: Curves.easeInOutCubic,
          spring: Curves.easeOutCubic,
        ),
        radius: DesignRadius.defaults(),
        subjectPalette: DesignSubjectPalette.light(),
        statusColors: DesignStatusColors.light(),
      );

      bool? shouldAnimate;
      Duration? duration;
      Curve? curve;

      await tester.pumpWidget(
        DesignProvider(
          config: animationConfig,
          child: Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              duration = MotionPreferences.duration(
                context,
                const Duration(milliseconds: 300),
              );
              curve = MotionPreferences.curve(context, Curves.easeOut);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(shouldAnimate, true);
      expect(duration, const Duration(milliseconds: 300));
      expect(curve, Curves.easeOut);
    });
  });
}
