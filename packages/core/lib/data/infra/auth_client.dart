import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../models/login_response_dto.dart';
import '../models/user_dto.dart';
import 'session/session_storage.dart';

/// Errors surfaced by [AuthClient].
class AuthException implements Exception {
  AuthException(
    this.message, {
    this.type = AuthErrorType.serverError,
    this.fieldErrors,
  });

  final String message;
  final AuthErrorType type;
  final Map<String, List<String>>? fieldErrors;

  @override
  String toString() => 'AuthException($type): $message';
}

enum AuthErrorType {
  invalidCredentials,
  validation,
  throttled,
  lockout,
  serverError,
  network,
}

/// Authentication client that wraps the backend login/OTP endpoints.
class AuthClient {
  AuthClient({Dio? dio, SessionStorage? sessionStorage})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), ''),
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              responseType: ResponseType.json,
              headers: {'content-type': 'application/json'},
            ),
          ),
      _sessionStorage = sessionStorage ?? SessionStorage.instance;

  final Dio _dio;
  final SessionStorage _sessionStorage;
  final Map<String, Future<dynamic>> _pendingRequests = {};
  DateTime? _lastOtpSentAt;

  static const Duration _otpCooldown = Duration(seconds: 30);

  Future<LoginResponseDto> login({
    required String username,
    required String password,
  }) {
    return _singleCall('login', () async {
      try {
        final response = await _dio.post(
          '/api/v2.5/auth-token/',
          data: {'username': username.trim(), 'password': password},
        );

        if (response.statusCode != 200) {
          throw _mapToAuthException(response);
        }

        _debugResponse('/api/v2.5/auth-token/', _normalizeResponse(response));
        final session = _loginResponseFromResponse(response);
        await _sessionStorage.persistSession(
          token: session.token,
          isNewUser: session.isNewUser,
        );

        return session;
      } on DioException catch (dioError) {
        throw _handleDioException(dioError);
      }
    });
  }

  Future<void> generateOtp({
    required String phoneNumber,
    required String countryCode,
    String? email,
  }) {
    return _singleCall('generateOtp', () async {
      final now = DateTime.now();
      if (_lastOtpSentAt != null &&
          now.difference(_lastOtpSentAt!) < _otpCooldown) {
        throw AuthException(
          'Please wait a few moments before requesting another OTP.',
          type: AuthErrorType.throttled,
        );
      }

      final payload = {
        'phone_number': phoneNumber.trim(),
        'country_code': countryCode.trim(),
      };

      if (email != null && email.isNotEmpty) {
        payload['email'] = email.trim();
      }

      try {
        final response = await _dio.post(
          '/api/v2.5/auth/generate-otp/',
          data: payload,
        );

        if (response.statusCode != null &&
            response.statusCode! >= 200 &&
            response.statusCode! < 300) {
          _debugResponse(
            '/api/v2.5/auth/generate-otp/',
            _normalizeResponse(response),
          );
          _lastOtpSentAt = DateTime.now();
          return;
        }

        throw _mapToAuthException(response);
      } on DioException catch (dioError) {
        throw _handleDioException(dioError);
      }
    });
  }

  Future<LoginResponseDto> verifyOtp({
    required String otp,
    required String phoneNumber,
    String? email,
  }) {
    return _singleCall('verifyOtp', () async {
      final payload = {'otp': otp.trim(), 'phone_number': phoneNumber.trim()};

      if (email != null && email.isNotEmpty) {
        payload['email'] = email.trim();
      }

      try {
        final response = await _dio.post(
          '/api/v2.5/auth/otp-login/',
          data: payload,
        );

        if (response.statusCode != 200) {
          throw _mapToAuthException(response);
        }

        _debugResponse('/api/v2.5/auth/otp-login/', _normalizeResponse(response));
        final session = _loginResponseFromResponse(response);
        await _sessionStorage.persistSession(
          token: session.token,
          isNewUser: session.isNewUser,
        );

        return session;
      } on DioException catch (dioError) {
        throw _handleDioException(dioError);
      }
    });
  }

  Future<UserDto> fetchCurrentUser() async {
    if (!_sessionStorage.hasSession) {
      throw AuthException(
        'No active session available.',
        type: AuthErrorType.network,
      );
    }

    return _singleCall('fetchCurrentUser', () async {
      try {
        final response = await _dio.get(
          '/api/v2.5/me/',
          options: Options(headers: _authorizationHeaders()),
        );

        if (response.statusCode != 200) {
          throw _mapToAuthException(response);
        }

        final payload = _normalizeResponse(response);
        _debugResponse('/api/v2.5/me/', payload);
        final user = _mapUserDto(payload);
        await _sessionStorage.persistUserProfile(user);
        return user;
      } on DioException catch (dioError) {
        throw _handleDioException(dioError);
      }
    });
  }

  /// Shared hydration entry point used by startup and post-login flows.
  /// Uses cached user first unless [forceRefresh] is true.
  Future<UserDto> resolveCurrentUser({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cachedUser = _sessionStorage.cachedUser;
      if (cachedUser != null && cachedUser.id.isNotEmpty) {
        return cachedUser;
      }
    }
    return fetchCurrentUser();
  }

  Future<T> _singleCall<T>(String key, Future<T> Function() action) {
    if (_pendingRequests.containsKey(key)) {
      return _pendingRequests[key]! as Future<T>;
    }

    final future = action();
    _pendingRequests[key] = future;
    future.whenComplete(() => _pendingRequests.remove(key));
    return future;
  }

  LoginResponseDto _loginResponseFromResponse(Response response) {
    final payload = _normalizeResponse(response);
    try {
      return LoginResponseDto.fromJson(payload);
    } on FormatException catch (error) {
      throw AuthException(
        error.message,
        type: AuthErrorType.serverError,
      );
    }
  }

  AuthException _mapToAuthException(Response response) {
    final payload = _normalizeResponse(response);
    final detail = (payload['detail'] ?? payload['message'])?.toString() ?? '';
    final errors = _extractFieldErrors(payload);

    switch (response.statusCode) {
      case 400:
      case 401:
        return AuthException(
          detail.isNotEmpty
              ? detail
              : 'Incorrect username or password combination.',
          type: AuthErrorType.invalidCredentials,
          fieldErrors: errors,
        );
      case 422:
        return AuthException(
          detail.isNotEmpty ? detail : 'Validation failed.',
          type: AuthErrorType.validation,
          fieldErrors: errors,
        );
      case 429:
        return AuthException(
          'Too many login attempts. Please try again later.',
          type: AuthErrorType.throttled,
        );
      case 423:
      case 403:
        return AuthException(
          'Your account is locked. Please contact your administrator.',
          type: AuthErrorType.lockout,
        );
      default:
        return AuthException(
          detail.isNotEmpty
              ? detail
              : 'Unexpected response from the authentication service.',
          type: AuthErrorType.serverError,
        );
    }
  }

  AuthException _handleDioException(DioException exception) {
    if (exception.response != null) {
      _debugResponse(
        'error:${exception.requestOptions.path}',
        _normalizeResponse(exception.response!),
      );
    }

    if (exception.response != null) {
      return _mapToAuthException(exception.response!);
    }

    final message = switch (exception.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out.',
      DioExceptionType.sendTimeout => 'Request timed out.',
      DioExceptionType.receiveTimeout => 'Response timed out.',
      DioExceptionType.badCertificate =>
        'Unable to verify the server certificate.',
      DioExceptionType.cancel => 'Request was cancelled.',
      _ => 'Unable to reach the authentication service.',
    };

    return AuthException(message, type: AuthErrorType.network);
  }

  Map<String, dynamic> _normalizeResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (_) {
        // fall through
      }
    }
    return {};
  }

  Map<String, String> _authorizationHeaders() {
    final header = _sessionStorage.authorizationHeader;
    if (header == null || header.isEmpty) {
      throw AuthException(
        'No active session available.',
        type: AuthErrorType.network,
      );
    }

    return {'content-type': 'application/json', 'Authorization': header};
  }

  Map<String, List<String>> _extractFieldErrors(Map<String, dynamic> payload) {
    final errors = <String, List<String>>{};
    for (final entry in payload.entries) {
      if (entry.key == 'detail' || entry.key == 'message') continue;
      final value = entry.value;
      if (value is List) {
        errors[entry.key] = value
            .map((item) => item.toString())
            .where((s) => s.isNotEmpty)
            .toList();
      } else if (value is String) {
        errors[entry.key] = [value];
      }
    }
    return errors;
  }

  void _debugResponse(String endpoint, Map<String, dynamic> payload) {
    if (!kDebugMode) return;
    final redacted = Map<String, dynamic>.from(payload);
    final token = redacted['token'];
    if (token is String && token.isNotEmpty) {
      redacted['token'] = '${token.substring(0, token.length > 12 ? 12 : token.length)}...';
    }
    debugPrint('[AuthClient] $endpoint response: $redacted');
  }

  UserDto _mapUserDto(Map<String, dynamic> payload) {
    final id = payload['id']?.toString() ?? '';
    final displayName = payload['display_name'] as String?;
    final firstName = payload['first_name'] as String?;
    final username = payload['username'] as String?;
    final fallbackName = [
      firstName,
      payload['last_name'] as String?,
    ].where((part) => part != null && part.trim().isNotEmpty).join(' ').trim();

    final name = (displayName != null && displayName.trim().isNotEmpty)
        ? displayName.trim()
        : (fallbackName.isNotEmpty ? fallbackName : (username ?? 'Student'));

    return UserDto(
      id: id,
      name: name,
      email: payload['email'] as String?,
      phone: payload['phone'] as String?,
      avatar:
          (payload['photo'] ??
                  payload['large_image'] ??
                  payload['medium_image'] ??
                  payload['small_image'])
              as String?,
    );
  }
}
