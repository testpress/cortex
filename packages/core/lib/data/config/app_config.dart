class AppConfig {
  AppConfig._();

  static bool? _runtimeUseMockData;
  static String? _runtimeApiBaseUrl;

  /// Allows runtime startup code to override defaults from external config.
  static void configure({
    bool? useMockData,
    String? apiBaseUrl,
  }) {
    _runtimeUseMockData = useMockData;
    _runtimeApiBaseUrl = apiBaseUrl;
  }

  /// Global flag to toggle between Mock and HTTP data sources.
  /// Default controlled via --dart-define=USE_MOCK=false.
  static bool get useMockData =>
      _runtimeUseMockData ??
      const bool.fromEnvironment('USE_MOCK', defaultValue: true);

  /// Base URL for HTTP API calls; used when [useMockData] is `false`.
  static String get apiBaseUrl =>
      _runtimeApiBaseUrl ??
      const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:3000',
      );
}
