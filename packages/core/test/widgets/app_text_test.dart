import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child, {double textScale = 1.0}) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    );
  }

  group('AppText Scaling', () {
    testWidgets('respects system textScaleFactor', (tester) async {
      const testText = 'Hello World';
      const normalScale = 1.0;
      const largeScale = 2.0;

      // Pump with normal scale
      await tester.pumpWidget(
        wrap(const AppText(testText), textScale: normalScale),
      );

      final normalTextFinder = find.text(testText);
      expect(normalTextFinder, findsOneWidget);

      final normalText = tester.widget<Text>(find.byType(Text));
      final normalSize = normalText.textScaler!.scale(
        normalText.style?.fontSize ??
            DesignConfig.defaults().typography.body.fontSize!,
      );

      // Pump with large scale (elderly user setting)
      await tester.pumpWidget(
        wrap(const AppText(testText), textScale: largeScale),
      );

      final largeText = tester.widget<Text>(find.byType(Text));
      final largeSize = largeText.textScaler!.scale(
        largeText.style?.fontSize ??
            DesignConfig.defaults().typography.body.fontSize!,
      );

      // Verify text size doubled
      expect(largeSize, normalSize * largeScale);
    });

    testWidgets('handles overflow at large scales', (tester) async {
      const longText = 'This is a very long text that should overflow';

      await tester.pumpWidget(
        wrap(
          const SizedBox(
            width: 100,
            child: AppText(
              longText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          textScale: 3.0,
        ),
      );

      // Should not throw overflow error
      expect(tester.takeException(), isNull);
    });
  });
}
