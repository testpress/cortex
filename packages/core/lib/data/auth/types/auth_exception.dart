import 'package:dio/dio.dart';
import '../../exceptions/api_exception.dart';

/// Represents authentication-related errors inside the domain.
/// Extends [ApiException] for unified error handling across the application.
class AuthException extends ApiException {
  const AuthException(
    super.message, {
    super.type = ApiErrorType.unknown,
    super.statusCode,
  });

  factory AuthException.network({
    String message = "We couldn't connect. Please check your internet and try again.",
  }) =>
      AuthException(message, type: ApiErrorType.noInternet);

  factory AuthException.invalidCredentials({
    String message = 'The username or password you entered is incorrect.',
  }) =>
      AuthException(message, type: ApiErrorType.unauthorized, statusCode: 401);

  factory AuthException.unauthorized({
    String message = "It looks like you don't have access to this feature.",
  }) =>
      AuthException(message, type: ApiErrorType.forbidden, statusCode: 403);

  factory AuthException.validation({
    String message = 'Something looks wrong with the info you provided. Please check and try again.',
    int? statusCode,
  }) =>
      AuthException(
        message,
        type: ApiErrorType.badRequest,
        statusCode: statusCode,
      );

  factory AuthException.malformedResponse({
    String message = 'We are having trouble communicating with our servers. Please try again later.',
  }) =>
      AuthException(message, type: ApiErrorType.malformedResponse);

  factory AuthException.unknown({
    String message = 'Oops! Something went wrong on our end. Please try again in a moment.',
    int? statusCode,
  }) =>
      AuthException(message, type: ApiErrorType.unknown, statusCode: statusCode);

  factory AuthException.fromDio(DioException error) {
    // Leverage the base ApiException parsing logic
    final apiException = ApiException.fromDio(error);
    
    // We can then customize behavior for specific Auth status codes if needed
    if (apiException.statusCode == 401) {
       return AuthException.invalidCredentials();
    }
    
    return AuthException(
      apiException.message,
      type: apiException.type,
      statusCode: apiException.statusCode,
    );
  }
}
