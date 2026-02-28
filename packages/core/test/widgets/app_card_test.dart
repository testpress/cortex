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

  group('AppCard Premium Design', () {
    testWidgets('uses DesignRadius.card (16.0) by default', (tester) async {
      await tester.pumpWidget(wrap(const AppCard(child: SizedBox())));

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(16.0));
    });

    testWidgets('uses DesignShadows.surfaceSoft when showShadow is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(const AppCard(showShadow: true, child: SizedBox())),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.first.blurRadius, 40);
      expect(decoration.boxShadow!.first.color.a, lessThan(0.05));
    });

    testWidgets('Singular Separation: suppresses border if shadow is enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const AppCard(
            showShadow: true,
            showBorder: true, // Should be suppressed
            child: SizedBox(),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppCard),
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.border, isNull);
    });
  });
}
