import 'package:core/data/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig WhatsApp OTP host support', () {
    test('matches only the configured hosts', () {
      for (final host in [
        'lmsdemo.testpress.in',
        'staging.testpress.in',
        'cortexlms.testpress.in',
      ]) {
        expect(AppConfig.isWhatsAppOtpHost('https://$host/'), isTrue);
      }

      expect(
        AppConfig.isWhatsAppOtpHost('https://other.testpress.in/'),
        isFalse,
      );
      expect(
        AppConfig.isWhatsAppOtpHost(
          'https://lmsdemo.testpress.in.attacker.example/',
        ),
        isFalse,
      );
    });

    test('normalizes host case and accepts base URLs with paths', () {
      expect(
        AppConfig.isWhatsAppOtpHost('HTTPS://LMSDEMO.TESTPRESS.IN/api/v2.5/'),
        isTrue,
      );
    });

    test('returns false for invalid or hostless URLs', () {
      expect(AppConfig.isWhatsAppOtpHost('not a url'), isFalse);
      expect(AppConfig.isWhatsAppOtpHost('/api/v2.5/'), isFalse);
    });
  });
}
