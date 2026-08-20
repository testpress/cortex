import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/screens/onboarding_screen.dart';

void main() {
  final dummySettings = InstituteSettings.fromJson(const {});

  GoRouter buildTestRouter() {
    return GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              const Scaffold(body: Text('Login Screen')),
        ),
      ],
    );
  }

  Widget createTestWidget({required ProviderContainer container}) {
    final router = buildTestRouter();
    return UncontrolledProviderScope(
      container: container,
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  testWidgets(
    'Navigates to /login when settings transition from null to populated',
    (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [instituteSettingsProvider.overrideWith((ref) => null)],
      );

      await tester.pumpWidget(createTestWidget(container: container));
      expect(find.text('Login Screen'), findsNothing);

      container.read(instituteSettingsProvider.notifier).state = dummySettings;
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    },
  );

  testWidgets(
    'Navigates to /login immediately if settings are already loaded before pump',
    (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          instituteSettingsProvider.overrideWith((ref) => dummySettings),
        ],
      );

      await tester.pumpWidget(createTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(find.text('Login Screen'), findsOneWidget);
    },
  );
}
