import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('Motion Accessibility', () {
    testWidgets('shouldAnimate returns false when animations disabled', (
      tester,
    ) async {
      bool? shouldAnimate;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(shouldAnimate, false);
    });

    testWidgets('shouldAnimate returns true when animations enabled', (
      tester,
    ) async {
      bool? shouldAnimate;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: false),
          child: Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(shouldAnimate, true);
    });

    testWidgets('duration returns zero when animations disabled', (
      tester,
    ) async {
      Duration? resultDuration;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resultDuration = MotionPreferences.duration(
                context,
                const Duration(milliseconds: 250),
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resultDuration, Duration.zero);
    });

    testWidgets('duration returns normal when animations enabled', (
      tester,
    ) async {
      Duration? resultDuration;
      const normalDuration = Duration(milliseconds: 250);

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: false),
          child: Builder(
            builder: (context) {
              resultDuration = MotionPreferences.duration(
                context,
                normalDuration,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resultDuration, normalDuration);
    });

    testWidgets('curve returns linear when animations disabled', (
      tester,
    ) async {
      Curve? resultCurve;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resultCurve = MotionPreferences.curve(context, Curves.easeOut);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resultCurve, Curves.linear);
    });
  });
}
