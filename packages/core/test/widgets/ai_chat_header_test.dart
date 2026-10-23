import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  Widget buildSubject({VoidCallback? onBack, VoidCallback? onMenu}) {
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
          child: AiChatHeader(onBack: onBack, onMenu: onMenu ?? () {}),
        ),
      ),
    );
  }

  testWidgets(
    'spans full viewport width on wide viewport without width bounds',
    (tester) async {
      const viewportWidth = 1200.0;
      tester.view.physicalSize = const Size(viewportWidth, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildSubject(onBack: () {}));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(AiChatHeader));
      final design = Design.of(context);

      final headerFinder = find.byType(AiChatHeader);
      expect(headerFinder, findsOneWidget);
      expect(tester.getSize(headerFinder).width, equals(viewportWidth));

      // Back button aligns near the leading edge
      final backFinder = find.byIcon(LucideIcons.arrowLeft);
      expect(backFinder, findsOneWidget);
      expect(tester.getTopLeft(backFinder).dx, lessThan(design.spacing.md * 2));

      // Menu button aligns near the trailing edge
      final menuFinder = find.byIcon(LucideIcons.menu);
      expect(menuFinder, findsOneWidget);
      expect(
        tester.getTopRight(menuFinder).dx,
        greaterThan(viewportWidth - (design.spacing.md * 2)),
      );
    },
  );
}
