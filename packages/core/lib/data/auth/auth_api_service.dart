import 'package:dio/dio.dart';

import '../../network/api_endpoints.dart';
import '../../network/dio_provider.dart';
import 'types/auth_exception.dart';

class AuthApiResult {
  final String authToken;

  const AuthApiResult({required this.authToken});
}

class AuthApiService {
  final Dio _dio;

  AuthApiService({Dio? dio}) : _dio = dio ?? NetworkProvider.create();

  Future<AuthApiResult> loginWithPassword({
    required String username,
    required String password,
  }) async {
    final response = await _post(ApiEndpoints.login, {
      'username': username,
      'password': password,
    });

    return _parseSession(response);
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    return _post(
      ApiEndpoints.generateOtp,
      _buildOtpIdentityPayload(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        email: email,
      ),
    );
  }

  Future<AuthApiResult> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    final response = await _post(
      ApiEndpoints.verifyOtp,
      {
        'otp': _parseOtp(otp),
        ..._buildOtpIdentityPayload(
          phoneNumber: phoneNumber,
          countryCode: null,
          email: email,
        ),
      },
    );

    return _parseSession(response);
  }

  Future<void> logout({String? authToken}) {
    return _post(
      ApiEndpoints.logout,
      const <String, dynamic>{},
      authToken: authToken,
    );
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> payload, {
    String? authToken,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        path,
        data: payload,
        options: Options(
          headers: {
            if (authToken != null && authToken.isNotEmpty)
              'Authorization': 'JWT $authToken',
          },
        ),
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (error) {
      throw AuthException.fromDio(error);
    }
  }

  AuthApiResult _parseSession(Map<String, dynamic> body) {
    final authToken = (body['token'] ?? '').toString();

    if (authToken.isEmpty) {
      throw const AuthException('Auth API response missing access token');
    }

    return AuthApiResult(authToken: authToken);
  }

  Map<String, dynamic> _buildOtpIdentityPayload({
    required String phoneNumber,
    String? countryCode,
    String? email,
  }) {
    final payload = <String, dynamic>{};
    final normalizedPhone = _normalizePhone(phoneNumber);

    if (normalizedPhone != null) {
      payload['phone_number'] = normalizedPhone;
    }

    if (countryCode != null && countryCode.trim().isNotEmpty) {
      payload['country_code'] = countryCode.trim();
    }

    if (email != null && email.trim().isNotEmpty) {
      payload['email'] = email.trim();
    }

    return payload;
  }

  dynamic _normalizePhone(String rawPhone) {
    final digitsOnly = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return null;
    return int.tryParse(digitsOnly) ?? digitsOnly;
  }

  dynamic _parseOtp(String rawOtp) {
    final trimmed = rawOtp.trim();
    return int.tryParse(trimmed) ?? trimmed;
  }
}
