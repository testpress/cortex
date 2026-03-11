class AppConfig {
  AppConfig._();
  /// Global flag to toggle between Mock and HTTP data sources.
  /// Controlled via --dart-define=USE_MOCK=false
  static const bool useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);
  /// Base URL for HTTP API calls; used when [useMockData] is `false`.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
