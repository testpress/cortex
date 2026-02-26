// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'كورتيكس SDK';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get welcomeMessage => 'مرحبًا بك في كورتيكس';

  @override
  String get courseLibraryTitle => 'كورتيكس';

  @override
  String get courseLibrarySubtitle => 'مكتبة الدورات';

  @override
  String get course_1_title => 'أساسيات فلاتر';

  @override
  String get course_1_description =>
      'أتقن أساسيات تطوير فلاتر من خلال مشاريع عملية وأمثلة واقعية.';

  @override
  String get course_2_title => 'إدارة الحالة المتقدمة';

  @override
  String get course_2_description =>
      'تعمق في أنماط إدارة الحالة بما في ذلك Provider و Riverpod و Bloc.';

  @override
  String get course_3_title => 'الرسوم المتحركة المخصصة';

  @override
  String get course_3_description =>
      'قم بإنشاء رسوم متحركة وانتقالات مذهلة باستخدام إطار عمل الرسوم المتحركة في فلاتر.';

  @override
  String get course_4_title => 'تكامل فايربيز';

  @override
  String get course_4_description =>
      'قم ببناء تطبيقات جاهزة للإنتاج باستخدام Firebase authentication و Firestore و cloud functions.';

  @override
  String get course_5_title => 'استراتيجيات الاختبار';

  @override
  String get course_5_description =>
      'اكتب اختبارات وحدة وويجيت وتكامل شاملة لتطبيقات فلاتر مضادة للرصاص.';

  @override
  String get course_6_title => 'تحسين الأداء';

  @override
  String get course_6_description =>
      'قم بتحسين تطبيقات فلاتر الخاصة بك للحصول على أداء سلس بمعدل 60 إطارًا في الثانية على جميع الأجهزة.';

  @override
  String get labelStart => 'ابدأ';

  @override
  String get labelContinue => 'استمر';

  @override
  String get labelProgress => 'تقدم';

  @override
  String get labelCourseProgress => 'تقدم الدورة';

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
  String get drawerMenuTitle => 'القائمة';

  @override
  String get drawerBookmark => 'الإشارات المرجعية';

  @override
  String get drawerPosts => 'المنشورات';

  @override
  String get drawerAnalytics => 'التحليلات';

  @override
  String get drawerForum => 'المنتدى';

  @override
  String get drawerDoubts => 'الأسئلة';

  @override
  String get drawerCustomExam => 'نموذج امتحان';

  @override
  String get drawerReports => 'التقارير الخاصة بك';

  @override
  String get drawerProfile => 'الملف الشخصي';

  @override
  String get drawerSettings => 'إعدادات التطبيق';

  @override
  String get drawerLoginActivity => 'نشاط تسجيل الدخول';

  @override
  String get drawerLogout => 'تسجيل الخروج';

  @override
  String get drawerPrivacy => 'سياسة الخصوصية';

  @override
  String get drawerThemeLight => 'الوضع الفاتح';

  @override
  String get drawerThemeDark => 'الوضع الداكن';

  @override
  String drawerVersion(String version) {
    return 'الإصدار - $version';
  }
}
