import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the shared [AuthClient] instance.
final authClientProvider = Provider<AuthClient>((ref) {
  final dio = ref.read(dioProvider);
  return AuthClient(dio);
});

/// Client responsible for all authentication-related network calls.
/// This client focuses ONLY on the API endpoints for auth.
/// It receives a [Dio] instance pre-configured with the base URL and JWT headers.
class AuthClient {
  final Dio _dio;

  AuthClient(this._dio);

  /// Performs a password-based login.
  /// POST /api/v2.5/auth-token/
  Future<AuthTokenResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.studentLogin,
        data: {'username': username, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      return AuthTokenResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Requests an OTP to be sent to the user's phone or email.
  /// POST /api/v2.5/auth/generate-otp/
  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) async {
    try {
      final payload = <String, dynamic>{
        'phone_number': phoneNumber,
        'country_code': countryCode,
      };
      if (email != null) {
        payload['email'] = email;
      }

      await _dio.post(ApiEndpoints.generateOtp, data: payload);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Verifies the OTP and returns authentication tokens.
  /// POST /api/v2.5/auth/otp-login/
  Future<AuthTokenResponse> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) async {
    try {
      final payload = <String, dynamic>{'otp': otp, 'phone_number': phoneNumber};
      if (email != null) {
        payload['email'] = email;
      }

      final response = await _dio.post(ApiEndpoints.verifyOtp, data: payload);
      final data = response.data as Map<String, dynamic>;
      return AuthTokenResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Fetches the current user profile from the backend.
  /// GET /api/v2.5/me/
  Future<UserDto> fetchProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.userProfile);
      final data = response.data as Map<String, dynamic>;

      final firstName = (data['first_name'] as String?)?.trim() ?? '';
      final lastName = (data['last_name'] as String?)?.trim() ?? '';
      final fallbackName = '$firstName $lastName'.trim();
      final displayName = (data['display_name'] as String?)?.trim();
      final backendName = (data['name'] as String?)?.trim();
      final resolvedName = (displayName?.isNotEmpty ?? false)
          ? displayName!
          : (backendName?.isNotEmpty ?? false)
          ? backendName!
          : fallbackName;

      return UserDto(
        id: data['id']?.toString() ?? '',
        name: resolvedName,
        email: data['email']?.toString(),
        phone: data['phone']?.toString(),
        avatar:
            data['photo']?.toString() ??
            data['large_image']?.toString() ??
            data['avatar']?.toString(),
        isPro: data['is_pro'] ?? false,
        joinedDate: data['joined_date'] != null
            ? DateTime.tryParse(data['joined_date'].toString())
            : null,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Translates Dio errors into domain-specific AuthExceptions.
  Exception _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return AuthException(
        'Network error. Please check your connection and try again.',
      );
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      final backendMessage = _getApiErrorMessage(e.response?.data);
      if (backendMessage != null) {
        return AuthException(backendMessage);
      }
      return AuthException('Invalid or expired credentials.');
    }
    if (statusCode == 403) {
      return AuthException(
        'You do not have permission to perform this action.',
      );
    }
    if (statusCode == 400 || statusCode == 422) {
      final backendMessage = _getApiErrorMessage(e.response?.data);
      if (backendMessage != null) {
        return AuthException(backendMessage);
      }
      return AuthException('Request validation failed.');
    }

    return AuthException('An unexpected error occurred. Please try again.');
  }

  String? _getApiErrorMessage(dynamic responseData) {
    if (responseData == null) return null;
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }
    if (responseData is! Map) return null;

    final map = responseData.cast<dynamic, dynamic>();

    final detail = map['detail']?.toString().trim();
    if (detail != null && detail.isNotEmpty) return detail;

    final message = map['message']?.toString().trim();
    if (message != null && message.isNotEmpty) return message;

    final error = map['error']?.toString().trim();
    if (error != null && error.isNotEmpty) return error;

    final nonFieldErrors = map['non_field_errors'];
    if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
      final first = nonFieldErrors.first?.toString().trim();
      if (first != null && first.isNotEmpty) return first;
    }

    for (final entry in map.entries) {
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        final first = value.first?.toString().trim();
        if (first != null && first.isNotEmpty) return first;
      }
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return null;
  }
}
