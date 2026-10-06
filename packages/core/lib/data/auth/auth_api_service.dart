import 'package:dio/dio.dart';

import '../../network/api_endpoints.dart';
import '../services/sentry_service.dart';
import 'types/auth_exception.dart';

class AuthApiResult {
  final String authToken;

  const AuthApiResult({required this.authToken});
}

class AuthApiService {
  final Dio _dio;
  final SentryService _sentryService;

  AuthApiService({required Dio dio, required SentryService sentryService})
    : _dio = dio,
      _sentryService = sentryService;

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

  Future<AuthApiResult> loginWithGoogle({
    required String idToken,
    required String userId,
  }) async {
    final response = await _post(ApiEndpoints.socialAuth, {
      'provider': 'GOOGLE',
      'access_token': idToken,
      'user_id': userId,
    });

    return _parseSession(response);
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    String? phone,
    String? countryCode,
  }) async {
    final payload = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };
    if (phone != null && phone.isNotEmpty) {
      payload['phone'] = phone;
    }
    if (countryCode != null && countryCode.isNotEmpty) {
      payload['country_code'] = countryCode;
    }
    await _post(ApiEndpoints.register, payload);
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
    final response = await _post(ApiEndpoints.verifyOtp, {
      'otp': _parseOtp(otp),
      ..._buildOtpIdentityPayload(
        phoneNumber: phoneNumber,
        countryCode: null,
        email: email,
      ),
    });

    return _parseSession(response);
  }

  Future<void> logout({String? authToken}) {
    return _post(
      ApiEndpoints.logout,
      const <String, dynamic>{},
      authToken: authToken,
    );
  }

  Future<void> logoutOtherDevices({String? authToken}) {
    return _post(
      ApiEndpoints.logoutDevices,
      const <String, dynamic>{},
      authToken: authToken,
    );
  }

  Future<void> resetPassword({required String email}) {
    return _post(ApiEndpoints.resetPassword, {'email': email});
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
    } on DioException catch (error, stackTrace) {
      _sentryService.captureException(error, stackTrace: stackTrace);
      throw AuthException.fromDio(error);
    }
  }

  /// Checks whether mandatory student profile data has been collected.
  ///
  /// Calls `GET /api/v2.3/me/check_permission/`.
  /// - Returns `false` when `is_data_collected` is false or if the request
  ///   is redirected with HTTP 302 to `/settings/force/mobile/`.
  /// - **Fails open (returns `true`)** on non-302 errors (e.g. network timeout,
  ///   connectivity drop, 5xx): this is intentional to avoid blocking authenticated
  ///   students from accessing the app during transient network or backend glitches.
  ///   If the student's profile is actually incomplete, subsequent API requests
  ///   will still trigger a 302 redirect from the backend, which [AuthInterceptor]
  ///   catches reactively as a secondary line of defense.
  Future<bool> checkStudentDataCollected() async {
    try {
      final response = await _dio.get(ApiEndpoints.checkStudentDataPermission);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return (data['is_data_collected'] as bool?) ?? true;
      }
      return true;
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 302) {
        final location = error.response?.headers.value('location') ?? '';
        if (location.contains('/settings/force/')) {
          return false;
        }
      }
      _sentryService.captureException(
        error,
        stackTrace: stackTrace,
        tags: const {'feature': 'check_student_data_permission'},
      );
      // Intentionally fails open to avoid blocking users during transient network issues.
      // Subsequent API calls are still gated reactively via AuthInterceptor (302 handler).
      return true;
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

  String? _normalizePhone(String rawPhone) {
    final digitsOnly = rawPhone.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) return null;
    return digitsOnly;
  }

  String _parseOtp(String rawOtp) {
    return rawOtp.trim();
  }
}
