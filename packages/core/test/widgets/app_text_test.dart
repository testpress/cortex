import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppText Scaling', () {
    testWidgets('respects system textScaleFactor', (tester) async {
      const testText = 'Hello World';
      const normalScale = 1.0;
      const largeScale = 2.0;

      // Pump with normal scale
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaleFactor: normalScale),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AppText(testText),
          ),
        ),
      );

      final normalTextFinder = find.text(testText);
      expect(normalTextFinder, findsOneWidget);

      final normalText = tester.widget<Text>(find.byType(Text));
      final normalSize = normalText.textScaler!.scale(
        normalText.style?.fontSize ?? AppTypography.body.fontSize!,
      );

      // Pump with large scale (elderly user setting)
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaleFactor: largeScale),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AppText(testText),
          ),
        ),
      );

      final largeText = tester.widget<Text>(find.byType(Text));
      final largeSize = largeText.textScaler!.scale(
        largeText.style?.fontSize ?? AppTypography.body.fontSize!,
      );

      // Verify text size doubled
      expect(largeSize, normalSize * largeScale);
    });

    testWidgets('handles overflow at large scales', (tester) async {
      const longText = 'This is a very long text that should overflow';

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaleFactor: 3.0),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox(
              width: 100,
              child: AppText(
                longText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      );

      // Should not throw overflow error
      expect(tester.takeException(), isNull);
    });
  });
}
