import 'package:flutter/widgets.dart';

/// Defines the allowed login methods for an institute.
enum LoginMethod { formLogin, socialLogin, otpLogin }

@immutable
class InstituteSettings {
  static InstituteSettings? current;

  // APP Specific
  final String name;
  final String photo;
  final String timezone;

  //UI
  final bool dashboardEnabled;
  final bool leaderboardEnabled;

  //Login settings
  final List<LoginMethod> allowedLoginMethods;
  final bool allowSignup;
  final String loginIdLabel;
  final String loginPasswordLabel;
  final bool disableForgotPassword;
  final bool enableParallelLoginRestriction;
  final int maxParallelLogins;
  final bool googleLoginEnabled;

  // User Settings
  final bool enableUserPhoto;
  final bool allowProfileEdit;

  //Learnings
  final bool coursesEnabled;
  final String coursesLabel;
  final String contentsLabel;
  final bool isVideoDownloadEnabled;
  final bool activityFeedEnabled;
  final bool enableCustomTest;

  //Community and Discussions
  final bool postsEnabled;
  final String postsLabel;

  final bool bookmarksEnabled;
  final String bookmarksLabel;

  final bool forumEnabled;
  final String forumLabel;

  final bool helpdeskEnabled;

  //Security Settings
  final bool allowScreenshotInApp;

  //Store Settings
  final bool storeEnabled;
  final String storeLabel;
  final String currentPaymentApp;

  const InstituteSettings({
    required this.name,
    required this.photo,
    required this.timezone,
    required this.dashboardEnabled,
    required this.leaderboardEnabled,
    required this.allowedLoginMethods,
    required this.allowSignup,
    required this.enableUserPhoto,
    required this.allowProfileEdit,
    required this.loginIdLabel,
    required this.loginPasswordLabel,
    required this.disableForgotPassword,
    required this.enableParallelLoginRestriction,
    required this.maxParallelLogins,
    required this.googleLoginEnabled,
    required this.coursesEnabled,
    required this.coursesLabel,
    required this.contentsLabel,
    required this.isVideoDownloadEnabled,
    required this.activityFeedEnabled,
    required this.enableCustomTest,
    required this.postsEnabled,
    required this.postsLabel,
    required this.bookmarksEnabled,
    required this.bookmarksLabel,
    required this.forumEnabled,
    required this.forumLabel,
    required this.helpdeskEnabled,
    required this.allowScreenshotInApp,
    required this.storeEnabled,
    required this.storeLabel,
    required this.currentPaymentApp,
  });

  factory InstituteSettings.fromJson(Map<String, dynamic> json) {
    return InstituteSettings(
      name: json['name'] as String? ?? '',
      photo: json['photo'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',

      dashboardEnabled: json['dashboard_enabled'] as bool? ?? false,
      leaderboardEnabled: json['leaderboard_enabled'] as bool? ?? false,

      allowedLoginMethods: () {
        final parsed = (json['allowed_login_methods'] as List<dynamic>?)
            ?.map((e) {
              if (e == 1) return LoginMethod.formLogin;
              if (e == 2) return LoginMethod.socialLogin;
              if (e == 3) return LoginMethod.otpLogin;
              return null;
            })
            .whereType<LoginMethod>()
            .toList();
        return (parsed == null || parsed.isEmpty)
            ? const [LoginMethod.formLogin]
            : parsed;
      }(),
      allowSignup: json['allow_signup'] as bool? ?? false,
      enableUserPhoto: json['enable_user_photo'] as bool? ?? false,
      allowProfileEdit: json['allow_profile_edit'] as bool? ?? false,
      loginIdLabel: json['login_label'] as String? ?? 'Student Id',
      loginPasswordLabel: json['login_password_label'] as String? ?? 'Password',
      disableForgotPassword: json['disable_forgot_password'] as bool? ?? true,
      enableParallelLoginRestriction:
          json['enable_parallel_login_restriction'] as bool? ?? false,
      maxParallelLogins: json['max_parallel_logins'] as int? ?? 0,
      googleLoginEnabled: json['google_login_enabled'] as bool? ?? false,

      coursesEnabled: json['courses_enabled'] as bool? ?? false,
      coursesLabel: json['courses_label'] as String? ?? 'Courses',
      contentsLabel: json['contents_button_label'] as String? ?? 'Contents',
      isVideoDownloadEnabled:
          json['is_video_download_enabled'] as bool? ?? false,
      activityFeedEnabled: json['activity_feed_enabled'] as bool? ?? false,
      enableCustomTest: json['enable_custom_test'] as bool? ?? false,

      postsEnabled: json['posts_enabled'] as bool? ?? false,
      postsLabel: json['posts_label'] as String? ?? 'Posts',
      bookmarksEnabled: json['bookmarks_enabled'] as bool? ?? false,
      bookmarksLabel: json['bookmarks_label'] as String? ?? 'Bookmarks',
      forumEnabled: json['forum_enabled'] as bool? ?? false,
      forumLabel: json['forum_label'] as String? ?? 'Discussions',
      helpdeskEnabled: json['is_helpdesk_enabled'] as bool? ?? false,

      allowScreenshotInApp: json['allow_screenshot_in_app'] as bool? ?? false,

      storeEnabled: json['store_enabled'] as bool? ?? false,
      storeLabel: json['store_label'] as String? ?? 'Store',
      currentPaymentApp: json['current_payment_app'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo,
      'timezone': timezone,
      'dashboard_enabled': dashboardEnabled,
      'leaderboard_enabled': leaderboardEnabled,
      'allowed_login_methods': allowedLoginMethods.map((e) {
        switch (e) {
          case LoginMethod.formLogin:
            return 1;
          case LoginMethod.socialLogin:
            return 2;
          case LoginMethod.otpLogin:
            return 3;
        }
      }).toList(),
      'allow_signup': allowSignup,
      'enable_user_photo': enableUserPhoto,
      'allow_profile_edit': allowProfileEdit,
      'login_label': loginIdLabel,
      'login_password_label': loginPasswordLabel,
      'disable_forgot_password': disableForgotPassword,
      'enable_parallel_login_restriction': enableParallelLoginRestriction,
      'max_parallel_logins': maxParallelLogins,
      'google_login_enabled': googleLoginEnabled,
      'courses_enabled': coursesEnabled,
      'courses_label': coursesLabel,
      'contents_button_label': contentsLabel,
      'is_video_download_enabled': isVideoDownloadEnabled,
      'activity_feed_enabled': activityFeedEnabled,
      'enable_custom_test': enableCustomTest,
      'posts_enabled': postsEnabled,
      'posts_label': postsLabel,
      'bookmarks_enabled': bookmarksEnabled,
      'bookmarks_label': bookmarksLabel,
      'forum_enabled': forumEnabled,
      'forum_label': forumLabel,
      'is_helpdesk_enabled': helpdeskEnabled,
      'allow_screenshot_in_app': allowScreenshotInApp,
      'store_enabled': storeEnabled,
      'store_label': storeLabel,
      'current_payment_app': currentPaymentApp,
    };
  }
}
