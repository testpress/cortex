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
  /// IMPORTANT: Always supply `--dart-define=API_BASE_URL=<url>` when building.
  /// Leaving this empty will cause a startup assertion failure in release mode.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Validates critical compile-time configuration.
  /// Call this at app startup (before runApp) in release builds.
  /// In debug mode, an AssertionError is thrown; in release mode a
  /// StateError is thrown to crash fast with a clear message.
  static void validate() {
    assert(
      apiBaseUrl.isNotEmpty,
      'API_BASE_URL is not set. Build with --dart-define=API_BASE_URL=https://your-instance.testpress.in/',
    );
    assert(
      apiBaseUrl.startsWith('http://') || apiBaseUrl.startsWith('https://'),
      'API_BASE_URL must start with http:// or https://. '
      'Got: $apiBaseUrl',
    );
    if (const bool.fromEnvironment('dart.vm.product')) {
      if (apiBaseUrl.isEmpty) {
        throw StateError(
          'FATAL: API_BASE_URL must be set for production builds. '
          'Build with --dart-define=API_BASE_URL=https://your-instance.testpress.in/',
        );
      }
      if (!apiBaseUrl.startsWith('http://') &&
          !apiBaseUrl.startsWith('https://')) {
        throw StateError(
          'FATAL: API_BASE_URL must start with http:// or https://. '
          'Got: $apiBaseUrl',
        );
      }
    }
  }

  /// Web Client ID used for Google Sign-In backend verification.
  /// Dynamically injected via --dart-define during build scripts.
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  /// DSN for Sentry error tracking
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue:
        'https://442b7cef9ddbb5e16a2aaa897cbbaf0e@sentry.testpress.in/32',
  );

  // --- UI Feature Flags & Branding ---
  // These are automatically populated at compile-time when using:
  // --dart-define-from-file=../config/<institute_name>.json

  static const bool showTodaySchedule = bool.fromEnvironment(
    'SHOW_TODAY_SCHEDULE',
    defaultValue: true,
  );

  static const bool showQuickAccess = bool.fromEnvironment(
    'SHOW_QUICK_ACCESS',
    defaultValue: true,
  );

  static const bool showContextualHero = bool.fromEnvironment(
    'SHOW_CONTEXTUAL_HERO',
    defaultValue: true,
  );

  static const bool showStudyCategoryButtons = bool.fromEnvironment(
    'SHOW_STUDY_CATEGORY_BUTTONS',
    defaultValue: true,
  );

  static const bool showResumeSection = bool.fromEnvironment(
    'SHOW_RESUME_SECTION',
    defaultValue: false,
  );

  static const bool showWhatsNewSection = bool.fromEnvironment(
    'SHOW_WHATS_NEW_SECTION',
    defaultValue: false,
  );

  static const bool showRecentlyCompletedSection = bool.fromEnvironment(
    'SHOW_RECENTLY_COMPLETED_SECTION',
    defaultValue: false,
  );

  static const bool showExamTab = bool.fromEnvironment(
    'SHOW_EXAM_TAB',
    defaultValue: false,
  );

  static const bool showInfoTab = bool.fromEnvironment(
    'SHOW_INFO_TAB',
    defaultValue: false,
  );

  static const bool showProfileTab = bool.fromEnvironment(
    'SHOW_PROFILE_TAB',
    defaultValue: true,
  );

  static const bool showCertificate = bool.fromEnvironment(
    'SHOW_CERTIFICATE',
    defaultValue: false,
  );

  static const String instituteLogoUrl = String.fromEnvironment(
    'INSTITUTE_LOGO_URL',
    defaultValue: '',
  );

  static const String loginScreenImageLocalPath =
      'assets/images/login_screen_image.png';

  static const String splashScreenImage =
      'assets/images/splash_screen_image.png';
}
