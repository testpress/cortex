import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child, {required bool disableAnimations}) {
    return MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Builder(
        builder: (context) {
          return DesignProvider(
            config: DesignConfig.defaults(context: context),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: child,
            ),
          );
        },
      ),
    );
  }

  group('Motion Accessibility', () {
    testWidgets('shouldAnimate returns false when animations disabled', (
      tester,
    ) async {
      bool? shouldAnimate;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              return const SizedBox();
            },
          ),
          disableAnimations: true,
        ),
      );

      expect(shouldAnimate, false);
    });

    testWidgets('shouldAnimate returns true when animations enabled', (
      tester,
    ) async {
      bool? shouldAnimate;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              shouldAnimate = MotionPreferences.shouldAnimate(context);
              return const SizedBox();
            },
          ),
          disableAnimations: false,
        ),
      );

      expect(shouldAnimate, true);
    });

    testWidgets('duration returns zero when animations disabled', (
      tester,
    ) async {
      Duration? resultDuration;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              resultDuration = MotionPreferences.duration(
                context,
                const Duration(milliseconds: 250),
              );
              return const SizedBox();
            },
          ),
          disableAnimations: true,
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
        wrap(
          Builder(
            builder: (context) {
              resultDuration = MotionPreferences.duration(
                context,
                normalDuration,
              );
              return const SizedBox();
            },
          ),
          disableAnimations: false,
        ),
      );

      expect(resultDuration, normalDuration);
    });

    testWidgets('curve returns linear when animations disabled', (
      tester,
    ) async {
      Curve? resultCurve;

      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              resultCurve = MotionPreferences.curve(context, Curves.easeOut);
              return const SizedBox();
            },
          ),
          disableAnimations: true,
        ),
      );

      expect(resultCurve, Curves.linear);
    });
  });
}
