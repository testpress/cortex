import 'package:dio/dio.dart';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the shared [AuthApiService] instance.
final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthApiService(dio);
});

/// Service responsible for all authentication-related network calls.
/// This service focuses only on the API endpoints for auth.
/// It receives a [Dio] instance pre-configured with the base URL and JWT headers.
class AuthApiService {
  AuthApiService(this._dio);

  final Dio _dio;

  /// Performs a password-based login.
  /// POST /api/v2.5/auth-token/
  Future<AuthTokenResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      return await _postForToken(
        ApiEndpoints.studentLogin,
        body: {
          'username': username,
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw AuthException.fromDio(e);
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
      await _postVoid(
        ApiEndpoints.generateOtp,
        body: _buildGenerateOtpPayload(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          email: email,
        ),
      );
    } on DioException catch (e) {
      throw AuthException.fromDio(e);
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
      return await _postForToken(
        ApiEndpoints.verifyOtp,
        body: _buildVerifyOtpPayload(
          otp: otp,
          phoneNumber: phoneNumber,
          email: email,
        ),
      );
    } on DioException catch (e) {
      throw AuthException.fromDio(e);
    }
  }

  /// Invalidates the current backend session/token when supported.
  /// POST /api/v2.5/auth/logout/
  Future<void> logout() async {
    try {
      await _postVoid(ApiEndpoints.logout);
    } on DioException catch (e) {
      if (AuthException.shouldIgnoreLogoutError(e)) {
        return;
      }
      throw AuthException.fromDio(e);
    }
  }

  /// Fetches the current user profile from the backend.
  /// GET /api/v2.5/me/
  Future<UserDto> fetchProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.userProfile);
      return _parseUserProfile(response.data);
    } on DioException catch (e) {
      throw AuthException.fromDio(e);
    }
  }

  Future<AuthTokenResponse> _postForToken(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _dio.post(path, data: body);
    return _parseAuthTokenResponse(response.data);
  }

  Future<void> _postVoid(
    String path, {
    Map<String, dynamic>? body,
  }) {
    return _dio.post(path, data: body);
  }

  Map<String, dynamic> _buildGenerateOtpPayload({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    final payload = <String, dynamic>{
      'phone_number': phoneNumber,
      'country_code': countryCode,
    };
    if (email != null) {
      payload['email'] = email;
    }
    return payload;
  }

  Map<String, dynamic> _buildVerifyOtpPayload({
    required String otp,
    required String phoneNumber,
    String? email,
  }) {
    final payload = <String, dynamic>{
      'otp': otp,
      'phone_number': phoneNumber,
    };
    if (email != null) {
      payload['email'] = email;
    }
    return payload;
  }

  AuthTokenResponse _parseAuthTokenResponse(dynamic raw) {
    final data = _asJsonMap(raw);
    return AuthTokenResponse.fromJson(data);
  }

  UserDto _parseUserProfile(dynamic raw) {
    final data = _asJsonMap(raw);
    return UserDto(
      id: data['id']?.toString() ?? '',
      name: _resolveDisplayName(data),
      email: data['email']?.toString(),
      phone: data['phone']?.toString(),
      avatar: _resolveAvatar(data),
      isPro: data['is_pro'] ?? false,
      joinedDate: data['joined_date'] != null
          ? DateTime.tryParse(data['joined_date'].toString())
          : null,
    );
  }

  String _resolveDisplayName(Map<String, dynamic> data) {
    final firstName = (data['first_name'] as String?)?.trim() ?? '';
    final lastName = (data['last_name'] as String?)?.trim() ?? '';
    final fallbackName = '$firstName $lastName'.trim();
    final displayName = (data['display_name'] as String?)?.trim();
    final backendName = (data['name'] as String?)?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    if (backendName != null && backendName.isNotEmpty) {
      return backendName;
    }
    return fallbackName;
  }

  String? _resolveAvatar(Map<String, dynamic> data) {
    return data['photo']?.toString() ??
        data['large_image']?.toString() ??
        data['avatar']?.toString();
  }

  Map<String, dynamic> _asJsonMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.cast<String, dynamic>();
    }
    throw AuthException.malformedResponse();
  }
}
