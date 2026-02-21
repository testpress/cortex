import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('Dark Mode Support', () {
    testWidgets('Automatic switching based on platform brightness', (
      tester,
    ) async {
      final lightConfig = DesignConfig.light();
      final darkConfig = DesignConfig.dark();

      late DesignConfig capturedConfig;

      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF000000),
          onGenerateRoute: (settings) => PageRouteBuilder(
            pageBuilder: (context, _, _) => DesignProvider(
              config: lightConfig,
              darkConfig: darkConfig,
              mode: DesignMode.system,
              child: Builder(
                builder: (context) {
                  capturedConfig = Design.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );

      // Default is light
      expect(capturedConfig.colors.surface, const Color(0xFFF9FAFB));

      // Simulate dark mode
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      await tester.pumpAndSettle();

      // Should now be dark
      capturedConfig = Design.of(tester.element(find.byType(SizedBox)));
      expect(capturedConfig.colors.surface, const Color(0xFF0F172A));
    });

    testWidgets('Manual override forces theme', (tester) async {
      final lightConfig = DesignConfig.light();
      final darkConfig = DesignConfig.dark();

      late DesignConfig capturedConfig;

      await tester.pumpWidget(
        DesignProvider(
          config: lightConfig,
          darkConfig: darkConfig,
          mode: DesignMode.dark, // Force dark
          child: Builder(
            builder: (context) {
              capturedConfig = Design.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      // Even if platform is light, it should be dark
      expect(capturedConfig.colors.surface, const Color(0xFF0F172A));
    });
  });
}
