import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('generating status is announced once and motion updates live', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var reducedMotion = false;
    late StateSetter update;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return MediaQuery(
            data: MediaQueryData(disableAnimations: reducedMotion),
            child: Builder(
              builder: (context) => DesignProvider(
                config: DesignConfig.defaults(context: context),
                child: WidgetsApp(
                  color: const Color(0xFF000000),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  locale: const Locale('en'),
                  home: const Center(
                    child: AiAssistantCard(
                      message: '',
                      timestamp: '',
                      status: AiAssistantStatus.generating,
                    ),
                  ),
                  pageRouteBuilder: <T>(settings, builder) =>
                      PageRouteBuilder<T>(
                        settings: settings,
                        pageBuilder: (context, _, _) => builder(context),
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Generating response...'), findsOneWidget);
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    update(() => reducedMotion = true);
    await tester.pump();
    await tester.pump();
    expect(tester.binding.transientCallbackCount, 0);
    update(() => reducedMotion = false);
    await tester.pump();
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(const SizedBox.shrink());
    semantics.dispose();
  });

  testWidgets(
    'renders stopped response with partial message and subtle label',
    (tester) async {
      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.defaults(context: null),
          child: WidgetsApp(
            color: const Color(0xFF000000),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const Center(
              child: AiAssistantCard(
                message: 'Partial retained answer',
                timestamp: '10:30 AM',
                status: AiAssistantStatus.stopped,
              ),
            ),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Partial retained answer'), findsOneWidget);
      expect(find.text('Stopped'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
      expect(
        find.text("Couldn't generate a response. Please try again."),
        findsNothing,
      );
    },
  );

  testWidgets(
    'renders stopped response when using explicit AiAssistantStatus.stopped',
    (tester) async {
      await tester.pumpWidget(
        DesignProvider(
          config: DesignConfig.defaults(context: null),
          child: WidgetsApp(
            color: const Color(0xFF000000),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: const Center(
              child: AiAssistantCard(
                message: 'Enum stopped response',
                timestamp: '11:00 AM',
                status: AiAssistantStatus.stopped,
              ),
            ),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Enum stopped response'), findsOneWidget);
      expect(find.text('Stopped'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    },
  );
}
