import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:exams/widgets/test_detail/sections_tab_bar.dart';

void main() {
  Widget buildWidget({
    required List<String> tabNames,
    required int activeIndex,
    required ValueChanged<int> onTabSelected,
    bool isLocked = false,
  }) {
    return WidgetsApp(
      color: const Color(0xFF000000),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, _) => Directionality(
        textDirection: TextDirection.ltr,
        child: DesignProvider(
          config: DesignConfig.light(),
          child: SectionsTabBar(
            tabNames: tabNames,
            activeIndex: activeIndex,
            onTabSelected: onTabSelected,
            isLocked: isLocked,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'SectionsTabBar invokes onTabSelected when unlocked and inactive tab is tapped',
    (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (index) => selectedIndex = index,
          isLocked: false,
        ),
      );
      await tester.pumpAndSettle();

      // Tap inactive tab
      await tester.tap(find.text('Quantitative'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    },
  );

  testWidgets('SectionsTabBar does NOT invoke onTabSelected when locked', (
    WidgetTester tester,
  ) async {
    int? selectedIndex;

    await tester.pumpWidget(
      buildWidget(
        tabNames: ['Reasoning', 'Quantitative'],
        activeIndex: 0,
        onTabSelected: (index) => selectedIndex = index,
        isLocked: true,
      ),
    );
    await tester.pumpAndSettle();

    // Tap inactive tab while locked
    await tester.tap(find.text('Quantitative'));
    await tester.pumpAndSettle();

    // Callback should NOT be invoked
    expect(selectedIndex, isNull);
  });

  testWidgets(
    'SectionsTabBar does NOT invoke onTabSelected when active tab is tapped',
    (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (index) => selectedIndex = index,
          isLocked: false,
        ),
      );
      await tester.pumpAndSettle();

      // Tap active tab
      await tester.tap(find.text('Reasoning'));
      await tester.pumpAndSettle();

      expect(selectedIndex, isNull);
    },
  );

  testWidgets(
    'SectionsTabBar applies textSecondary color to inactive tab when locked',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (_) {},
          isLocked: true,
        ),
      );
      await tester.pumpAndSettle();

      final inactiveTabFinder = find.widgetWithText(AppText, 'Quantitative');
      expect(inactiveTabFinder, findsOneWidget);
      final textWidget = tester.widget<AppText>(inactiveTabFinder);
      expect(textWidget.color, DesignConfig.light().colors.textSecondary);
    },
  );

  testWidgets(
    'SectionsTabBar applies textPrimary color to inactive tab when unlocked',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (_) {},
          isLocked: false,
        ),
      );
      await tester.pumpAndSettle();

      final inactiveTabFinder = find.widgetWithText(AppText, 'Quantitative');
      expect(inactiveTabFinder, findsOneWidget);
      final textWidget = tester.widget<AppText>(inactiveTabFinder);
      expect(textWidget.color, DesignConfig.light().colors.textPrimary);
    },
  );

  testWidgets(
    'SectionsTabBar sets semantics button enabled to false for inactive tab when locked',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (_) {},
          isLocked: true,
        ),
      );
      await tester.pumpAndSettle();

      final semanticsFinder = find.ancestor(
        of: find.text('Quantitative'),
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true,
        ),
      );
      expect(semanticsFinder, findsOneWidget);
      final semanticsWidget = tester.widget<Semantics>(semanticsFinder);
      expect(semanticsWidget.properties.enabled, isFalse);
    },
  );

  testWidgets(
    'SectionsTabBar sets semantics button enabled to true for inactive tab when unlocked',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        buildWidget(
          tabNames: ['Reasoning', 'Quantitative'],
          activeIndex: 0,
          onTabSelected: (_) {},
          isLocked: false,
        ),
      );
      await tester.pumpAndSettle();

      final semanticsFinder = find.ancestor(
        of: find.text('Quantitative'),
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && w.properties.button == true,
        ),
      );
      expect(semanticsFinder, findsOneWidget);
      final semanticsWidget = tester.widget<Semantics>(semanticsFinder);
      expect(semanticsWidget.properties.enabled, isTrue);
    },
  );
}
