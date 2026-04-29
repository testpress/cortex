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
  String get loginWelcomeBack => 'مرحبًا بعودتك';

  @override
  String get loginPasswordSubtitle =>
      'سجّل الدخول باستخدام اسم المستخدم وكلمة المرور';

  @override
  String get loginOtpSubtitle => 'سجّل الدخول باستخدام رمز التحقق';

  @override
  String get loginModePassword => 'كلمة المرور';

  @override
  String get loginModeOtp => 'رمز التحقق';

  @override
  String get loginUsernameLabel => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get loginUsernameHint => 'أدخل اسم المستخدم أو البريد الإلكتروني';

  @override
  String get loginPasswordLabel => 'كلمة المرور';

  @override
  String get loginPasswordHint => 'أدخل كلمة المرور';

  @override
  String get loginSigningIn => 'جارٍ تسجيل الدخول...';

  @override
  String get loginCountryCodeLabel => 'رمز الدولة';

  @override
  String get loginCountryCodeHint => '+91';

  @override
  String get loginPhoneNumberLabel => 'رقم الهاتف';

  @override
  String get loginPhoneNumberHint => '9876543210';

  @override
  String get loginEmailOptionalLabel => 'البريد الإلكتروني (اختياري)';

  @override
  String get loginEmailHint => 'student@example.com';

  @override
  String get loginGenerateOtp => 'إرسال رمز التحقق';

  @override
  String get loginSendingOtp => 'جارٍ إرسال رمز التحقق...';

  @override
  String get loginOtpCodeLabel => 'رمز التحقق';

  @override
  String get loginOtpCodeHint => '1234';

  @override
  String get loginVerifyOtp => 'تأكيد الرمز';

  @override
  String get loginVerifyingOtp => 'جارٍ التحقق...';

  @override
  String get loginOtpSentInfo => 'تم إرسال الرمز. أدخل الرمز للمتابعة.';

  @override
  String get loginErrorUsernamePasswordRequired =>
      'اسم المستخدم وكلمة المرور مطلوبان.';

  @override
  String get loginErrorOtpIdentityRequired =>
      'رمز الدولة ورقم الهاتف مطلوبان لرمز التحقق.';

  @override
  String get loginErrorPhoneOtpRequired => 'رقم الهاتف ورمز التحقق مطلوبان.';

  @override
  String get loginErrorGenericRequest =>
      'تعذر إكمال الطلب. يرجى المحاولة مرة أخرى.';

  @override
  String get loginErrorInvalidCredentials =>
      'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get loginErrorValidation => 'يرجى مراجعة الحقول المدخلة وتصحيحها.';

  @override
  String get loginErrorThrottled =>
      'محاولات كثيرة جدًا. يرجى الانتظار قبل إعادة المحاولة.';

  @override
  String get loginErrorLockout => 'تم قفل هذا الحساب. يرجى التواصل مع المسؤول.';

  @override
  String get loginErrorNetwork =>
      'خطأ في الشبكة. يرجى التحقق من اتصال الإنترنت.';

  @override
  String get loginErrorServer => 'خطأ في الخادم. يرجى المحاولة بعد قليل.';

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
  String get labelRetry => 'إعادة المحاولة';

  @override
  String get labelLoading => 'جاري التحميل...';

  @override
  String get labelProgress => 'تقدم';

  @override
  String get labelResume => 'استئناف';

  @override
  String get labelCourseProgress => 'تقدم الدورة';

  @override
  String get homeHeaderTitle => 'أكاديمية برايت ماينز';

  @override
  String get todayScheduleTitle => 'جدول اليوم';

  @override
  String get viewAllAction => 'عرض الكل >';

  @override
  String get nowAndNextSection => 'الآن وبعد قليل';

  @override
  String get deadlinesSection => 'المواعيد النهائية';

  @override
  String get upcomingTestsSection => 'الاختبارات القادمة';

  @override
  String get laterTodaySection => 'في وقت لاحق اليوم';

  @override
  String get topLearnersTitle => 'أفضل المتعلمين هذا الأسبوع';

  @override
  String get updatesAnnouncementsTitle => 'التحديثات والإعلانات';

  @override
  String get quickAccessTitle => 'الوصول السريع';

  @override
  String get greetingMorning => 'صباح الخير';

  @override
  String get greetingAfternoon => 'مساء الخير';

  @override
  String get greetingEvening => 'مساء الخير';

  @override
  String get shortcutRecordings => 'التسجيلات';

  @override
  String get shortcutPractice => 'الممارسة';

  @override
  String get shortcutTests => 'الاختبارات';

  @override
  String get shortcutNotes => 'الملاحظات';

  @override
  String get shortcutAskDoubt => 'اسأل شكوك';

  @override
  String get shortcutSchedule => 'الجدول';

  @override
  String get learningPerformanceTitle => 'أداء التعلم';

  @override
  String get profileLearningSnapshotTitle => 'لمحة عن تعلمك';

  @override
  String get profileActiveCoursesTitle => 'كورساتك النشطة';

  @override
  String get profileRecentLearningTitle => 'تعلمك الأخير';

  @override
  String get profileAccountSettingsTitle => 'الحساب والتفضيلات';

  @override
  String get profileEditProfile => 'تعديل الملف الشخصي';

  @override
  String get profileNotifications => 'التنبيهات';

  @override
  String get notificationsManagePreferences =>
      'إدارة تفضيلات التنبيهات الخاصة بك';

  @override
  String get notificationsLiveClassReminders => 'تذكيرات الحصص المباشرة';

  @override
  String get notificationsLiveClassRemindersDesc =>
      'تلقي تنبيه قبل بدء الحصص المباشرة';

  @override
  String get notificationsTestAssessmentAlerts =>
      'تنبيهات الاختبارات والتقييمات';

  @override
  String get notificationsTestAssessmentAlertsDesc =>
      'تذكيرات بالاختبارات والمواعيد القادمة';

  @override
  String get notificationsAnnouncementsUpdates => 'الإعلانات والتحديثات';

  @override
  String get notificationsAnnouncementsUpdatesDesc =>
      'أخبار مهمة وتحديثات المنصة';

  @override
  String get notificationsAchievementsBadges => 'الإنجازات والشارات';

  @override
  String get notificationsAchievementsBadgesDesc =>
      'احتفل عند حصولك على إنجاز جديد';

  @override
  String get notificationsStateOn => 'مفعل';

  @override
  String get notificationsStateOff => 'غير مفعل';

  @override
  String get profileCertificates => 'شهاداتك';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get logoutConfirmationTitle => 'هل تريد تسجيل الخروج؟';

  @override
  String get logoutConfirmationMessage =>
      'ستحتاج إلى تسجيل الدخول مرة أخرى للوصول إلى حسابك';

  @override
  String get logoutButtonLabel => 'تسجيل الخروج';

  @override
  String get certificatesSubtitleAvailable =>
      'اعرض وحمّل شهادات إكمال الدورات الخاصة بك';

  @override
  String get certificatesEmptyPaidNewDesc => 'لا توجد شهادات متاحة بعد';

  @override
  String get certificatesLockedBadge => 'أكمل الدورة لفتح الشهادة';

  @override
  String get certificatesUnlockedBadge => 'شهادة إكمال';

  @override
  String get certificatesCourseProgress => 'تقدم الدورة';

  @override
  String get certificatesKeepGoing => 'واصل التقدم لفتح شهادتك';

  @override
  String get certificatesContinueCourse => 'متابعة الدورة';

  @override
  String certificatesCompletedOn(String date) {
    return 'اكتملت في $date';
  }

  @override
  String get certificatesCertificateId => 'معرّف الشهادة';

  @override
  String get certificatesViewCertificate => 'عرض الشهادة';

  @override
  String get certificatesDownload => 'تنزيل';

  @override
  String get certificatesPreviewTitle => 'معاينة الشهادة';

  @override
  String get certificatesShareAchievementTitle => 'شارك إنجازك';

  @override
  String get certificatesShareAchievementDescription =>
      'قم بتنزيل هذه الشهادة أو مشاركتها لإبراز إنجازك';

  @override
  String get certificatesShare => 'مشاركة';

  @override
  String get certificatesHelpText =>
      'هذه الشهادة موقعة رقميًا ويمكن التحقق منها باستخدام معرّف الشهادة';

  @override
  String get certificatesCertificateOfCompletion => 'شهادة إكمال';

  @override
  String get certificatesCertifyLine => 'نشهد بأن';

  @override
  String get certificatesCompletedCourseLine => 'قد أكمل بنجاح الدورة';

  @override
  String certificatesAwardedOn(String date) {
    return 'مُنحت في $date';
  }

  @override
  String get certificatesVerified => 'موثّقة';

  @override
  String get activityStatusStarted => 'بدأت';

  @override
  String activityScoreLabel(int score) {
    return 'الدرجة: $score%';
  }

  @override
  String activityProgressLabel(int progress) {
    return 'تمت مشاهدة $progress% حتى الآن';
  }

  @override
  String get profileTabTitle => 'الملف الشخصي';

  @override
  String profileMembershipLabel(String date) {
    return 'تتعلم معنا منذ $date';
  }

  @override
  String get latestActivityLabel => 'آخر نشاط';

  @override
  String streakMomentumLabel(int days) {
    return '$days أيام من الزخم';
  }

  @override
  String weeklyHoursLabel(String hours) {
    return '$hours ساعة هذا الأسبوع';
  }

  @override
  String get lessonsFinishedLabel => 'دروس';

  @override
  String get testsAttemptedLabel => 'اختبارات';

  @override
  String get assessmentsDoneLabel => 'تقييمات';

  @override
  String get strongestSubjectLabel => 'أنت الأقوى في';

  @override
  String get weakSubjectLabel => 'تحتاج للتركيز هنا';

  @override
  String get noActivityTitle => 'لا يوجد نشاط دراسي بعد';

  @override
  String get noActivitySubtitle => 'ابدأ بجلسة لبناء الزخم';

  @override
  String get allCaughtUpTitle => 'كل شيء محدث!';

  @override
  String get noScheduledActivitiesSubtitle => 'لا توجد أنشطة مجدولة الآن';

  @override
  String get liveLabel => 'مباشر';

  @override
  String get importantLabel => 'مهم';

  @override
  String testTypeLabel(String type) {
    return 'اختبار $type';
  }

  @override
  String coursesCompletedLabel(int count) {
    return '$count كورسات';
  }

  @override
  String streakDaysLabel(int count) {
    return '$count أيام';
  }

  @override
  String get achievementsLabel => 'الإنجازات';

  @override
  String moreBadgesLabel(int count) {
    return '+$count أكثر';
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
  String get drawerForum => 'منتدى المناقشات';

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

  @override
  String get studyTabTitle => 'دراسة';

  @override
  String get studySearchHint => 'البحث في الكورسات، الفصول، الدروس';

  @override
  String get studyYourCoursesTitle => 'كورساتك';

  @override
  String get studyLessonsTitle => 'الدروس';

  @override
  String get filterVideo => 'فيديو';

  @override
  String get filterLesson => 'درس';

  @override
  String get filterAssessment => 'تقييم';

  @override
  String get filterTest => 'اختبار';

  @override
  String get resumeStudyHeader => 'استئناف الدراسة';

  @override
  String get labelCompleted => 'مكتمل';

  @override
  String get errorGenericTitle => 'حدث خطأ ما';

  @override
  String get errorGenericMessage =>
      'فشل تحميل البيانات. يرجى التحقق من الاتصال والمحاولة مرة أخرى.';

  @override
  String get labelLessonsPlural => 'دروس';

  @override
  String get labelContentsPlural => 'محتويات';

  @override
  String get curriculumBackButton => 'عودة';

  @override
  String get commonCloseButton => 'إغلاق';

  @override
  String curriculumChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فصول',
      one: '1 فصل',
    );
    return '$_temp0';
  }

  @override
  String courseContentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محتويات',
      one: '1 المحتوى',
    );
    return '$_temp0';
  }

  @override
  String get filterAll => 'الكل';

  @override
  String get curriculumLessonsLabel => 'دروس';

  @override
  String get curriculumAssessmentsLabel => 'تقييمات';

  @override
  String curriculumTestsCompletedLabel(Object count) {
    return 'تم الانتهاء من $count اختبارات';
  }

  @override
  String chapterIndexLabel(int index, String title) {
    return 'الفصل $index: $title';
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
  String get statusLocked => 'مقفل';

  @override
  String get statusInProgress => 'في التقدم';

  @override
  String get statusCompleted => 'مكتمل';

  @override
  String get chapterStatusRunning => 'جارٍ';

  @override
  String get chapterStatusUpcoming => 'قادمة';

  @override
  String get chapterStatusHistory => 'السجلات';

  @override
  String get chapterTypeVideo => 'درس فيديو';

  @override
  String get chapterTypePdf => 'ملاحظات PDF';

  @override
  String get chapterTypeAssessment => 'تقييم تدريبي';

  @override
  String get chapterTypeTest => 'اختبار';

  @override
  String get chapterNoContent => 'لا يوجد محتوى متاح';

  @override
  String get chapterNotFound => 'الفصل غير موجود';

  @override
  String lessonXofY(int index, int total) {
    return 'درس $index من $total';
  }

  @override
  String get lessonBookmarkAdd => 'إضافة إشارة مرجعية';

  @override
  String get lessonBookmarkRemove => 'إزالة الإشارة المرجعية';

  @override
  String get lessonDownload => 'تحميل الدرس';

  @override
  String get navigationPrevious => 'السابق';

  @override
  String get navigationNext => 'الدرس التالي';

  @override
  String openDetailedLesson(String title) {
    return 'افتح الدرس: $title';
  }

  @override
  String get videoLessonTabNotes => 'ملاحظات';

  @override
  String get videoLessonTabTranscript => 'النص';

  @override
  String get videoLessonTabAskDoubt => 'اسأل سؤال';

  @override
  String get videoLessonTabAiSupport => 'دعم AI';

  @override
  String get videoLessonLectureNotes => 'ملاحظات المحاضرة';

  @override
  String get videoLessonDownloadPdf => 'تحميل PDF';

  @override
  String get videoLessonKeyFormula => 'المعادلة الرئيسية';

  @override
  String get videoLessonTranscript => 'نص الفيديو';

  @override
  String get videoLessonContinueNext => 'تابع إلى الدرس التالي';

  @override
  String get videoLessonAskYourDoubt => 'اسأل سؤالك';

  @override
  String get videoLessonDoubtDescription =>
      'هل لديك سؤال حول هذه المحاضرة؟ سيجيب مدرسونا الخبراء خلال 24 ساعة.';

  @override
  String get videoLessonRecentDoubts => 'الأسئلة الأخيرة';

  @override
  String get videoLessonPostYourDoubt => 'انشر سؤالك';

  @override
  String get videoLessonDoubtHint =>
      'اكتب سؤالك هنا... كن محددًا فيما تشعر بالحيرة حوله.';

  @override
  String videoLessonCharacterCount(int current, int max) {
    return '$current/$max حرف';
  }

  @override
  String get videoLessonSubmitDoubt => 'إرسال السؤال';

  @override
  String get videoLessonPending => 'قيد الانتظار';

  @override
  String get videoLessonAiAssistant => 'مساعد الدراسة بالذكاء الاصطناعي';

  @override
  String get videoLessonAiHelp => 'احصل على مساعدة فورية لأسئلتك';

  @override
  String get videoLessonAiHint =>
      'اسأل الذكاء الاصطناعي أي شيء عن هذه المحاضرة...';

  @override
  String get videoLessonAiDisclaimer =>
      'يتم إنشاء ردود الذكاء الاصطناعي فوريًا بناءً على محتوى المحاضرة';

  @override
  String get testExit => 'خروج من الاختبار';

  @override
  String testTimeLeft(Object time) {
    return 'متبقي $time';
  }

  @override
  String testQuestionXofY(int index, int total) {
    return 'السؤال $index من $total';
  }

  @override
  String get testSaved => 'تم الحفظ';

  @override
  String get testMarked => 'تم وضع علامة';

  @override
  String get testMarkForReview => 'وضع علامة للمراجعة';

  @override
  String get testPrevious => 'السابق';

  @override
  String get testNext => 'التالي';

  @override
  String get testFinish => 'إنهاء';

  @override
  String testViewAllQuestions(Object answered, Object total) {
    return 'عرض جميع الأسئلة ($answered/$total تمت الإجابة عليها)';
  }

  @override
  String get testCompleteTitle => 'اكتمل الاختبار!';

  @override
  String get testCompleteSubtitle => 'عمل رائع! لقد أكملت الاختبار التدريبي.';

  @override
  String get testRetake => 'إعادة الاختبار';

  @override
  String get testBackToChapter => 'العودة إلى الفصل';

  @override
  String testScorePercentage(Object percentage) {
    return '$percentage%';
  }

  @override
  String testScoreSummary(Object correct, Object total) {
    return '$correct من $total صحيحة';
  }

  @override
  String get testPaletteTitle => 'أهلاً! راجع إجاباتك';

  @override
  String testPaletteAnsweredCount(Object answered, Object total) {
    return 'تمت الإجابة على $answered من أصل $total';
  }

  @override
  String get testStatusNotVisited => 'لم تتم زيارتها';

  @override
  String get testStatusAnswered => 'تمت الإجابة';

  @override
  String get testStatusMarked => 'تم وضع علامة';

  @override
  String get testStatusAnsweredMarked => 'تمت الإجابة والمراجعة';

  @override
  String testAttemptXofY(int index, int total) {
    return 'المحاولة $index من $total';
  }

  @override
  String get testSelectAllApply => 'اختر كل ما ينطبق';

  @override
  String get testSubmitConfirmationTitle => 'هل تريد تسليم الاختبار؟';

  @override
  String testSubmitConfirmationBody(int answered, int total) {
    return 'لقد أجبت على $answered من أصل $total سؤالاً.';
  }

  @override
  String testSubmitConfirmationUnanswered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بقي $count أسئلة بدون إجابة',
      two: 'بقي سؤالان بدون إجابة',
      one: 'بقي سؤال واحد بدون إجابة',
      zero: 'تمت الإجابة على جميع الأسئلة',
    );
    return '$_temp0';
  }

  @override
  String get labelCancel => 'إلغاء';

  @override
  String get labelSubmitNow => 'تسليم الآن';

  @override
  String get testSubmittedTitle => 'تم تسليم الاختبار!';

  @override
  String get testSubmittedBody =>
      'لقد تم تسليم اختبارك بنجاح. راجع إجاباتك أو اعرض التحليلات التفصيلية.';

  @override
  String get testReviewAnswers => 'مراجعة الإجابات';

  @override
  String get testViewAnalytics => 'عرض التحليلات';

  @override
  String get assessmentCheckAnswer => 'تحقق من الإجابة';

  @override
  String get assessmentCorrect => 'صحيح!';

  @override
  String get assessmentIncorrect => 'ليس صحيحاً تماماً';

  @override
  String get assessmentTryAgain => 'حاول مرة أخرى';

  @override
  String get assessmentNext => 'التالي';

  @override
  String get assessmentExplanation => 'الشرح';

  @override
  String get assessmentPracticeComplete => 'اكتمل تقييم التدريب!';

  @override
  String get assessmentExit => 'الخروج من التقييم';

  @override
  String get assessmentPaletteTitle => 'لوحة الأسئلة';

  @override
  String get assessmentUnanswered => 'غير مجاب عليه';

  @override
  String get assessmentBackToChapter => 'العودة إلى الفصل';

  @override
  String get examReviewTitle => 'مراجعة الامتحان';

  @override
  String get examReviewFilterWrong => 'خطأ';

  @override
  String get examReviewFilterCorrect => 'صحيح';

  @override
  String get examReviewFilterUnanswered => 'غير مجاب عليه';

  @override
  String get examReviewCorrectAnswerLabel => 'الإجابة الصحيحة:';

  @override
  String get examReviewYourAnswerLabel => 'إجابتك:';

  @override
  String get examReviewFilterAnswered => 'تمت الإجابة عليه';

  @override
  String get labelAskDoubt => 'اسأل سؤال';

  @override
  String get labelComment => 'تعليق';

  @override
  String get labelReport => 'إبلاغ';

  @override
  String get labelOverallSummary => 'الملخص العام';

  @override
  String get labelFilter => 'تصفية:';

  @override
  String get labelAccuracy => 'الدقة';

  @override
  String get labelScore => 'النتيجة';

  @override
  String get labelTimeTaken => 'الوقت المستغرق';

  @override
  String get labelPercentile => 'المئوية';

  @override
  String get labelRank => 'الترتيب';

  @override
  String get labelPerformance => 'الأداء';

  @override
  String get labelSubject => 'المادة';

  @override
  String get labelAttempted => 'تمت المحاولة';

  @override
  String get labelTotalQuestions => 'إجمالي الأسئلة';

  @override
  String get performanceExcellent => 'ممتاز';

  @override
  String get performanceGood => 'جيد';

  @override
  String get performanceAverage => 'متوسط';

  @override
  String get performancePoor => 'ضعيف';

  @override
  String get recommendationHigh => 'عالٍ';

  @override
  String get recommendationMedium => 'متوسط';

  @override
  String get recommendationLow => 'منخفض';

  @override
  String get reviewAskDoubtTitle => 'اسأل سؤالاً';

  @override
  String get reviewSubmitDoubt => 'إرسال السؤال';

  @override
  String get reviewAddCommentTitle => 'إضافة تعليق';

  @override
  String get reviewPostComment => 'نشر التعليق';

  @override
  String get reviewReportIssueTitle => 'الإبلاغ عن مشكلة';

  @override
  String get reviewSubmitReport => 'إرسال البلاغ';

  @override
  String reviewReportIssueWithQuestion(int number) {
    return 'الإبلاغ عن مشكلة في السؤال $number';
  }

  @override
  String get reviewDescribeDoubtHint => 'صف سؤالك هنا...';

  @override
  String get reviewWriteCommentHint => 'اكتب تعليقك...';

  @override
  String get reviewReportOptionIncorrect => 'الإجابة غير الصحيحة محددة كصحيحة';

  @override
  String get reviewReportOptionUnclear => 'السؤال غير واضح';

  @override
  String get reviewReportOptionWrongExplanation => 'الشرح خاطئ';

  @override
  String get reviewReportOptionOther => 'مشكلة أخرى';

  @override
  String get reviewReportDetailsHint => 'تفاصيل إضافية (اختياري)...';

  @override
  String reviewShareThoughtsOnQuestion(int number) {
    return 'شارك أفكارك حول السؤال $number';
  }

  @override
  String reviewQuestionLabel(String number) {
    return 'سؤال $number';
  }

  @override
  String get reviewEmptyStateMessage => 'لم يتم العثور على أسئلة لهذا الفلتر.';

  @override
  String reviewAnswersTitle(String title) {
    return 'مراجعة الإجابات - $title';
  }

  @override
  String reviewQuestionCount(int current, int total) {
    return '$current من $total';
  }

  @override
  String get settingsAppearanceTitle => 'المظهر';

  @override
  String get settingsPlaybackTitle => 'التعلم والتشغيل';

  @override
  String get settingsAccessibilityTitle => 'إمكانية الوصول';

  @override
  String get settingsVideoQuality => 'جودة الفيديو';

  @override
  String get settingsVideoQualityCaption =>
      'قم بتعيين الجودة الافتراضية المفضلة لديك';

  @override
  String get settingsAutoPlay => 'تشغيل الدرس التالي تلقائيًا';

  @override
  String get settingsTextSize => 'حجم النص';

  @override
  String get settingsHighContrast => 'تباين عالٍ';

  @override
  String get settingsDescription => 'تخصيص تجربة التعلم الخاصة بك';

  @override
  String get settingsThemeLightMode => 'الوضع الفاتح';

  @override
  String get settingsThemeDarkMode => 'الوضع الداكن';

  @override
  String get settingsThemeSystemDefault => 'افتراضي النظام';

  @override
  String get settingsPlaybackDescription => 'اختر جودة التشغيل';

  @override
  String get settingsTextSizeDescription => 'ضبط راحة القراءة';

  @override
  String get settingsRecommended => 'موصى به';

  @override
  String get settingsDefault => 'افتراضي';

  @override
  String get settingsAutoPlaySubtitle => 'بدء الدرس التالي تلقائيًا';

  @override
  String get settingsHighContrastSubtitle => 'زيادة التباين البصري';

  @override
  String get editProfileTitle => 'تعديل الملف الشخصي';

  @override
  String get editProfileNameLabel => 'الاسم الكامل';

  @override
  String get editProfileNameHint => 'أدخل اسمك الكامل';

  @override
  String get editProfileEmailLabel => 'البريد الإلكتروني';

  @override
  String get editProfileEmailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get editProfileEmailHelper => 'لا يمكن تغيير البريد الإلكتروني';

  @override
  String get editProfilePhoneLabel => 'رقم الهاتف';

  @override
  String get editProfilePhoneHint => 'أدخل رقم هاتفك';

  @override
  String get editProfileSave => 'حفظ';

  @override
  String get editProfileSuccess => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get editProfileErrorNameEmpty => 'الاسم لا يمكن أن يكون فارغًا';

  @override
  String get editProfilePhotoLabel => 'صورة الملف الشخصي';

  @override
  String get editProfileChangePhoto => 'تغيير الصورة';

  @override
  String get editProfileBack => 'عودة';

  @override
  String get exploreTabTitle => 'استكشاف';

  @override
  String get exploreSearchHint => 'ابحث عن الدورات، الدروس، المواضيع...';

  @override
  String get exploreSearchResultsTitle => 'نتائج البحث';

  @override
  String get exploreTrendingTitle => 'الرائج الآن';

  @override
  String get exploreRecommendedTitle => 'موصى به لك';

  @override
  String get exploreShortLessonsTitle => 'الفيديوهات الأكثر مشاهدة';

  @override
  String get explorePopularTestsTitle => 'الاختبارات الشائعة';

  @override
  String get exploreStudyTipsTitle => 'نصائح الدراسة والتحديثات';

  @override
  String get exploreFilterTrending => 'رائج';

  @override
  String get exploreFilterRecommended => 'موصى به';

  @override
  String get exploreFilterShortLessons => 'دروس قصيرة';

  @override
  String get exploreFilterPopular => 'شائع';

  @override
  String get exploreFilterStudyTips => 'نصائح الدراسة';

  @override
  String get editProfileFirstNameLabel => 'الاسم الأول';

  @override
  String get editProfileFirstNameHint => 'أدخل اسمك الأول';

  @override
  String get editProfileLastNameLabel => 'اسم العائلة';

  @override
  String get editProfileLastNameHint => 'أدخل اسم عائلتك';

  @override
  String get labelMock => 'تجريبي';

  @override
  String get labelPractice => 'ممارسة';

  @override
  String get forumTitle => 'منتدى المناقشة';

  @override
  String get forumSelectCourse => 'اختر دورة لعرض المناقشات';

  @override
  String forumThreadsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مناقشات',
      two: 'مناقشتان',
      one: 'مناقشة واحدة',
      zero: 'لا توجد مناقشات',
    );
    return '$_temp0';
  }

  @override
  String forumUnansweredCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسئلة غير مجابة',
      two: 'سؤالان غير مجابان',
      one: 'سؤال واحد غير مجاب',
      zero: 'لا توجد أسئلة غير مجابة',
    );
    return '$_temp0';
  }

  @override
  String get forumLabelAnswered => 'تم الرد';

  @override
  String get forumLabelUnanswered => 'لم يتم الرد';

  @override
  String get forumSearchDiscussions => 'البحث في المناقشات';

  @override
  String get forumCreatePost => 'إنشاء منشور';

  @override
  String get forumNoDiscussions => 'لا توجد مناقشات متاحة لهذه الدورة بعد.';
}
