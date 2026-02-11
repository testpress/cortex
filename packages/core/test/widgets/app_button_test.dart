import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppButton Semantics', () {
    testWidgets('exposes button role to screen readers', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppButton.primary(
            label: 'Submit',
            onPressed: () => tapped = true,
          ),
        ),
      );

      // Find the Semantics widget with button role
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
        const Directionality(
          textDirection: TextDirection.ltr,
          child: AppButton.primary(
            label: 'Submit',
            onPressed: null, // Disabled
          ),
        ),
      );

      // Find the Semantics widget with enabled=false
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
        Directionality(
          textDirection: TextDirection.ltr,
          child: AppButton.secondary(label: 'Cancel', onPressed: () {}),
        ),
      );

      // Verify label is exposed in semantics
      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == 'Cancel',
      );

      expect(semanticsFinder, findsOneWidget);
    });
  });
}
