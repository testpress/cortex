/// Centralized collection of backend API endpoints.
/// Used to avoid hardcoding strings in network clients.
class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──────────────────────────────────────────────────────────────
  static const String studentLogin = '/api/v2.5/auth-token/';
  static const String generateOtp = '/api/v2.5/auth/generate-otp/';
  static const String verifyOtp = '/api/v2.5/auth/otp-login/';
  static const String logout = '/api/v2.5/auth/logout/';

  // ── User ──────────────────────────────────────────────────────────────
  static const String userProfile = '/api/v2.5/me/';
}
