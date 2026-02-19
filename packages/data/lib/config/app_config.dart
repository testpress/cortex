/// Application configuration flags.
///
/// Override via dart-define at build time:
///   flutter run --dart-define=USE_MOCK=false --dart-define=API_BASE_URL=https://api.example.com
class AppConfig {
  AppConfig._();

  /// When true, [MockDataSource] is used. When false, [HttpDataSource] is used.
  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: true,
  );

  /// Base URL for HTTP API calls. Only relevant when [useMockData] is false.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
