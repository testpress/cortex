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

  group('AppButton Semantics', () {
    testWidgets('exposes button role to screen readers', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.primary(label: 'Submit', onPressed: () {})),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Submit',
      );

      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('announces disabled state', (tester) async {
      await tester.pumpWidget(
        wrap(const AppButton.primary(label: 'Submit', onPressed: null)),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.enabled == false,
      );

      expect(semanticsFinder, findsOneWidget);
    });

    testWidgets('label is accessible to screen readers', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.secondary(label: 'Cancel', onPressed: () {})),
      );

      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Cancel',
      );

      expect(semanticsFinder, findsOneWidget);
    });
  });

  group('AppButton Touch Targets', () {
    testWidgets('meets 48dp minimum height requirement', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.primary(label: 'OK', onPressed: () {})),
      );

      final constrainedBoxFinder = find.descendant(
        of: find.byType(AppButton),
        matching: find.byType(ConstrainedBox),
      );
      expect(constrainedBoxFinder, findsOneWidget);

      final constrainedBox = tester.widget<ConstrainedBox>(
        constrainedBoxFinder,
      );
      expect(constrainedBox.constraints.minHeight, 48.0);
    });

    testWidgets('maintains minimum height with short labels', (tester) async {
      await tester.pumpWidget(
        wrap(AppButton.secondary(label: 'X', onPressed: () {})),
      );

      final buttonBox = tester.getRect(find.byType(AppButton));
      expect(buttonBox.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('maintains minimum height with long labels', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppButton.primary(
            label: 'This is a very long button label',
            onPressed: () {},
          ),
        ),
      );

      final buttonBox = tester.getRect(find.byType(AppButton));
      expect(buttonBox.height, greaterThanOrEqualTo(48.0));
    });
  });
}
