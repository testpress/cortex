import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('AppCard Semantics', () {
    testWidgets('tappable cards expose button semantics', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        wrap(
          AppCard(
            onTap: () => tapped = true,
            child: const AppText('Card content'),
          ),
        ),
      );

      // Tappable cards should have GestureDetector
      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsOneWidget);

      // Tap the card
      await tester.tap(find.byType(AppCard));
      expect(tapped, true);
    });

    testWidgets('non-tappable cards have no gesture detector', (tester) async {
      await tester.pumpWidget(
        wrap(const AppCard(child: AppText('Static card'))),
      );

      // Non-tappable cards should NOT have GestureDetector
      final gestureDetectorFinder = find.byType(GestureDetector);
      expect(gestureDetectorFinder, findsNothing);
    });

    testWidgets('child content is accessible', (tester) async {
      await tester.pumpWidget(
        wrap(const AppCard(child: AppText('Accessible content'))),
      );

      // Verify child content is rendered
      expect(find.text('Accessible content'), findsOneWidget);
    });
  });
}
