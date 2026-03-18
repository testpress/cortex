import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration for the Cortex app.
/// Loads environment-specific settings from the `.env` file via [dotenv].
class AppConfig {
  AppConfig._();

  /// Initialize the configuration by loading the `.env` file.
  /// This should be called once during app bootstrap.
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Keep --dart-define defaults when .env is missing.
      return;
    }

    // Manually update the variables with the values from the .env file
    final mockEnv = dotenv.env['USE_MOCK'];
    if (mockEnv != null) {
      useMockData = mockEnv.toLowerCase() == 'true';
    }

    final urlEnv = dotenv.env['API_BASE_URL'];
    if (urlEnv != null) {
      apiBaseUrl = urlEnv;
    }

    final httpCourseSyncEnv = dotenv.env['ENABLE_HTTP_COURSE_SYNC'];
    if (httpCourseSyncEnv != null) {
      enableHttpCourseSync = httpCourseSyncEnv.toLowerCase() == 'true';
    }
  }

  /// Global flag to toggle between Mock and HTTP data sources.
  /// Defaults from `--dart-define` and can be overridden by `.env` during initialize().
  static bool useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  /// Base URL for HTTP API calls; used when [useMockData] is `false`.
  static String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  /// Enables HTTP-based course/chapter/lesson sync when endpoints are ready.
  /// Defaults from `--dart-define` and can be overridden by `.env`.
  static bool enableHttpCourseSync = bool.fromEnvironment(
    'ENABLE_HTTP_COURSE_SYNC',
    defaultValue: false,
  );
}
