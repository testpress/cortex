import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget wrap(Widget child) {
    return LocalizationProvider(
      child: Builder(
        builder: (context) {
          final locale = LocalizationProvider.of(context).locale;
          return WidgetsApp(
            color: const Color(0xFF000000),
            locale: locale,
            localizationsDelegates: LocalizationProvider.delegates,
            pageRouteBuilder:
                <T>(RouteSettings settings, WidgetBuilder builder) =>
                    PageRouteBuilder<T>(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          builder(context),
                    ),
            home: DesignProvider(config: DesignConfig.defaults(), child: child),
          );
        },
      ),
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

    testWidgets('supports custom clearSemanticLabel', (tester) async {
      final controller = TextEditingController(text: 'test');

      await tester.pumpWidget(
        wrap(
          AppSearchBar(
            hintText: 'Search...',
            controller: controller,
            clearSemanticLabel: 'Reset query',
          ),
        ),
      );

      final clearSemanticsFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.button == true &&
            widget.properties.label == 'Reset query',
      );

      expect(clearSemanticsFinder, findsOneWidget);
    });

    testWidgets('fires onClear callback when clear button is tapped', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'hello');
      bool onClearCalled = false;

      await tester.pumpWidget(
        wrap(
          AppSearchBar(
            hintText: 'Search...',
            controller: controller,
            onClear: () => onClearCalled = true,
          ),
        ),
      );

      expect(find.byIcon(LucideIcons.x), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();

      expect(onClearCalled, isTrue);
      expect(controller.text, isEmpty);
      expect(find.byIcon(LucideIcons.x), findsNothing);
    });

    testWidgets(
      'works with internal controller when no external controller is passed',
      (tester) async {
        String changedValue = '';
        bool onClearCalled = false;

        await tester.pumpWidget(
          wrap(
            AppSearchBar(
              hintText: 'Search...',
              onChanged: (val) => changedValue = val,
              onClear: () => onClearCalled = true,
            ),
          ),
        );

        expect(find.byIcon(LucideIcons.x), findsNothing);

        await tester.enterText(find.byType(EditableText), 'internal query');
        await tester.pump();

        expect(changedValue, 'internal query');
        expect(find.byIcon(LucideIcons.x), findsOneWidget);

        await tester.tap(find.byIcon(LucideIcons.x));
        await tester.pump();

        expect(onClearCalled, isTrue);
        expect(changedValue, isEmpty);
        expect(find.byIcon(LucideIcons.x), findsNothing);
      },
    );

    testWidgets('supports controller swapping without leaking', (tester) async {
      await tester.pumpWidget(wrap(const AppSearchBar(hintText: 'Search...')));

      final externalController = TextEditingController(text: 'swapped');
      await tester.pumpWidget(
        wrap(
          AppSearchBar(hintText: 'Search...', controller: externalController),
        ),
      );

      expect(find.byIcon(LucideIcons.x), findsOneWidget);

      await tester.pumpWidget(wrap(const AppSearchBar(hintText: 'Search...')));

      expect(find.byIcon(LucideIcons.x), findsNothing);
      externalController.dispose();
    });
  });
}
