import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();
  /// Global flag to toggle between Mock and HTTP data sources.
  /// Controlled via --dart-define=USE_MOCK=false
  static const bool useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  /// Base URL for HTTP API calls.
  /// Reads from .env at runtime, falls back to --dart-define, then localhost.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ??
      const String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:3000');
}
