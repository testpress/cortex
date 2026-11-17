import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject({
    VoidCallback? onBack,
    VoidCallback? onMenu,
    String? title,
    VoidCallback? onNewChat,
    VoidCallback? onDelete,
  }) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: WidgetsApp(
        color: const Color(0xFF000000),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: Align(
          alignment: Alignment.topCenter,
          child: AiChatHeader(
            onBack: onBack,
            onMenu: onMenu ?? () {},
            title: title,
            onNewChat: onNewChat,
            onDelete: onDelete,
          ),
        ),
      ),
    );
  }

  testWidgets(
    'spans full viewport width with menu on leading edge and actions on trailing edge',
    (tester) async {
      const viewportWidth = 1200.0;
      tester.view.physicalSize = const Size(viewportWidth, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        buildSubject(
          title: 'Understanding Galaxies',
          onNewChat: () {},
          onDelete: () {},
        ),
      );
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AiChatHeader));
      final design = Design.of(context);

      final headerFinder = find.byType(AiChatHeader);
      expect(headerFinder, findsOneWidget);
      expect(tester.getSize(headerFinder).width, equals(viewportWidth));

      // Menu button aligns near the leading edge
      final menuFinder = find.byIcon(LucideIcons.menu);
      expect(menuFinder, findsOneWidget);
      expect(tester.getTopLeft(menuFinder).dx, lessThan(design.spacing.md * 2));

      // Title renders next to menu
      expect(find.text('Understanding Galaxies'), findsOneWidget);

      // Trailing action buttons align near the trailing edge
      final newChatFinder = find.byIcon(LucideIcons.squarePen);
      expect(newChatFinder, findsOneWidget);

      final moreFinder = find.byIcon(LucideIcons.moreVertical);
      expect(moreFinder, findsOneWidget);
      expect(
        tester.getTopRight(moreFinder).dx,
        greaterThan(viewportWidth - (design.spacing.md * 6)),
      );
    },
  );

  testWidgets('triggers onMenu and onNewChat callbacks when tapped', (
    tester,
  ) async {
    var menuTapped = false;
    var newChatTapped = false;

    await tester.pumpWidget(
      buildSubject(
        onMenu: () => menuTapped = true,
        onNewChat: () => newChatTapped = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();
    expect(menuTapped, isTrue);

    await tester.tap(find.byIcon(LucideIcons.squarePen));
    await tester.pumpAndSettle();
    expect(newChatTapped, isTrue);
  });

  testWidgets('falls back to default title when title is null or empty', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(title: '   '));
    await tester.pumpAndSettle();

    expect(find.text('AI Chat'), findsOneWidget);
  });

  testWidgets('opens anchored overflow popup and triggers onDelete callback', (
    tester,
  ) async {
    var deleteTapped = false;

    await tester.pumpWidget(
      buildSubject(title: 'Active Chat', onDelete: () => deleteTapped = true),
    );
    await tester.pumpAndSettle();

    final moreFinder = find.byIcon(LucideIcons.moreVertical);
    expect(moreFinder, findsOneWidget);

    await tester.tap(moreFinder);
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.trash2), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(deleteTapped, isTrue);
    expect(find.text('Delete'), findsNothing);
  });

  testWidgets(
    'guarantees 48x48dp minimum touch targets for all action buttons',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          title: 'Title',
          onMenu: () {},
          onNewChat: () {},
          onDelete: () {},
        ),
      );
      await tester.pumpAndSettle();

      final iconButtons = find.byType(AppIconButton);
      expect(iconButtons, findsNWidgets(3));

      for (var i = 0; i < 3; i++) {
        final size = tester.getSize(iconButtons.at(i));
        expect(size.width, greaterThanOrEqualTo(48.0));
        expect(size.height, greaterThanOrEqualTo(48.0));
      }
    },
  );
}
