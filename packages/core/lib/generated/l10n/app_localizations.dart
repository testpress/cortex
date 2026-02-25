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

  /// No description provided for @labelProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get labelProgress;

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
  /// **'View all >'**
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
  /// **'{type} TEST'**
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
