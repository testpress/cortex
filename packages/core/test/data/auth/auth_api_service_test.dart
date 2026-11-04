import 'package:core/data/auth/auth_api_service.dart';
import 'package:core/data/auth/types/otp_delivery_channel.dart';
import 'package:core/data/services/sentry_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthApiService service;
  late Map<String, dynamic> requestPayload;

  setUp(() {
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requestPayload = Map<String, dynamic>.from(options.data as Map);
          handler.resolve(
            Response<Map<String, dynamic>>(
              requestOptions: options,
              statusCode: 200,
              data: <String, dynamic>{},
            ),
          );
        },
      ),
    );
    service = AuthApiService(dio: dio, sentryService: SentryService());
  });

  group('OTP generation delivery channel', () {
    test('initial OTP generation omits channel', () async {
      await service.generateOtp(
        phoneNumber: '(555) 123-4567',
        countryCode: '+1',
      );

      expect(requestPayload, {
        'phone_number': '5551234567',
        'country_code': '+1',
      });
    });

    test('OTP resends include the selected channel', () async {
      for (final channel in OtpDeliveryChannel.values) {
        await service.generateOtp(
          phoneNumber: '(555) 123-4567',
          countryCode: '+1',
          channel: channel,
        );

        expect(requestPayload, {
          'phone_number': '5551234567',
          'country_code': '+1',
          'channel': channel.name,
        });
      }
    });
  });
}
