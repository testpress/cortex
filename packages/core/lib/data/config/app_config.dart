class AppConfig {
  /// Global flag to toggle between Mock and HTTP data sources.
  /// Controlled via --dart-define=USE_MOCK=false
  static const bool useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);
}
