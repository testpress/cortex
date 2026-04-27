class AppConfig {
  AppConfig._();

  /// Global flag to toggle between Mock and HTTP data sources.
  /// Controlled via --dart-define=USE_MOCK=false
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
  );

  /// Base URL for HTTP API calls.
  /// Reads from a --dart-define=API_BASE_URL=... at build/run time.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://brilliantpalalms.testpress.in/',
  );

  /// Client-specific feature flag to enable the Info experience.
  /// Controlled via --dart-define=ENABLE_INFO_PAGE=true
  static const bool enableInfoPage = bool.fromEnvironment(
    'ENABLE_INFO_PAGE',
    defaultValue: false,
  );
}
