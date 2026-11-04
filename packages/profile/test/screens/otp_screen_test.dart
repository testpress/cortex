import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profile/screens/otp_screen.dart';

void main() {
  Widget createTestApp({bool? showWhatsAppOtpOptionOverride}) {
    final router = GoRouter(
      initialLocation: '/otp',
      routes: [
        GoRoute(
          path: '/otp',
          builder: (context, state) => OtpScreen(
            phoneNumber: '5551234567',
            countryCode: '+1',
            showWhatsAppOtpOptionOverride: showWhatsAppOtpOptionOverride,
          ),
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
    await tester.pumpWidget(createTestApp(showWhatsAppOtpOptionOverride: true));
    await expireResendCountdown(tester);

    expect(find.text('Resend via SMS'), findsOneWidget);
    expect(find.text('Resend via WhatsApp'), findsOneWidget);
  });
}
