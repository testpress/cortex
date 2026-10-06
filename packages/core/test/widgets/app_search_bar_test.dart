import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    );
  }

  group('AppSearchBar Clear Button', () {
    testWidgets('does not show clear button when search text is empty', (
      tester,
    ) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        wrap(AppSearchBar(hintText: 'Search...', controller: controller)),
      );

      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets('shows clear button when text is entered and clears on tap', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'flutter');
      String changedValue = 'flutter';

      await tester.pumpWidget(
        wrap(
          AppSearchBar(
            hintText: 'Search...',
            controller: controller,
            onChanged: (val) => changedValue = val,
          ),
        ),
      );

      expect(find.byIcon(LucideIcons.x), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();

      expect(controller.text, isEmpty);
      expect(changedValue, isEmpty);
      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets('has accessible clear button semantics', (tester) async {
      final controller = TextEditingController(text: 'test');

      await tester.pumpWidget(
        wrap(AppSearchBar(hintText: 'Search...', controller: controller)),
      );

      final clearSemanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Clear search',
      );

      expect(clearSemanticsFinder, findsOneWidget);
    });
  });
}
