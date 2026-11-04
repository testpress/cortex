import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/screens/otp_screen.dart';

void main() {
  tearDown(() {
    AppConfig.showWhatsAppOTPoptionOverride = null;
  });

  Widget createTestApp() {
    final router = GoRouter(
      initialLocation: '/otp',
      routes: [
        GoRoute(
          path: '/otp',
          builder: (context, state) =>
              const OtpScreen(phoneNumber: '5551234567', countryCode: '+1'),
        ),
      ],
    );

    return ProviderScope(
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }

  Future<void> expireResendCountdown(WidgetTester tester) async {
    for (var second = 0; second < 30; second++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  testWidgets('shows channel-specific resend options when enabled', (
    tester,
  ) async {
    AppConfig.showWhatsAppOTPoptionOverride = true;
    await tester.pumpWidget(createTestApp());
    await expireResendCountdown(tester);

    expect(find.text('Resend via SMS'), findsOneWidget);
    expect(find.text('Resend via WhatsApp'), findsOneWidget);
  });

  testWidgets('keeps the existing SMS resend option on other hosts', (
    tester,
  ) async {
    AppConfig.showWhatsAppOTPoptionOverride = false;
    await tester.pumpWidget(createTestApp());
    await expireResendCountdown(tester);

    expect(find.text('Resend'), findsOneWidget);
    expect(find.text('Resend via SMS'), findsNothing);
    expect(find.text('Resend via WhatsApp'), findsNothing);
  });
}
