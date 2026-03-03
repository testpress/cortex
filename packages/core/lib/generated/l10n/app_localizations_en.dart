// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cortex SDK';

  @override
  String get loginButton => 'Login';

  @override
  String get welcomeMessage => 'Welcome to Cortex';

  @override
  String get courseLibraryTitle => 'Cortex';

  @override
  String get courseLibrarySubtitle => 'Course Library';

  @override
  String get course_1_title => 'Flutter Fundamentals';

  @override
  String get course_1_description =>
      'Master the basics of Flutter development with hands-on projects and real-world examples.';

  @override
  String get course_2_title => 'Advanced State Management';

  @override
  String get course_2_description =>
      'Deep dive into state management patterns including Provider, Riverpod, and Bloc.';

  @override
  String get course_3_title => 'Custom Animations';

  @override
  String get course_3_description =>
      'Create stunning animations and transitions using Flutter\'s animation framework.';

  @override
  String get course_4_title => 'Firebase Integration';

  @override
  String get course_4_description =>
      'Build production-ready apps with Firebase authentication, Firestore, and cloud functions.';

  @override
  String get course_5_title => 'Testing Strategies';

  @override
  String get course_5_description =>
      'Write comprehensive unit, widget, and integration tests for bulletproof Flutter apps.';

  @override
  String get course_6_title => 'Performance Optimization';

  @override
  String get course_6_description =>
      'Optimize your Flutter apps for smooth 60fps performance on all devices.';

  @override
  String get labelStart => 'Start';

  @override
  String get labelContinue => 'Continue';

  @override
  String get labelProgress => 'Progress';

  @override
  String get labelResume => 'Resume';

  @override
  String get labelCourseProgress => 'Course progress';

  @override
  String get homeHeaderTitle => 'BrightMinds Academy';

  @override
  String get todayScheduleTitle => 'Today\'s Schedule';

  @override
  String get viewAllAction => 'View all >';

  @override
  String get nowAndNextSection => 'NOW & NEXT';

  @override
  String get deadlinesSection => 'DEADLINES';

  @override
  String get upcomingTestsSection => 'UPCOMING TESTS';

  @override
  String get laterTodaySection => 'LATER TODAY';

  @override
  String get topLearnersTitle => 'Top Learners This Week';

  @override
  String get updatesAnnouncementsTitle => 'Updates & Announcements';

  @override
  String get quickAccessTitle => 'Quick Access';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get shortcutRecordings => 'Recordings';

  @override
  String get shortcutPractice => 'Practice';

  @override
  String get shortcutTests => 'Tests';

  @override
  String get shortcutNotes => 'Notes';

  @override
  String get shortcutAskDoubt => 'Ask Doubt';

  @override
  String get shortcutSchedule => 'Schedule';

  @override
  String get learningPerformanceTitle => 'Learning Performance';

  @override
  String get latestActivityLabel => 'Latest Activity';

  @override
  String streakMomentumLabel(int days) {
    return '$days-day momentum';
  }

  @override
  String weeklyHoursLabel(String hours) {
    return '${hours}h this week';
  }

  @override
  String get lessonsFinishedLabel => 'Lessons';

  @override
  String get testsAttemptedLabel => 'Tests';

  @override
  String get assessmentsDoneLabel => 'Assessments';

  @override
  String get strongestSubjectLabel => 'YOU\'RE STRONGEST IN';

  @override
  String get weakSubjectLabel => 'NEED FOCUS HERE';

  @override
  String get noActivityTitle => 'No study activity yet';

  @override
  String get noActivitySubtitle => 'Start with a session to build momentum';

  @override
  String get allCaughtUpTitle => 'All Caught Up!';

  @override
  String get noScheduledActivitiesSubtitle =>
      'No scheduled activities right now';

  @override
  String get liveLabel => 'LIVE';

  @override
  String get importantLabel => 'IMPORTANT';

  @override
  String testTypeLabel(String type) {
    return '$type TEST';
  }

  @override
  String coursesCompletedLabel(int count) {
    return '$count courses';
  }

  @override
  String streakDaysLabel(int count) {
    return '$count days';
  }

  @override
  String get achievementsLabel => 'Achievements';

  @override
  String moreBadgesLabel(int count) {
    return '+$count more';
  }

  @override
  String get drawerMenuTitle => 'Menu';

  @override
  String get drawerBookmark => 'Bookmark';

  @override
  String get drawerPosts => 'Posts';

  @override
  String get drawerAnalytics => 'Analytics';

  @override
  String get drawerForum => 'Forum';

  @override
  String get drawerDoubts => 'Doubts';

  @override
  String get drawerCustomExam => 'Custom Exam';

  @override
  String get drawerReports => 'Reports';

  @override
  String get drawerProfile => 'Profile';

  @override
  String get drawerSettings => 'App Settings';

  @override
  String get drawerLoginActivity => 'Login Activity';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get drawerPrivacy => 'Privacy Policy';

  @override
  String get drawerThemeLight => 'Light Mode';

  @override
  String get drawerThemeDark => 'Dark Mode';

  @override
  String drawerVersion(String version) {
    return 'Version - $version';
  }

  @override
  String get studyTabTitle => 'Study';

  @override
  String get studySearchHint => 'Search courses, chapters, lessons';

  @override
  String get studyYourCoursesTitle => 'Your Courses';

  @override
  String get studyLessonsTitle => 'Lessons';

  @override
  String get filterVideo => 'Videos';

  @override
  String get filterLesson => 'Lessons';

  @override
  String get filterAssessment => 'Assessments';

  @override
  String get filterTest => 'Tests';

  @override
  String get resumeStudyHeader => 'Resume Study';

  @override
  String get labelCompleted => 'completed';

  @override
  String get labelLessonsPlural => 'lessons';

  @override
  String get curriculumBackButton => 'Back';

  @override
  String curriculumChaptersCount(int count) {
    return '$count Chapters';
  }

  @override
  String get filterAll => 'All';

  @override
  String get curriculumLessonsLabel => 'Lessons';

  @override
  String get curriculumAssessmentsLabel => 'Assessments';

  @override
  String curriculumTestsCompletedLabel(Object count) {
    return '$count tests completed';
  }

  @override
  String chapterIndexLabel(int index, String title) {
    return 'Chapter $index: $title';
  }

  @override
  String chapterMetadata(
    int lessons,
    String lessonsLabel,
    int assessments,
    String assessmentsLabel,
  ) {
    return '$lessons $lessonsLabel · $assessments $assessmentsLabel';
  }

  @override
  String get statusLocked => 'Locked';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';
}
