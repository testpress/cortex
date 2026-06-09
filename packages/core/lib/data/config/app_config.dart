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
    defaultValue: 'https://lmsdemo.testpress.in/',
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

  static const bool showExploreTab = bool.fromEnvironment(
    'SHOW_EXPLORE_TAB',
    defaultValue: true,
  );

  static const bool showProfileTab = bool.fromEnvironment(
    'SHOW_PROFILE_TAB',
    defaultValue: true,
  );

  static const String instituteLogoUrl = String.fromEnvironment(
    'INSTITUTE_LOGO_URL',
    defaultValue: '',
  );

  static const bool isLocalLogo = bool.fromEnvironment(
    'IS_LOCAL_LOGO',
    defaultValue: false,
  );

  static const String loginScreenImageLocalPath = String.fromEnvironment(
    'LOGIN_SCREEN_IMAGE_LOCAL_PATH',
    defaultValue: '',
  );
}
