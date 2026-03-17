import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('ml'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Cortex SDK'**
  String get appTitle;

  /// Text for the login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// No description provided for @loginPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in using your username and password'**
  String get loginPasswordSubtitle;

  /// No description provided for @loginOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in using OTP verification'**
  String get loginOtpSubtitle;

  /// No description provided for @loginModePassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginModePassword;

  /// No description provided for @loginModeOtp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get loginModeOtp;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get loginUsernameLabel;

  /// No description provided for @loginUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter username or email'**
  String get loginUsernameHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get loginPasswordHint;

  /// No description provided for @loginSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginSigningIn;

  /// No description provided for @loginCountryCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get loginCountryCodeLabel;

  /// No description provided for @loginCountryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'+91'**
  String get loginCountryCodeHint;

  /// No description provided for @loginPhoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get loginPhoneNumberLabel;

  /// No description provided for @loginPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'9876543210'**
  String get loginPhoneNumberHint;

  /// No description provided for @loginEmailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get loginEmailOptionalLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'student@example.com'**
  String get loginEmailHint;

  /// No description provided for @loginGenerateOtp.
  ///
  /// In en, this message translates to:
  /// **'Generate OTP'**
  String get loginGenerateOtp;

  /// No description provided for @loginSendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get loginSendingOtp;

  /// No description provided for @loginOtpCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get loginOtpCodeLabel;

  /// No description provided for @loginOtpCodeHint.
  ///
  /// In en, this message translates to:
  /// **'1234'**
  String get loginOtpCodeHint;

  /// No description provided for @loginVerifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get loginVerifyOtp;

  /// No description provided for @loginVerifyingOtp.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get loginVerifyingOtp;

  /// No description provided for @loginOtpSentInfo.
  ///
  /// In en, this message translates to:
  /// **'OTP sent. Enter the code to continue.'**
  String get loginOtpSentInfo;

  /// No description provided for @loginErrorUsernamePasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Username and password are required.'**
  String get loginErrorUsernamePasswordRequired;

  /// No description provided for @loginErrorOtpIdentityRequired.
  ///
  /// In en, this message translates to:
  /// **'Country code and phone number are required for OTP.'**
  String get loginErrorOtpIdentityRequired;

  /// No description provided for @loginErrorPhoneOtpRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number and OTP are required.'**
  String get loginErrorPhoneOtpRequired;

  /// No description provided for @loginErrorGenericRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete request. Please try again.'**
  String get loginErrorGenericRequest;

  /// No description provided for @loginErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get loginErrorInvalidCredentials;

  /// No description provided for @loginErrorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check and correct the entered fields.'**
  String get loginErrorValidation;

  /// No description provided for @loginErrorThrottled.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait before retrying.'**
  String get loginErrorThrottled;

  /// No description provided for @loginErrorLockout.
  ///
  /// In en, this message translates to:
  /// **'This account is locked. Contact your administrator.'**
  String get loginErrorLockout;

  /// No description provided for @loginErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Check your internet connection.'**
  String get loginErrorNetwork;

  /// No description provided for @loginErrorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again shortly.'**
  String get loginErrorServer;

  /// A welcome message for the user
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cortex'**
  String get welcomeMessage;

  /// No description provided for @courseLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Cortex'**
  String get courseLibraryTitle;

  /// No description provided for @courseLibrarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Course Library'**
  String get courseLibrarySubtitle;

  /// No description provided for @course_1_title.
  ///
  /// In en, this message translates to:
  /// **'Flutter Fundamentals'**
  String get course_1_title;

  /// No description provided for @course_1_description.
  ///
  /// In en, this message translates to:
  /// **'Master the basics of Flutter development with hands-on projects and real-world examples.'**
  String get course_1_description;

  /// No description provided for @course_2_title.
  ///
  /// In en, this message translates to:
  /// **'Advanced State Management'**
  String get course_2_title;

  /// No description provided for @course_2_description.
  ///
  /// In en, this message translates to:
  /// **'Deep dive into state management patterns including Provider, Riverpod, and Bloc.'**
  String get course_2_description;

  /// No description provided for @course_3_title.
  ///
  /// In en, this message translates to:
  /// **'Custom Animations'**
  String get course_3_title;

  /// No description provided for @course_3_description.
  ///
  /// In en, this message translates to:
  /// **'Create stunning animations and transitions using Flutter\'s animation framework.'**
  String get course_3_description;

  /// No description provided for @course_4_title.
  ///
  /// In en, this message translates to:
  /// **'Firebase Integration'**
  String get course_4_title;

  /// No description provided for @course_4_description.
  ///
  /// In en, this message translates to:
  /// **'Build production-ready apps with Firebase authentication, Firestore, and cloud functions.'**
  String get course_4_description;

  /// No description provided for @course_5_title.
  ///
  /// In en, this message translates to:
  /// **'Testing Strategies'**
  String get course_5_title;

  /// No description provided for @course_5_description.
  ///
  /// In en, this message translates to:
  /// **'Write comprehensive unit, widget, and integration tests for bulletproof Flutter apps.'**
  String get course_5_description;

  /// No description provided for @course_6_title.
  ///
  /// In en, this message translates to:
  /// **'Performance Optimization'**
  String get course_6_title;

  /// No description provided for @course_6_description.
  ///
  /// In en, this message translates to:
  /// **'Optimize your Flutter apps for smooth 60fps performance on all devices.'**
  String get course_6_description;

  /// No description provided for @labelStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get labelStart;

  /// No description provided for @labelContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get labelContinue;

  /// No description provided for @labelRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get labelRetry;

  /// No description provided for @labelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get labelLoading;

  /// No description provided for @labelProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get labelProgress;

  /// Label for the resume button on cards
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get labelResume;

  /// No description provided for @labelCourseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course progress'**
  String get labelCourseProgress;

  /// No description provided for @homeHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'BrightMinds Academy'**
  String get homeHeaderTitle;

  /// No description provided for @todayScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todayScheduleTitle;

  /// No description provided for @viewAllAction.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAllAction;

  /// No description provided for @nowAndNextSection.
  ///
  /// In en, this message translates to:
  /// **'NOW & NEXT'**
  String get nowAndNextSection;

  /// No description provided for @deadlinesSection.
  ///
  /// In en, this message translates to:
  /// **'DEADLINES'**
  String get deadlinesSection;

  /// No description provided for @upcomingTestsSection.
  ///
  /// In en, this message translates to:
  /// **'UPCOMING TESTS'**
  String get upcomingTestsSection;

  /// No description provided for @laterTodaySection.
  ///
  /// In en, this message translates to:
  /// **'LATER TODAY'**
  String get laterTodaySection;

  /// No description provided for @topLearnersTitle.
  ///
  /// In en, this message translates to:
  /// **'Top Learners This Week'**
  String get topLearnersTitle;

  /// No description provided for @updatesAnnouncementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates & Announcements'**
  String get updatesAnnouncementsTitle;

  /// No description provided for @quickAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccessTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @shortcutRecordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get shortcutRecordings;

  /// No description provided for @shortcutPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get shortcutPractice;

  /// No description provided for @shortcutTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get shortcutTests;

  /// No description provided for @shortcutNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get shortcutNotes;

  /// No description provided for @shortcutAskDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask Doubt'**
  String get shortcutAskDoubt;

  /// No description provided for @shortcutSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get shortcutSchedule;

  /// No description provided for @learningPerformanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning Performance'**
  String get learningPerformanceTitle;

  /// No description provided for @profileLearningSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Your learning at a glance'**
  String get profileLearningSnapshotTitle;

  /// No description provided for @profileActiveCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your active courses'**
  String get profileActiveCoursesTitle;

  /// No description provided for @profileRecentLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Your recent learning'**
  String get profileRecentLearningTitle;

  /// No description provided for @profileAccountSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & preferences'**
  String get profileAccountSettingsTitle;

  /// No description provided for @profileEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditProfile;

  /// No description provided for @profileNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @notificationsManagePreferences.
  ///
  /// In en, this message translates to:
  /// **'Manage your notification preferences'**
  String get notificationsManagePreferences;

  /// No description provided for @notificationsLiveClassReminders.
  ///
  /// In en, this message translates to:
  /// **'Live class reminders'**
  String get notificationsLiveClassReminders;

  /// No description provided for @notificationsLiveClassRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified before your live classes start'**
  String get notificationsLiveClassRemindersDesc;

  /// No description provided for @notificationsTestAssessmentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Test and assessment alerts'**
  String get notificationsTestAssessmentAlerts;

  /// No description provided for @notificationsTestAssessmentAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminders for upcoming tests and deadlines'**
  String get notificationsTestAssessmentAlertsDesc;

  /// No description provided for @notificationsAnnouncementsUpdates.
  ///
  /// In en, this message translates to:
  /// **'Announcements and updates'**
  String get notificationsAnnouncementsUpdates;

  /// No description provided for @notificationsAnnouncementsUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Important news and platform updates'**
  String get notificationsAnnouncementsUpdatesDesc;

  /// No description provided for @notificationsAchievementsBadges.
  ///
  /// In en, this message translates to:
  /// **'Achievements and badges'**
  String get notificationsAchievementsBadges;

  /// No description provided for @notificationsAchievementsBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'Celebrate when you earn achievements'**
  String get notificationsAchievementsBadgesDesc;

  /// No description provided for @notificationsStateOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get notificationsStateOn;

  /// No description provided for @notificationsStateOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get notificationsStateOff;

  /// No description provided for @profileCertificates.
  ///
  /// In en, this message translates to:
  /// **'Your certificates'**
  String get profileCertificates;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// No description provided for @logoutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmationTitle;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to log in again to access your account'**
  String get logoutConfirmationMessage;

  /// No description provided for @logoutButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutButtonLabel;

  /// No description provided for @certificatesSubtitleAvailable.
  ///
  /// In en, this message translates to:
  /// **'View and download your course completion certificates'**
  String get certificatesSubtitleAvailable;

  /// No description provided for @certificatesEmptyPaidNewDesc.
  ///
  /// In en, this message translates to:
  /// **'No certificates available yet'**
  String get certificatesEmptyPaidNewDesc;

  /// No description provided for @certificatesLockedBadge.
  ///
  /// In en, this message translates to:
  /// **'COMPLETE COURSE TO UNLOCK'**
  String get certificatesLockedBadge;

  /// No description provided for @certificatesUnlockedBadge.
  ///
  /// In en, this message translates to:
  /// **'CERTIFICATE OF COMPLETION'**
  String get certificatesUnlockedBadge;

  /// No description provided for @certificatesCourseProgress.
  ///
  /// In en, this message translates to:
  /// **'Course progress'**
  String get certificatesCourseProgress;

  /// No description provided for @certificatesKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep going to unlock your certificate'**
  String get certificatesKeepGoing;

  /// No description provided for @certificatesContinueCourse.
  ///
  /// In en, this message translates to:
  /// **'Continue Course'**
  String get certificatesContinueCourse;

  /// No description provided for @certificatesCompletedOn.
  ///
  /// In en, this message translates to:
  /// **'Completed on {date}'**
  String certificatesCompletedOn(String date);

  /// No description provided for @certificatesCertificateId.
  ///
  /// In en, this message translates to:
  /// **'Certificate ID'**
  String get certificatesCertificateId;

  /// No description provided for @certificatesViewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View Certificate'**
  String get certificatesViewCertificate;

  /// No description provided for @certificatesDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get certificatesDownload;

  /// No description provided for @certificatesPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Certificate Preview'**
  String get certificatesPreviewTitle;

  /// No description provided for @certificatesShareAchievementTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your achievement'**
  String get certificatesShareAchievementTitle;

  /// No description provided for @certificatesShareAchievementDescription.
  ///
  /// In en, this message translates to:
  /// **'Download or share this certificate to showcase your accomplishment'**
  String get certificatesShareAchievementDescription;

  /// No description provided for @certificatesShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get certificatesShare;

  /// No description provided for @certificatesHelpText.
  ///
  /// In en, this message translates to:
  /// **'This certificate is digitally signed and can be verified using the certificate ID'**
  String get certificatesHelpText;

  /// No description provided for @certificatesCertificateOfCompletion.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Completion'**
  String get certificatesCertificateOfCompletion;

  /// No description provided for @certificatesCertifyLine.
  ///
  /// In en, this message translates to:
  /// **'This is to certify that'**
  String get certificatesCertifyLine;

  /// No description provided for @certificatesCompletedCourseLine.
  ///
  /// In en, this message translates to:
  /// **'has successfully completed the course'**
  String get certificatesCompletedCourseLine;

  /// No description provided for @certificatesAwardedOn.
  ///
  /// In en, this message translates to:
  /// **'Awarded on {date}'**
  String certificatesAwardedOn(String date);

  /// No description provided for @certificatesVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get certificatesVerified;

  /// No description provided for @activityStatusStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get activityStatusStarted;

  /// No description provided for @activityScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}%'**
  String activityScoreLabel(int score);

  /// No description provided for @activityProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{progress}% watched so far'**
  String activityProgressLabel(int progress);

  /// No description provided for @homeTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTabTitle;

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

  /// Label showing when the user joined
  ///
  /// In en, this message translates to:
  /// **'Learning with us since {date}'**
  String profileMembershipLabel(String date);

  /// No description provided for @latestActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Latest Activity'**
  String get latestActivityLabel;

  /// No description provided for @streakMomentumLabel.
  ///
  /// In en, this message translates to:
  /// **'{days}-day momentum'**
  String streakMomentumLabel(int days);

  /// No description provided for @weeklyHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'{hours}h this week'**
  String weeklyHoursLabel(String hours);

  /// No description provided for @lessonsFinishedLabel.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsFinishedLabel;

  /// No description provided for @testsAttemptedLabel.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get testsAttemptedLabel;

  /// No description provided for @assessmentsDoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get assessmentsDoneLabel;

  /// No description provided for @strongestSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'YOU\'RE STRONGEST IN'**
  String get strongestSubjectLabel;

  /// No description provided for @weakSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'NEED FOCUS HERE'**
  String get weakSubjectLabel;

  /// No description provided for @noActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'No study activity yet'**
  String get noActivityTitle;

  /// No description provided for @noActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with a session to build momentum'**
  String get noActivitySubtitle;

  /// No description provided for @allCaughtUpTitle.
  ///
  /// In en, this message translates to:
  /// **'All Caught Up!'**
  String get allCaughtUpTitle;

  /// No description provided for @noScheduledActivitiesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'No scheduled activities right now'**
  String get noScheduledActivitiesSubtitle;

  /// No description provided for @liveLabel.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get liveLabel;

  /// No description provided for @importantLabel.
  ///
  /// In en, this message translates to:
  /// **'IMPORTANT'**
  String get importantLabel;

  /// No description provided for @testTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'{type} Test'**
  String testTypeLabel(String type);

  /// No description provided for @coursesCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} courses'**
  String coursesCompletedLabel(int count);

  /// No description provided for @streakDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String streakDaysLabel(int count);

  /// No description provided for @achievementsLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsLabel;

  /// No description provided for @moreBadgesLabel.
  ///
  /// In en, this message translates to:
  /// **'+{count} more'**
  String moreBadgesLabel(int count);

  /// No description provided for @drawerMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get drawerMenuTitle;

  /// No description provided for @drawerBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get drawerBookmark;

  /// No description provided for @drawerPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get drawerPosts;

  /// No description provided for @drawerAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get drawerAnalytics;

  /// No description provided for @drawerForum.
  ///
  /// In en, this message translates to:
  /// **'Forum'**
  String get drawerForum;

  /// No description provided for @drawerDoubts.
  ///
  /// In en, this message translates to:
  /// **'Doubts'**
  String get drawerDoubts;

  /// No description provided for @drawerCustomExam.
  ///
  /// In en, this message translates to:
  /// **'Custom Exam'**
  String get drawerCustomExam;

  /// No description provided for @drawerReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get drawerReports;

  /// No description provided for @drawerProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get drawerProfile;

  /// No description provided for @drawerSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get drawerSettings;

  /// No description provided for @drawerLoginActivity.
  ///
  /// In en, this message translates to:
  /// **'Login Activity'**
  String get drawerLoginActivity;

  /// No description provided for @drawerLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get drawerLogout;

  /// No description provided for @drawerPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get drawerPrivacy;

  /// No description provided for @drawerThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get drawerThemeLight;

  /// No description provided for @drawerThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get drawerThemeDark;

  /// No description provided for @drawerVersion.
  ///
  /// In en, this message translates to:
  /// **'Version - {version}'**
  String drawerVersion(String version);

  /// No description provided for @studyTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studyTabTitle;

  /// No description provided for @studySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search courses, chapters, lessons'**
  String get studySearchHint;

  /// No description provided for @studyYourCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Courses'**
  String get studyYourCoursesTitle;

  /// No description provided for @studyLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get studyLessonsTitle;

  /// No description provided for @filterVideo.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get filterVideo;

  /// No description provided for @filterLesson.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get filterLesson;

  /// No description provided for @filterAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get filterAssessment;

  /// No description provided for @filterTest.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get filterTest;

  /// No description provided for @resumeStudyHeader.
  ///
  /// In en, this message translates to:
  /// **'Resume Study'**
  String get resumeStudyHeader;

  /// No description provided for @labelCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get labelCompleted;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @errorGenericMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data. Please check your connection and try again.'**
  String get errorGenericMessage;

  /// No description provided for @labelLessonsPlural.
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get labelLessonsPlural;

  /// No description provided for @curriculumBackButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get curriculumBackButton;

  /// No description provided for @commonCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonCloseButton;

  /// No description provided for @curriculumChaptersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Chapters'**
  String curriculumChaptersCount(int count);

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @curriculumLessonsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get curriculumLessonsLabel;

  /// No description provided for @curriculumAssessmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Assessments'**
  String get curriculumAssessmentsLabel;

  /// No description provided for @curriculumTestsCompletedLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} tests completed'**
  String curriculumTestsCompletedLabel(Object count);

  /// No description provided for @chapterIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'Chapter {index}: {title}'**
  String chapterIndexLabel(int index, String title);

  /// No description provided for @chapterMetadata.
  ///
  /// In en, this message translates to:
  /// **'{lessons} {lessonsLabel} · {assessments} {assessmentsLabel}'**
  String chapterMetadata(
    int lessons,
    String lessonsLabel,
    int assessments,
    String assessmentsLabel,
  );

  /// No description provided for @statusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get statusLocked;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @chapterStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get chapterStatusRunning;

  /// No description provided for @chapterStatusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get chapterStatusUpcoming;

  /// No description provided for @chapterStatusHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get chapterStatusHistory;

  /// No description provided for @chapterTypeVideo.
  ///
  /// In en, this message translates to:
  /// **'Video Lesson'**
  String get chapterTypeVideo;

  /// No description provided for @chapterTypePdf.
  ///
  /// In en, this message translates to:
  /// **'PDF Notes'**
  String get chapterTypePdf;

  /// No description provided for @chapterTypeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Practice Assessment'**
  String get chapterTypeAssessment;

  /// No description provided for @chapterTypeTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get chapterTypeTest;

  /// No description provided for @chapterNoContent.
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get chapterNoContent;

  /// No description provided for @chapterNotFound.
  ///
  /// In en, this message translates to:
  /// **'Chapter not found'**
  String get chapterNotFound;

  /// No description provided for @lessonXofY.
  ///
  /// In en, this message translates to:
  /// **'Lesson {index} of {total}'**
  String lessonXofY(int index, int total);

  /// No description provided for @lessonBookmarkAdd.
  ///
  /// In en, this message translates to:
  /// **'Bookmark lesson'**
  String get lessonBookmarkAdd;

  /// No description provided for @lessonBookmarkRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get lessonBookmarkRemove;

  /// No description provided for @lessonDownload.
  ///
  /// In en, this message translates to:
  /// **'Download lesson'**
  String get lessonDownload;

  /// No description provided for @navigationPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get navigationPrevious;

  /// No description provided for @navigationNext.
  ///
  /// In en, this message translates to:
  /// **'Next Lesson'**
  String get navigationNext;

  /// No description provided for @openDetailedLesson.
  ///
  /// In en, this message translates to:
  /// **'Open lesson: {title}'**
  String openDetailedLesson(String title);

  /// No description provided for @videoLessonTabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get videoLessonTabNotes;

  /// No description provided for @videoLessonTabTranscript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get videoLessonTabTranscript;

  /// No description provided for @videoLessonTabAskDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask Doubt'**
  String get videoLessonTabAskDoubt;

  /// No description provided for @videoLessonTabAiSupport.
  ///
  /// In en, this message translates to:
  /// **'AI Support'**
  String get videoLessonTabAiSupport;

  /// No description provided for @videoLessonLectureNotes.
  ///
  /// In en, this message translates to:
  /// **'Lecture Notes'**
  String get videoLessonLectureNotes;

  /// No description provided for @videoLessonDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get videoLessonDownloadPdf;

  /// No description provided for @videoLessonKeyFormula.
  ///
  /// In en, this message translates to:
  /// **'Key Formula'**
  String get videoLessonKeyFormula;

  /// No description provided for @videoLessonTranscript.
  ///
  /// In en, this message translates to:
  /// **'Video Transcript'**
  String get videoLessonTranscript;

  /// No description provided for @videoLessonContinueNext.
  ///
  /// In en, this message translates to:
  /// **'Continue to Next Lesson'**
  String get videoLessonContinueNext;

  /// No description provided for @videoLessonAskYourDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Doubt'**
  String get videoLessonAskYourDoubt;

  /// No description provided for @videoLessonDoubtDescription.
  ///
  /// In en, this message translates to:
  /// **'Have a question about this lecture? Our expert instructors will answer within 24 hours.'**
  String get videoLessonDoubtDescription;

  /// No description provided for @videoLessonRecentDoubts.
  ///
  /// In en, this message translates to:
  /// **'Recent Doubts'**
  String get videoLessonRecentDoubts;

  /// No description provided for @videoLessonPostYourDoubt.
  ///
  /// In en, this message translates to:
  /// **'Post Your Doubt'**
  String get videoLessonPostYourDoubt;

  /// No description provided for @videoLessonDoubtHint.
  ///
  /// In en, this message translates to:
  /// **'Type your question here... Be specific about what you\'re confused about.'**
  String get videoLessonDoubtHint;

  /// No description provided for @videoLessonCharacterCount.
  ///
  /// In en, this message translates to:
  /// **'{current}/{max} characters'**
  String videoLessonCharacterCount(int current, int max);

  /// No description provided for @videoLessonSubmitDoubt.
  ///
  /// In en, this message translates to:
  /// **'Submit Doubt'**
  String get videoLessonSubmitDoubt;

  /// No description provided for @videoLessonPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get videoLessonPending;

  /// No description provided for @videoLessonAiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Study Assistant'**
  String get videoLessonAiAssistant;

  /// No description provided for @videoLessonAiHelp.
  ///
  /// In en, this message translates to:
  /// **'Get instant help with your questions'**
  String get videoLessonAiHelp;

  /// No description provided for @videoLessonAiHint.
  ///
  /// In en, this message translates to:
  /// **'Ask AI anything about this lecture...'**
  String get videoLessonAiHint;

  /// No description provided for @videoLessonAiDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'AI responses are generated instantly and based on lecture content'**
  String get videoLessonAiDisclaimer;

  /// No description provided for @testExit.
  ///
  /// In en, this message translates to:
  /// **'Exit Test'**
  String get testExit;

  /// No description provided for @testTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String testTimeLeft(Object time);

  /// No description provided for @testQuestionXofY.
  ///
  /// In en, this message translates to:
  /// **'Question {index} of {total}'**
  String testQuestionXofY(int index, int total);

  /// No description provided for @testSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get testSaved;

  /// No description provided for @testMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked'**
  String get testMarked;

  /// No description provided for @testMarkForReview.
  ///
  /// In en, this message translates to:
  /// **'Mark for Review'**
  String get testMarkForReview;

  /// No description provided for @testPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get testPrevious;

  /// No description provided for @testNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get testNext;

  /// No description provided for @testFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get testFinish;

  /// No description provided for @testViewAllQuestions.
  ///
  /// In en, this message translates to:
  /// **'View All Questions ({answered}/{total} answered)'**
  String testViewAllQuestions(Object answered, Object total);

  /// No description provided for @testCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Complete!'**
  String get testCompleteTitle;

  /// No description provided for @testCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Great job! You\'ve completed the practice test.'**
  String get testCompleteSubtitle;

  /// No description provided for @testRetake.
  ///
  /// In en, this message translates to:
  /// **'Retake Test'**
  String get testRetake;

  /// No description provided for @testBackToChapter.
  ///
  /// In en, this message translates to:
  /// **'Back to Chapter'**
  String get testBackToChapter;

  /// No description provided for @testScorePercentage.
  ///
  /// In en, this message translates to:
  /// **'{percentage}%'**
  String testScorePercentage(Object percentage);

  /// No description provided for @testScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'{correct} out of {total} correct'**
  String testScoreSummary(Object correct, Object total);

  /// No description provided for @testPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Hey! Review Your Answers'**
  String get testPaletteTitle;

  /// No description provided for @testPaletteAnsweredCount.
  ///
  /// In en, this message translates to:
  /// **'{answered} of {total} answered'**
  String testPaletteAnsweredCount(Object answered, Object total);

  /// No description provided for @testStatusNotVisited.
  ///
  /// In en, this message translates to:
  /// **'Not visited'**
  String get testStatusNotVisited;

  /// No description provided for @testStatusAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get testStatusAnswered;

  /// No description provided for @testStatusMarked.
  ///
  /// In en, this message translates to:
  /// **'Marked'**
  String get testStatusMarked;

  /// No description provided for @testStatusAnsweredMarked.
  ///
  /// In en, this message translates to:
  /// **'Answered & Reviewed'**
  String get testStatusAnsweredMarked;

  /// No description provided for @testAttemptXofY.
  ///
  /// In en, this message translates to:
  /// **'Attempt {index} of {total}'**
  String testAttemptXofY(int index, int total);

  /// No description provided for @testSelectAllApply.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply'**
  String get testSelectAllApply;

  /// No description provided for @testSubmitConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Test?'**
  String get testSubmitConfirmationTitle;

  /// No description provided for @testSubmitConfirmationBody.
  ///
  /// In en, this message translates to:
  /// **'You have answered {answered} out of {total} questions.'**
  String testSubmitConfirmationBody(int answered, int total);

  /// No description provided for @testSubmitConfirmationUnanswered.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All questions answered} =1{1 question remains unanswered} other{{count} questions remain unanswered}}'**
  String testSubmitConfirmationUnanswered(int count);

  /// No description provided for @labelCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get labelCancel;

  /// No description provided for @labelSubmitNow.
  ///
  /// In en, this message translates to:
  /// **'Submit Now'**
  String get labelSubmitNow;

  /// No description provided for @testSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Test Submitted!'**
  String get testSubmittedTitle;

  /// No description provided for @testSubmittedBody.
  ///
  /// In en, this message translates to:
  /// **'Your test has been successfully submitted. Review your answers or view detailed analytics.'**
  String get testSubmittedBody;

  /// No description provided for @testReviewAnswers.
  ///
  /// In en, this message translates to:
  /// **'Review Answers'**
  String get testReviewAnswers;

  /// No description provided for @testViewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get testViewAnalytics;

  /// No description provided for @assessmentCheckAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get assessmentCheckAnswer;

  /// No description provided for @assessmentCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get assessmentCorrect;

  /// No description provided for @assessmentIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Not quite right'**
  String get assessmentIncorrect;

  /// No description provided for @assessmentTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get assessmentTryAgain;

  /// No description provided for @assessmentNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get assessmentNext;

  /// No description provided for @assessmentExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get assessmentExplanation;

  /// No description provided for @assessmentPracticeComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice Assessment Complete!'**
  String get assessmentPracticeComplete;

  /// No description provided for @assessmentExit.
  ///
  /// In en, this message translates to:
  /// **'Exit Assessment'**
  String get assessmentExit;

  /// No description provided for @assessmentPaletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Question Palette'**
  String get assessmentPaletteTitle;

  /// No description provided for @assessmentUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get assessmentUnanswered;

  /// No description provided for @assessmentBackToChapter.
  ///
  /// In en, this message translates to:
  /// **'Back to Chapter'**
  String get assessmentBackToChapter;

  /// No description provided for @examReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Review'**
  String get examReviewTitle;

  /// No description provided for @examReviewFilterWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get examReviewFilterWrong;

  /// No description provided for @examReviewFilterCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get examReviewFilterCorrect;

  /// No description provided for @examReviewFilterUnanswered.
  ///
  /// In en, this message translates to:
  /// **'Unanswered'**
  String get examReviewFilterUnanswered;

  /// No description provided for @examReviewCorrectAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer:'**
  String get examReviewCorrectAnswerLabel;

  /// No description provided for @examReviewYourAnswerLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Answer:'**
  String get examReviewYourAnswerLabel;

  /// No description provided for @examReviewFilterAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get examReviewFilterAnswered;

  /// No description provided for @labelAskDoubt.
  ///
  /// In en, this message translates to:
  /// **'Ask Doubt'**
  String get labelAskDoubt;

  /// No description provided for @labelComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get labelComment;

  /// No description provided for @labelReport.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get labelReport;

  /// No description provided for @labelOverallSummary.
  ///
  /// In en, this message translates to:
  /// **'Overall Summary'**
  String get labelOverallSummary;

  /// No description provided for @labelFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter:'**
  String get labelFilter;

  /// No description provided for @labelAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get labelAccuracy;

  /// No description provided for @labelScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get labelScore;

  /// No description provided for @labelTimeTaken.
  ///
  /// In en, this message translates to:
  /// **'Time Taken'**
  String get labelTimeTaken;

  /// No description provided for @labelPercentile.
  ///
  /// In en, this message translates to:
  /// **'Percentile'**
  String get labelPercentile;

  /// No description provided for @labelRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get labelRank;

  /// No description provided for @labelPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get labelPerformance;

  /// No description provided for @labelSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get labelSubject;

  /// No description provided for @labelAttempted.
  ///
  /// In en, this message translates to:
  /// **'Attempted'**
  String get labelAttempted;

  /// No description provided for @labelTotalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get labelTotalQuestions;

  /// No description provided for @performanceExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get performanceExcellent;

  /// No description provided for @performanceGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get performanceGood;

  /// No description provided for @performanceAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get performanceAverage;

  /// No description provided for @performancePoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get performancePoor;

  /// No description provided for @recommendationHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get recommendationHigh;

  /// No description provided for @recommendationMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get recommendationMedium;

  /// No description provided for @recommendationLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get recommendationLow;

  /// No description provided for @reviewAskDoubtTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a Doubt'**
  String get reviewAskDoubtTitle;

  /// No description provided for @reviewSubmitDoubt.
  ///
  /// In en, this message translates to:
  /// **'Submit Doubt'**
  String get reviewSubmitDoubt;

  /// No description provided for @reviewAddCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Comment'**
  String get reviewAddCommentTitle;

  /// No description provided for @reviewPostComment.
  ///
  /// In en, this message translates to:
  /// **'Post Comment'**
  String get reviewPostComment;

  /// No description provided for @reviewReportIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get reviewReportIssueTitle;

  /// No description provided for @reviewSubmitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get reviewSubmitReport;

  /// No description provided for @reviewReportIssueWithQuestion.
  ///
  /// In en, this message translates to:
  /// **'Report an issue with Question {number}'**
  String reviewReportIssueWithQuestion(int number);

  /// No description provided for @reviewDescribeDoubtHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your doubt here...'**
  String get reviewDescribeDoubtHint;

  /// No description provided for @reviewWriteCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write your comment...'**
  String get reviewWriteCommentHint;

  /// No description provided for @reviewReportOptionIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer marked as correct'**
  String get reviewReportOptionIncorrect;

  /// No description provided for @reviewReportOptionUnclear.
  ///
  /// In en, this message translates to:
  /// **'Question is unclear'**
  String get reviewReportOptionUnclear;

  /// No description provided for @reviewReportOptionWrongExplanation.
  ///
  /// In en, this message translates to:
  /// **'Explanation is wrong'**
  String get reviewReportOptionWrongExplanation;

  /// No description provided for @reviewReportOptionOther.
  ///
  /// In en, this message translates to:
  /// **'Other issue'**
  String get reviewReportOptionOther;

  /// No description provided for @reviewReportDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Additional details (optional)...'**
  String get reviewReportDetailsHint;

  /// No description provided for @reviewShareThoughtsOnQuestion.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts on Question {number}'**
  String reviewShareThoughtsOnQuestion(int number);

  /// No description provided for @reviewQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String reviewQuestionLabel(String number);

  /// No description provided for @reviewEmptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'No questions found for this filter.'**
  String get reviewEmptyStateMessage;

  /// No description provided for @reviewAnswersTitle.
  ///
  /// In en, this message translates to:
  /// **'Review Answers - {title}'**
  String reviewAnswersTitle(String title);

  /// No description provided for @reviewQuestionCount.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String reviewQuestionCount(int current, int total);

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsPlaybackTitle.
  ///
  /// In en, this message translates to:
  /// **'Learning & Playback'**
  String get settingsPlaybackTitle;

  /// No description provided for @settingsAccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibilityTitle;

  /// No description provided for @settingsVideoQuality.
  ///
  /// In en, this message translates to:
  /// **'Video quality'**
  String get settingsVideoQuality;

  /// No description provided for @settingsVideoQualityCaption.
  ///
  /// In en, this message translates to:
  /// **'Set your preferred default quality'**
  String get settingsVideoQualityCaption;

  /// No description provided for @settingsAutoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto-play next lesson'**
  String get settingsAutoPlay;

  /// No description provided for @settingsTextSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get settingsTextSize;

  /// No description provided for @settingsHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get settingsHighContrast;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize your learning experience'**
  String get settingsDescription;

  /// No description provided for @settingsThemeLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get settingsThemeLightMode;

  /// No description provided for @settingsThemeDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsThemeDarkMode;

  /// No description provided for @settingsThemeSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsThemeSystemDefault;

  /// No description provided for @settingsPlaybackDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose playback quality'**
  String get settingsPlaybackDescription;

  /// No description provided for @settingsTextSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust reading comfort'**
  String get settingsTextSizeDescription;

  /// No description provided for @settingsRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get settingsRecommended;

  /// No description provided for @settingsDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get settingsDefault;

  /// No description provided for @settingsAutoPlaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatically start the next lesson'**
  String get settingsAutoPlaySubtitle;

  /// No description provided for @settingsHighContrastSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Increase visual contrast'**
  String get settingsHighContrastSubtitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileNameLabel;

  /// No description provided for @editProfileNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get editProfileNameHint;

  /// No description provided for @editProfileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get editProfileEmailLabel;

  /// No description provided for @editProfileEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get editProfileEmailHint;

  /// No description provided for @editProfileEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed'**
  String get editProfileEmailHelper;

  /// No description provided for @editProfilePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get editProfilePhoneLabel;

  /// No description provided for @editProfilePhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get editProfilePhoneHint;

  /// No description provided for @editProfileSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editProfileSave;

  /// No description provided for @editProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get editProfileSuccess;

  /// No description provided for @editProfileErrorNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get editProfileErrorNameEmpty;

  /// No description provided for @editProfilePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get editProfilePhotoLabel;

  /// No description provided for @editProfileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get editProfileChangePhoto;

  /// No description provided for @editProfileBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get editProfileBack;

  /// No description provided for @exploreTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreTabTitle;

  /// No description provided for @exploreSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search courses, lessons, topics...'**
  String get exploreSearchHint;

  /// No description provided for @exploreSearchResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get exploreSearchResultsTitle;

  /// No description provided for @exploreTrendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get exploreTrendingTitle;

  /// No description provided for @exploreRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended For You'**
  String get exploreRecommendedTitle;

  /// No description provided for @exploreShortLessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed Videos'**
  String get exploreShortLessonsTitle;

  /// No description provided for @explorePopularTestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Popular Tests'**
  String get explorePopularTestsTitle;

  /// No description provided for @exploreStudyTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Study Tips & Updates'**
  String get exploreStudyTipsTitle;

  /// No description provided for @exploreFilterTrending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get exploreFilterTrending;

  /// No description provided for @exploreFilterRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get exploreFilterRecommended;

  /// No description provided for @exploreFilterShortLessons.
  ///
  /// In en, this message translates to:
  /// **'Short Lessons'**
  String get exploreFilterShortLessons;

  /// No description provided for @exploreFilterPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get exploreFilterPopular;

  /// No description provided for @exploreFilterStudyTips.
  ///
  /// In en, this message translates to:
  /// **'Study Tips'**
  String get exploreFilterStudyTips;

  /// No description provided for @labelMock.
  ///
  /// In en, this message translates to:
  /// **'Mock'**
  String get labelMock;

  /// No description provided for @labelPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get labelPractice;

  /// No description provided for @aiAssistantTabTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Support'**
  String get aiAssistantTabTitle;

  /// No description provided for @aiAssistantGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi {userName} 👋'**
  String aiAssistantGreeting(String userName);

  /// No description provided for @aiAssistantStudyInsight.
  ///
  /// In en, this message translates to:
  /// **'{insight}'**
  String aiAssistantStudyInsight(String insight);

  /// No description provided for @aiAssistantQuickActions.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACTIONS'**
  String get aiAssistantQuickActions;

  /// No description provided for @aiAssistantAskDoubtTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask a Doubt'**
  String get aiAssistantAskDoubtTitle;

  /// No description provided for @aiAssistantAskDoubtDesc.
  ///
  /// In en, this message translates to:
  /// **'Snap, upload or type your question'**
  String get aiAssistantAskDoubtDesc;

  /// No description provided for @aiAssistantPracticeExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Practice Exam'**
  String get aiAssistantPracticeExamTitle;

  /// No description provided for @aiAssistantPracticeExamDesc.
  ///
  /// In en, this message translates to:
  /// **'Create AI practice exams based on weak topics or chapters'**
  String get aiAssistantPracticeExamDesc;

  /// No description provided for @aiAssistantRecommendedTitle.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED FOR YOU'**
  String get aiAssistantRecommendedTitle;

  /// No description provided for @aiAssistantImproveTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Improve Weak Topics Today'**
  String get aiAssistantImproveTopicsTitle;

  /// No description provided for @aiAssistantStruggledTopicDesc.
  ///
  /// In en, this message translates to:
  /// **'You struggled in this topic recently'**
  String get aiAssistantStruggledTopicDesc;

  /// No description provided for @aiAssistantPracticeNow.
  ///
  /// In en, this message translates to:
  /// **'Practice Now'**
  String get aiAssistantPracticeNow;

  /// No description provided for @aiAssistantMoreTopicsTitle.
  ///
  /// In en, this message translates to:
  /// **'MORE TOPICS TO PRACTICE'**
  String get aiAssistantMoreTopicsTitle;

  /// No description provided for @aiAssistantRecentHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'RECENT HELP'**
  String get aiAssistantRecentHelpTitle;

  /// No description provided for @aiAssistantViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get aiAssistantViewAll;

  /// No description provided for @aiAssistantStatusAnswered.
  ///
  /// In en, this message translates to:
  /// **'Answered'**
  String get aiAssistantStatusAnswered;

  /// No description provided for @aiAssistantStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get aiAssistantStatusProcessing;

  /// No description provided for @aiAssistantStatusRevisit.
  ///
  /// In en, this message translates to:
  /// **'Revisit'**
  String get aiAssistantStatusRevisit;

  /// No description provided for @aiAssistantPoweredBy.
  ///
  /// In en, this message translates to:
  /// **'AI powered by your learning progress and exam performance'**
  String get aiAssistantPoweredBy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
