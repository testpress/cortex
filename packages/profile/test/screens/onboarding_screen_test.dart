import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/screens/onboarding_screen.dart';

void main() {
  Widget createTestWidget() {
    return ProviderScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );
  }

  testWidgets('Renders correctly as a stateless view', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(createTestWidget());

    // It should render successfully
    expect(find.byType(OnboardingScreen), findsOneWidget);
  });
}
