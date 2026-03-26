class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/api/v2.5/auth-token/';
  static const String generateOtp = '/api/v2.5/auth/generate-otp/';
  static const String verifyOtp = '/api/v2.5/auth/otp-login/';
  static const String logout = '/api/v2.5/auth/logout/';
  static const String resetPassword = '/api/v2.3/password/reset/';
  static const String userProfile = '/api/v2.5/me/';
}
