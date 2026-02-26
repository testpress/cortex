// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appTitle => 'കോട്ടെക്സ് SDK';

  @override
  String get loginButton => 'ലോഗിൻ';

  @override
  String get welcomeMessage => 'കോട്ടെക്സിലേക്ക് സ്വാഗതം';

  @override
  String get courseLibraryTitle => 'കോട്ടെക്സ്';

  @override
  String get courseLibrarySubtitle => 'കോഴ്സ് ലൈബ്രറി';

  @override
  String get course_1_title => 'ഫ്ലട്ടർ അടിസ്ഥാനങ്ങൾ';

  @override
  String get course_1_description =>
      'പ്രോജക്റ്റുകളിലൂടെയും ഉദാഹരണങ്ങളിലൂടെയും ഫ്ലട്ടർ വികസനത്തിന്റെ അടിസ്ഥാന കാര്യങ്ങൾ പഠിക്കുക.';

  @override
  String get course_2_title => 'അഡ്വാൻസ്ഡ് സ്റ്റേറ്റ് മാനേജ്‌മെന്റ്';

  @override
  String get course_2_description =>
      'പ്രൊവൈഡർ, റിവർപോഡ്, ബ്ലോക്ക് തുടങ്ങിയ സ്റ്റേറ്റ് മാനേജ്‌മെന്റ് പാറ്റേണുകളെക്കുറിച്ച് ആഴത്തിൽ പഠിക്കുക.';

  @override
  String get course_3_title => 'കസ്റ്റം ആനിമേഷനുകൾ';

  @override
  String get course_3_description =>
      'ഫ്ലട്ടറിന്റെ ആനിമേഷൻ ചട്ടക്കൂട് ഉപയോഗിച്ച് ആകർഷകമായ ആനിമേഷനുകൾ നിർമ്മിക്കുക.';

  @override
  String get course_4_title => 'ഫയർബേസ് സംയോജനം';

  @override
  String get course_4_description =>
      'ഫയർബേസ് ഓതന്റിക്കേഷൻ, ഫയർസ്റ്റോർ എന്നിവ ഉപയോഗിച്ച് ആപ്പുകൾ നിർമ്മിക്കുക.';

  @override
  String get course_5_title => 'ടെസ്റ്റിംഗ് സ്ട്രാറ്റജികൾ';

  @override
  String get course_5_description =>
      'യൂണിറ്റ്, വിജറ്റ്, ഇന്റഗ്രേഷൻ ടെസ്റ്റുകൾ എങ്ങനെ എഴുതാമെന്ന് പഠിക്കുക.';

  @override
  String get course_6_title => 'പെർഫോമൻസ് ഓപ്റ്റിമൈസേഷൻ';

  @override
  String get course_6_description =>
      'എല്ലാ ഉപകരണങ്ങളിലും മികച്ച രീതിയിൽ പ്രവർത്തിക്കുന്നതിനായി നിങ്ങളുടെ ആപ്പുകൾ ഒപ്റ്റിമൈസ് ചെയ്യുക.';

  @override
  String get labelStart => 'തുടങ്ങുക';

  @override
  String get labelContinue => 'തുടരുക';

  @override
  String get labelProgress => 'പുരോഗതി';

  @override
  String get labelCourseProgress => 'കോഴ്സിന്റെ പുരോഗതി';

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
  String get drawerMenuTitle => 'മെനു';

  @override
  String get drawerBookmark => 'ബുക്ക്മാർക്ക്';

  @override
  String get drawerPosts => 'പോസ്റ്റുകൾ';

  @override
  String get drawerAnalytics => 'അനലിറ്റിക്സ്';

  @override
  String get drawerForum => 'ഫോറം';

  @override
  String get drawerDoubts => 'സംശയങ്ങൾ';

  @override
  String get drawerCustomExam => 'കസ്റ്റം എക്സാം';

  @override
  String get drawerReports => 'നിങ്ങളുടെ റിപ്പോർട്ട്';

  @override
  String get drawerProfile => 'പ്രൊഫൈൽ';

  @override
  String get drawerSettings => 'ആപ്പ് ക്രമീകരണങ്ങൾ';

  @override
  String get drawerLoginActivity => 'ലോഗിൻ ആക്റ്റിവിറ്റി';

  @override
  String get drawerLogout => 'ലോഗൗട്ട്';

  @override
  String get drawerPrivacy => 'സ്വകാര്യതാ നയം';

  @override
  String get drawerThemeLight => 'ലൈറ്റ് മോഡ്';

  @override
  String get drawerThemeDark => 'ഡാർക്ക് മോഡ്';

  @override
  String drawerVersion(String version) {
    return 'വേർഷൻ - $version';
  }
}
