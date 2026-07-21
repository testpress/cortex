import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child, {bool disableAnimations = false}) {
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

  group('AppTabBar', () {
    final testItems = [
      AppTabItem(id: '1', label: 'Tab 1', icon: const IconData(0)),
      AppTabItem(id: '2', label: 'Tab 2', icon: const IconData(1)),
    ];

    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppTabBar(items: testItems, activeItemId: '1', onTabChange: (_) {}),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets(
      'animations collapse to Duration.zero when disableAnimations is true',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            AppTabBar(items: testItems, activeItemId: '1', onTabChange: (_) {}),
            disableAnimations: true,
          ),
        );

        // Verify that AnimatedOpacity has duration of Duration.zero
        final opacityFinder = find.byType(AnimatedOpacity);
        expect(opacityFinder, findsWidgets);

        final AnimatedOpacity animatedOpacity = tester.widget(
          opacityFinder.first,
        );
        expect(animatedOpacity.duration, Duration.zero);

        // Verify that AnimatedPositioned has duration of Duration.zero
        final positionedFinder = find.byType(AnimatedPositioned);
        expect(positionedFinder, findsOneWidget);

        final AnimatedPositioned animatedPositioned = tester.widget(
          positionedFinder,
        );
        expect(animatedPositioned.duration, Duration.zero);

        // Verify that AnimatedDefaultTextStyle has duration of Duration.zero
        final textStyleFinder = find.byType(AnimatedDefaultTextStyle);
        expect(textStyleFinder, findsWidgets);

        final AnimatedDefaultTextStyle animatedTextStyle = tester.widget(
          textStyleFinder.first,
        );
        expect(animatedTextStyle.duration, Duration.zero);
      },
    );

    testWidgets(
      'animations use normal duration when disableAnimations is false',
      (tester) async {
        await tester.pumpWidget(
          wrap(
            AppTabBar(items: testItems, activeItemId: '1', onTabChange: (_) {}),
            disableAnimations: false,
          ),
        );

        // Get the normal duration from the design context
        final BuildContext context = tester.element(find.byType(AppTabBar));
        final normalDuration = Design.of(context).motion.normal;

        final opacityFinder = find.byType(AnimatedOpacity);
        final AnimatedOpacity animatedOpacity = tester.widget(
          opacityFinder.first,
        );
        expect(animatedOpacity.duration, normalDuration);
      },
    );
  });
}
