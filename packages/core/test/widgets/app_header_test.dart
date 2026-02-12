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

  group('AppHeader Semantics', () {
    testWidgets('title has header semantics', (tester) async {
      await tester.pumpWidget(wrap(const AppHeader(title: 'Course Library')));

      // Find the Semantics widget with header role
      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.header == true &&
            widget.properties.label == 'Course Library',
      );

      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('subtitle is accessible', (tester) async {
      await tester.pumpWidget(
        wrap(const AppHeader(title: 'Courses', subtitle: '6 available')),
      );

      // Verify subtitle text is rendered
      expect(find.text('6 available'), findsOneWidget);
    });

    testWidgets('actions are accessible', (tester) async {
      bool actionTapped = false;

      await tester.pumpWidget(
        wrap(
          AppHeader(
            title: 'Settings',
            actions: [
              GestureDetector(
                onTap: () => actionTapped = true,
                child: const AppText('Done'),
              ),
            ],
          ),
        ),
      );

      // Verify action is rendered
      expect(find.text('Done'), findsOneWidget);

      // Tap action
      await tester.tap(find.text('Done'));
      expect(actionTapped, true);
    });
  });
}
