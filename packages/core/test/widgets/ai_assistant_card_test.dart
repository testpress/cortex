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
                      isGenerating: true,
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
}
