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

  /// No description provided for @profileTabTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTabTitle;

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
  String testQuestionXofY(Object index, Object total);

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
