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
  String get loginErrorGoogleTokenFailed =>
      'فشل في استرداد رمز الهوية من جوجل.';

  @override
  String get loginSignIn => 'تسجيل الدخول';

  @override
  String get loginSignUp => 'إنشاء حساب';

  @override
  String get loginSignUpPrompt => 'ليس لديك حساب؟ ';

  @override
  String get loginAlreadyHaveAccount => 'هل لديك حساب بالفعل؟ ';

  @override
  String get loginForgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loginOr => 'أو';

  @override
  String get loginContinueWithMobile => 'المتابعة برقم الهاتف';

  @override
  String get loginContinueWithGoogle => 'المتابعة عبر Google';

  @override
  String get loginMobileLoginTitle => 'تسجيل الدخول بالجوال';

  @override
  String get loginMobileLoginSubtitle => 'أدخل رقم هاتفك للمتابعة';

  @override
  String get loginCountryCodeShortLabel => 'الرمز';

  @override
  String get loginContinue => 'متابعة';

  @override
  String get loginVerifyOtpTitle => 'التحقق من OTP';

  @override
  String get loginVerify => 'تحقق';

  @override
  String loginResendCodeIn(String time) {
    return 'إعادة إرسال الرمز خلال $time';
  }

  @override
  String get loginDidntReceiveCode => 'لم تستلم الرمز؟ ';

  @override
  String get loginResend => 'إعادة الإرسال';

  @override
  String get loginOtpError => 'يرجى إدخال رمز OTP المكون من 4 أرقام';

  @override
  String get loginResendSuccess => 'تمت إعادة إرسال الرمز بنجاح!';

  @override
  String get loginResendFailed =>
      'فشل في إعادة إرسال الرمز. يرجى المحاولة مرة أخرى.';

  @override
  String get loginForgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get loginForgotPasswordSubtitle =>
      'أدخل البريد الإلكتروني المرتبط بحسابك. سنرسل رمز تحقق لإعادة تعيين كلمة المرور.';

  @override
  String get loginForgotPasswordSent =>
      'لقد أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.';

  @override
  String get loginSendResetLink => 'إرسال رابط الإعادة';

  @override
  String get loginBackToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get loginEmailLabel => 'البريد الإلكتروني';

  @override
  String get loginEmailHintFull => 'أدخل بريدك الإلكتروني';

  @override
  String get loginEmailRequired => 'يرجى إدخال عنوان بريدك الإلكتروني.';

  @override
  String get loginSignUpTitle => 'إنشاء حساب';

  @override
  String get loginEmailHintId => 'أدخل معرّف بريدك الإلكتروني';

  @override
  String get loginSignupUsernameLabel => 'اسم المستخدم';

  @override
  String get loginSignupUsernameHint => 'أدخل اسم المستخدم';

  @override
  String get loginRequiredError => '*مطلوب';

  @override
  String get loginPhoneNumberShortHint => '92726-05921';

  @override
  String get loginSetPasswordLabel => 'تعيين كلمة المرور';

  @override
  String get loginRegister => 'تسجيل';

  @override
  String get loginGoBack => 'رجوع';

  @override
  String get loginShowPassword => 'إظهار كلمة المرور';

  @override
  String get loginHidePassword => 'إخفاء كلمة المرور';

  @override
  String loginEnterFieldHint(String field) {
    return 'أدخل $field';
  }

  @override
  String loginOtpVerifySubtitle(String phone) {
    return 'أدخل الرمز المكون من 4 أرقام المُرسَل إلى $phone';
  }

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
  String get labelGeneral => 'عام';

  @override
  String filterBy(String name) {
    return 'تصفية حسب $name';
  }

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
  String get drawerPosts => 'الإعلانات';

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
  String get noCoursesAvailable => 'لا توجد دورات متاحة';

  @override
  String get selectExamToViewQuestions => 'حدد اختبارًا لعرض أوراق الأسئلة';

  @override
  String get filterVideo => 'فيديو';

  @override
  String get filterAssessment => 'تقييم';

  @override
  String get filterTest => 'اختبار';

  @override
  String get filterNotes => 'ملاحظات';

  @override
  String get filterAttachment => 'مرفقات';

  @override
  String get resumeStudyHeader => 'استئناف الدراسة';

  @override
  String get labelCompleted => 'مكتمل';

  @override
  String get errorGenericTitle => 'حدث خطأ ما';

  @override
  String get errorGenericMessage =>
      'فشل تحميل البيانات. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get errorLessonLoad => 'فشل تحميل الدرس. يرجى التحقق من اتصالك.';

  @override
  String errorLoadingLesson(String error) {
    return 'خطأ في تحميل الدرس: $error';
  }

  @override
  String get noQuestionsFound => 'لم يتم العثور على أي أسئلة.';

  @override
  String get semanticExamStatistics => 'إحصائيات الامتحان';

  @override
  String get semanticMarksPerQuestion => 'درجات لكل سؤال';

  @override
  String get semanticExamTimeline => 'الجدول الزمني للامتحان';

  @override
  String get lessonNotFound => 'لم يتم العثور على الدرس';

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
  String get chapterTypeAssessment => 'تقييم ممارس';

  @override
  String get chapterTypeTest => 'اختبار';

  @override
  String get chapterTypeLiveStream => 'بث مباشر';

  @override
  String get chapterTypeEmbed => 'محتوى مضمن';

  @override
  String get chapterTypeNotes => 'ملاحظات';

  @override
  String get chapterTypeAttachment => 'مرفق';

  @override
  String get chapterTypeUnknown => 'غير معروف';

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
  String get navigationPrevious => 'الدرس السابق';

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
  String get testViewAllQuestionsShort => 'عرض جميع الأسئلة';

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
  String get testReview => 'مراجعة';

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
  String get labelReported => 'تم الإبلاغ';

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
  String get reviewReportSuccess => 'تم إرسال البلاغ بنجاح';

  @override
  String get reviewReportFailed => 'فشل في إرسال البلاغ';

  @override
  String reviewReportIssueWithQuestion(int number) {
    return 'الإبلاغ عن مشكلة في السؤال $number';
  }

  @override
  String get reviewDescribeDoubtHint => 'صف سؤالك هنا...';

  @override
  String get reviewWriteCommentHint => 'اكتب تعليقك...';

  @override
  String get reviewReportOptionErrorInQuestion => 'خطأ في السؤال';

  @override
  String get reviewReportOptionIncorrectAnswer => 'إجابة غير صحيحة';

  @override
  String get reviewReportOptionNoExplanation => 'لا يوجد شرح';

  @override
  String get reviewReportOptionIncompleteExplanation => 'شرح غير مكتمل';

  @override
  String get reviewReportOptionOthers => 'أخرى';

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
  String get examsEmptyStateDesc => 'لا توجد امتحانات متاحة حاليا.';

  @override
  String get customExamTitle => 'امتحان مخصص';

  @override
  String get customExamCourseSelectionInfo =>
      'بعد اختيار الدورة، يمكنك تحديد المواضيع، مستوى الصعوبة، وضع الاختبار وعدد الأسئلة.';

  @override
  String get customExamLoadingCourse => 'جاري تحميل اسم الدورة...';

  @override
  String get customExamSelectedCourse => 'الدورة المختارة';

  @override
  String get customExamQuestionType => 'نوع السؤال';

  @override
  String get customExamSelectQuestionType => 'حدد نوع الأسئلة';

  @override
  String get customExamTestMode => 'وضع الاختبار';

  @override
  String get customExamChooseTestExperience => 'اختر تجربة الاختبار';

  @override
  String get customExamNumberOfQuestions => 'عدد الأسئلة';

  @override
  String get customExamChooseNumberOfQuestions => 'اختر عدد الأسئلة';

  @override
  String get customExamSelectOneOrMoreSubjects => 'حدد موضوعًا واحدًا أو أكثر';

  @override
  String get customExamSelectDifficultyLevel => 'تحديد مستوى الصعوبة';

  @override
  String customExamRemoveItem(String item) {
    return 'إزالة $item';
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
  String get settingsLanguageTitle => 'اللغة';

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
  String get forumFilterTitle => 'عوامل التصفية';

  @override
  String get forumFilterByActivity => 'تصفية حسب النشاط';

  @override
  String get forumFilterClearAll => 'مسح الكل';

  @override
  String get forumBackSemantic => 'عودة';

  @override
  String get forumFilterSemantic => 'تصفية';

  @override
  String get forumFilterActivityPosted => 'نشرتها أنا';

  @override
  String get forumFilterActivityCommented => 'علقت عليها أنا';

  @override
  String get forumFilterActivityLiked => 'أعجبتني';

  @override
  String get forumFilterActivityBookmarked => 'أشرت إليها كمرجعية';

  @override
  String get forumSortRecent => 'الأحدث';

  @override
  String get forumSortMostLiked => 'الأكثر إعجاباً';

  @override
  String get forumSortMostViewed => 'الأكثر مشاهدة';

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

  @override
  String get forumDiscussion => 'مناقشة';

  @override
  String get forumReplyPlaceholder => 'اكتب ردك هنا...';

  @override
  String get forumCreateNewPost => 'إنشاء منشور جديد';

  @override
  String get forumPostTitleHint => 'أضف عنواناً...';

  @override
  String get forumPostDescriptionHint => 'صف سؤالك بالتفصيل...';

  @override
  String get forumPostSubjectLabel => 'العنوان';

  @override
  String get forumPostDescriptionLabel => 'الوصف';

  @override
  String get forumPostCategoryLabel => 'الفئة';

  @override
  String get forumPostSelectCategoryTitle => 'اختر الفئة';

  @override
  String get forumButtonSubmit => 'إرسال';

  @override
  String get forumButtonCancel => 'إلغاء';

  @override
  String attachmentSize(String size) {
    return 'الحجم: $size';
  }

  @override
  String get attachmentDownload => 'تحميل';

  @override
  String get attachmentDownloading => 'جاري التحميل...';

  @override
  String get attachmentViewFile => 'عرض الملف المحمل';

  @override
  String get dashboardWhatsNewTitle => 'ما هو الجديد';

  @override
  String get dashboardRecentlyCompletedTitle => 'المكتملة مؤخرًا';

  @override
  String get dashboardResumeTitle => 'استئناف التعلم';

  @override
  String get downloadsTitle => 'التنزيلات';

  @override
  String get downloadsVideosTab => 'فيديوهات';

  @override
  String get downloadsAttachmentsTab => 'المرفقات';

  @override
  String downloadsVideosTabCount(int count) {
    return 'فيديوهات ($count)';
  }

  @override
  String downloadsAttachmentsTabCount(int count) {
    return 'المرفقات ($count)';
  }

  @override
  String get downloadsEmpty => 'لم يتم العثور على تنزيلات';

  @override
  String get downloadsEmptyVideosSubtitle =>
      'ستظهر مقاطع الفيديو التي تم تنزيلها هنا';

  @override
  String get downloadsEmptyAttachmentsSubtitle =>
      'ستظهر الملفات التي تم تنزيلها هنا';

  @override
  String downloadsTotalVideos(int count) {
    return 'إجمالي الفيديوهات: $count';
  }

  @override
  String downloadsTotalFiles(int count) {
    return 'إجمالي الملفات: $count';
  }

  @override
  String downloadsStorageUsed(String size) {
    return '$size مستخدم';
  }

  @override
  String get doubtsEmptyTitle => 'لم يتم العثور على أسئلة';

  @override
  String get doubtsEmptySubtitle =>
      'اطرح سؤالك الأول للحصول على مساعدة من المعلمين.';

  @override
  String get doubtsSearchNoResults => 'لم يتم العثور على نتائج';

  @override
  String get doubtsSearchNoResultsSubtitle => 'حاول تغيير نص البحث';

  @override
  String get doubtsHeaderAskDoubt => 'اسأل سؤال';

  @override
  String get doubtsSearchHint => 'البحث في الأسئلة';

  @override
  String get doubtsLabelUnanswered => 'لم يتم الرد';

  @override
  String get doubtsLabelAnswered => 'تم الرد';

  @override
  String doubtsReplyCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ردود',
      one: 'رد واحد',
    );
    return '$_temp0';
  }

  @override
  String get doubtsFormTitleLabel => 'ما هو سؤالك؟';

  @override
  String get doubtsFormTitleHint => 'على سبيل المثال، لا أستطيع فهم هذا السؤال';

  @override
  String get doubtsFormDescriptionLabel => 'اشرح سؤالك بالتفصيل';

  @override
  String get doubtsFormCategoryLabel => 'حدد الموضوع';

  @override
  String get doubtsFormAttachmentsLabel => 'المرفقات (اختياري)';

  @override
  String get doubtsFormUploadAction => 'تحميل صورة أو ملف PDF';

  @override
  String get doubtsFormSubmitAction => 'إرسال السؤال';

  @override
  String get doubtsFormNextAction => 'التالي';

  @override
  String get doubtsSubmitSheetTitle => 'كيف تود أن تسأل؟';

  @override
  String get doubtsSubmitSheetAskAi => 'اسأل الذكاء الاصطناعي';

  @override
  String get doubtsSubmitSheetAskAiDesc =>
      'احصل على إجابة فورية لسؤالك باستخدام الذكاء الاصطناعي';

  @override
  String get doubtsSubmitSheetAskMentor => 'اسأل المرشد';

  @override
  String get doubtsSubmitSheetAskMentorDesc =>
      'احصل على مساعدة من مرشد بخصوص سؤالك';

  @override
  String get doubtsSubmitSuccessMessage => 'تم إرسال السؤال بنجاح';

  @override
  String get doubtsSubmitErrorMessage =>
      'فشل في إرسال السؤال. يرجى المحاولة مرة أخرى.';

  @override
  String get doubtsFormCancelAction => 'إلغاء';

  @override
  String get doubtsFormTopicsLabel => 'المواضيع';

  @override
  String get doubtsFormIdkLabel => 'لا أعرف';

  @override
  String get doubtsFormFailedToLoadTopics => 'فشل تحميل المواضيع';

  @override
  String get examInstructions => 'تعليمات الامتحان';

  @override
  String get startExam => 'ابدأ الامتحان';

  @override
  String get examTotalQuestions => 'مجموع الأسئلة';

  @override
  String get examDuration => 'المدة';

  @override
  String get examTotalMarks => 'مجموع العلامات';

  @override
  String get examCorrectAnswer => 'إجابة صحيحة';

  @override
  String get examWrongAnswer => 'إجابة خاطئة';

  @override
  String get examStartsOn => 'يبدأ في';

  @override
  String get examEndsOn => 'ينتهي في';

  @override
  String get examForever => 'إلى الأبد';

  @override
  String get examDetailsTitle => 'تفاصيل الامتحان';

  @override
  String get errorCannotStartExam => 'عفوًا! لا يمكن بدء الامتحان';

  @override
  String get errorUnknownOccurred => 'حدث خطأ غير معروف.';

  @override
  String get actionGoBack => 'العودة';

  @override
  String get nextSubject => 'الموضوع التالي';

  @override
  String get nextSection => 'القسم التالي';

  @override
  String get doubtDetailTitle => 'تفاصيل السؤال';

  @override
  String get errorFailedToLoadReplies => 'فشل تحميل الردود';

  @override
  String get errorFailedToLoadDoubtDetails => 'فشل تحميل تفاصيل السؤال';

  @override
  String get labelMentor => 'مرشد';

  @override
  String get infoPageTitle => 'موارد التعلم';

  @override
  String get infoPageSubtitle => 'اختر موردًا لعرض التفاصيل';

  @override
  String get infoPageEmptyState => 'لا توجد موارد تعلم متاحة حاليًا.';

  @override
  String get infoPageLoadError => 'تعذر تحميل الموارد. يرجى المحاولة مرة أخرى.';

  @override
  String infoPageOpenCourse(String title) {
    return 'افتح $title';
  }

  @override
  String infoPageLessonsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دروس',
      one: 'درس واحد',
    );
    return '$_temp0';
  }

  @override
  String get videoLessonNoTranscriptAvailable => 'لا يوجد نص متاح لهذا الدرس.';

  @override
  String get videoLessonTranscriptionInProgress => 'تفريغ النص قيد المعالجة';

  @override
  String get videoLessonTranscriptionInProgressDesc =>
      'نحن نعمل حاليًا على توليد تفريغ النص لهذا الفيديو. يرجى التحقق مرة أخرى قريبًا.';

  @override
  String get videoLessonFailedToLoadTranscript => 'فشل تحميل تفريغ النص.';

  @override
  String get videoLessonNoNotesAvailable => 'لا توجد ملاحظات متاحة لهذا الدرس.';

  @override
  String get videoLessonNotesEmpty => 'الملاحظات فارغة حاليًا.';

  @override
  String get videoLessonFailedToLoadNotes => 'فشل تحميل ملاحظات المحاضرة.';

  @override
  String get labelSave => 'حفظ';

  @override
  String get labelUncategorized => 'غير مصنف';

  @override
  String get labelNewFolder => 'مجلد جديد';

  @override
  String get actionCreateNewFolder => 'إنشاء مجلد جديد';

  @override
  String get hintEnterFolderName => 'أدخل اسم المجلد';

  @override
  String get hintExampleFolderName => 'مثل الفيزياء، المراجعة';

  @override
  String get errorFailedToLoadFolders => 'فشل تحميل المجلدات.';

  @override
  String get errorFailedToCreateFolder =>
      'فشل إنشاء المجلد. يرجى المحاولة مرة أخرى.';

  @override
  String get bookmarkSaveToFolders => 'حفظ في قائمة التشغيل أو المجلدات';

  @override
  String get bookmarkSaveTo => 'حفظ في...';

  @override
  String bookmarkAddedToFolder(String folderName) {
    return 'تمت إضافة الإشارة المرجعية إلى $folderName';
  }

  @override
  String bookmarkRemovedFromFolder(String folderName) {
    return 'تمت إزالة الإشارة المرجعية من $folderName';
  }

  @override
  String get bookmarkRemoved => 'تمت إزالة الإشارة المرجعية';

  @override
  String get errorFailedToUpdateBookmark =>
      'فشل تحديث الإشارة المرجعية. يرجى المحاولة مرة أخرى.';

  @override
  String get errorFailedToRemoveBookmark =>
      'فشل إزالة الإشارة المرجعية. يرجى المحاولة مرة أخرى.';

  @override
  String lessonSpecializedViewerRequired(String type) {
    return 'مطلوب عارض متخصص لـ $type';
  }

  @override
  String get leaderboardTitle => 'المتصدرون';

  @override
  String get leaderboardRankListTab => 'قائمة الرتب';

  @override
  String get leaderboardCompetitorsTab => 'المنافسون';

  @override
  String get leaderboardTimelineThisWeek => 'هذا الأسبوع';

  @override
  String get leaderboardTimelineThisMonth => 'هذا الشهر';

  @override
  String get leaderboardTimelineAllTime => 'كل الوقت';

  @override
  String get leaderboardNoLearnersFound => 'لم يتم العثور على متعلمين';

  @override
  String get leaderboardErrorLoading => 'خطأ في تحميل قائمة المتصدرين';

  @override
  String get leaderboardNoCompetitorsFound => 'لم يتم العثور على منافسين';

  @override
  String get leaderboardErrorLoadingCompetitors => 'خطأ في تحميل المنافسين';

  @override
  String get leaderboardYouSuffix => ' (أنت)';

  @override
  String get loginActivityCurrentDevice => 'الجهاز الحالي';

  @override
  String get loginActivityNoActivityFound => 'لا يوجد نشاط تسجيل دخول';

  @override
  String get loginActivityLogoutOtherDevices =>
      'تسجيل الخروج من الأجهزة الأخرى';

  @override
  String get loginActivityLogoutSuccess =>
      'تم تسجيل الخروج من الأجهزة الأخرى بنجاح';

  @override
  String get actionMarkAsResolved => 'تحديد كمحلول';

  @override
  String get actionCloseDoubt => 'إغلاق الشك';

  @override
  String get messageDoubtResolved => 'تم وضع علامة على هذا الشك كمحلول.';

  @override
  String get messageDiscussionClosed => 'موضوع النقاش هذا مغلق وللقراءة فقط.';

  @override
  String get loginActivityLogoutFailed => 'فشل تسجيل الخروج';

  @override
  String get forumErrorFailedToCreatePost => 'فشل في إنشاء المنشور';

  @override
  String get forumErrorDiscussionNotFound => 'النقاش غير موجود';

  @override
  String get forumErrorLoadingComments => 'خطأ في تحميل التعليقات';

  @override
  String get forumCommentsEmptyTitle => 'لا توجد تعليقات بعد';

  @override
  String get forumCommentsEmptySubtitle => 'كن أول من يرد على هذا الموضوع.';

  @override
  String forumRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ردود',
      one: 'رد واحد',
    );
    return '$_temp0';
  }

  @override
  String get forumRoleInstructor => 'مدرب';

  @override
  String get forumPendingModeration => 'في انتظار المراجعة';

  @override
  String get forumErrorFailedToPostReply => 'فشل في نشر الرد';

  @override
  String get noAnnouncementsFound => 'لم يتم العثور على إعلانات.';

  @override
  String get commentsDisabledByAdmin =>
      'تم تعطيل التعليقات على هذا المنشور من قبل المسؤول';

  @override
  String bookmarkFolderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: '1 عنصر',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksTitle => 'إشارات مرجعية';

  @override
  String get bookmarkFilterAllContents => 'جميع المحتويات';

  @override
  String get bookmarkFilterQuestions => 'أسئلة';

  @override
  String get bookmarkFilterVideos => 'مقاطع فيديو';

  @override
  String get bookmarkFilterPDFs => 'ملفات PDF';

  @override
  String get bookmarkFilterNotes => 'ملاحظات';

  @override
  String get bookmarkFilterExamsAndQuiz => 'الامتحانات والاختبارات';

  @override
  String get bookmarkFilterLiveClasses => 'فصول مباشرة';

  @override
  String get bookmarkSortRecent => 'الأخيرة';

  @override
  String get bookmarkSortOldest => 'الأقدم';

  @override
  String get bookmarkSortLastlyOpened => 'تم فتحها مؤخرًا';

  @override
  String get bookmarkTabAll => 'الكل';

  @override
  String get bookmarkTabFolders => 'المجلدات';

  @override
  String get bookmarkActionRenameFolder => 'إعادة تسمية المجلد';

  @override
  String get bookmarkActionDeleteFolder => 'حذف المجلد';

  @override
  String get bookmarkActionMoveBookmark => 'نقل الإشارة المرجعية';

  @override
  String get bookmarkActionRemoveBookmark => 'إزالة الإشارة المرجعية';

  @override
  String get bookmarkDeleteFolderConfirmation =>
      'هل أنت متأكد أنك تريد حذف هذا المجلد؟';

  @override
  String get bookmarkLabelContentType => 'نوع المحتوى';

  @override
  String get bookmarkLabelSortBy => 'فرز حسب';

  @override
  String get bookmarkActionCreateFolder => 'إنشاء مجلد';

  @override
  String get bookmarkLabelName => 'الاسم';

  @override
  String get bookmarkActionDelete => 'حذف';

  @override
  String get actionCheck => 'تحقق';

  @override
  String get examModeSelectTitle => 'اختر وضع الامتحان';

  @override
  String get examModeRegularTitle => 'الوضع العادي';

  @override
  String get examModeRegularDesc =>
      'أجرِ الاختبار في وضع الامتحان القياسي مع مؤقت.';

  @override
  String get examModeQuizTitle => 'وضع الاختبار القصير';

  @override
  String get examModeQuizDesc => 'تحقق من الإجابات فورًا أثناء تقدمك.';

  @override
  String get resumeExamOnline => 'استئناف الامتحان عبر الإنترنت';

  @override
  String get startExamOnline => 'بدء الامتحان عبر الإنترنت';

  @override
  String get retakeExamOnline => 'إعادة التقديم';

  @override
  String get retakeIncorrectExamOnline => 'إعادة تقديم غير الصحيح';

  @override
  String get examPreviousAttempts => 'المحاولات السابقة';

  @override
  String get labelDate => 'التاريخ';

  @override
  String get analyticsInvalidTopicId => 'معرف الموضوع غير صالح';

  @override
  String get analyticsTopicNotFound => 'الموضوع غير موجود';

  @override
  String analyticsErrorLoadingTopic(String error) {
    return 'خطأ في تحميل تحليلات الموضوع: $error';
  }

  @override
  String get analyticsSubCategory => 'فئة فرعية';

  @override
  String get analyticsStrength => 'نقاط القوة';

  @override
  String get analyticsWeakness => 'نقاط الضعف';

  @override
  String get analyticsUnanswered => 'لم يتم الرد عليها';

  @override
  String get analyticsCorrect => 'صحيح';

  @override
  String get analyticsIncorrect => 'غير صحيح';

  @override
  String get analyticsAccuracy => 'الدقة';

  @override
  String get analyticsNoSubjectsFound => 'لم يتم العثور على أي مواد.';

  @override
  String filterEmptyStateMessage(String name) {
    return 'لم يتم العثور على $name.';
  }

  @override
  String get labelExams => 'امتحانات';

  @override
  String get analyticsStrengthCorrect => 'نقاط القوة / صحيح';

  @override
  String get analyticsWeaknessIncorrect => 'نقاط الضعف / غير صحيح';

  @override
  String get analyticsSubjectUppercase => 'المادة';

  @override
  String get analyticsCorrectUppercase => 'صحيح';

  @override
  String get analyticsIncorrectUppercase => 'غير صحيح';

  @override
  String get analyticsUnansweredUppercase => 'لم يتم الرد عليها';

  @override
  String get analyticsFilterSubjects => 'تصفية المواد';

  @override
  String get analyticsGraphReports => 'تقارير بيانية';

  @override
  String get analyticsTableReports => 'تقارير جدولية';

  @override
  String analyticsSelectTab(String label) {
    return 'تحديد علامة التبويب $label';
  }

  @override
  String get customExamCreateTitle => 'امتحان مخصص';

  @override
  String get customExamSelectCourse => 'اختر دورة';

  @override
  String get customExamSearchCourses => 'البحث في الدورات';

  @override
  String get customExamNoCoursesFound => 'لم يتم العثور على دورات';

  @override
  String get customExamStepScope => 'الخطوة 1: نطاق التدريب';

  @override
  String get customExamFullCourse => 'تدريب على الدورة كاملة';

  @override
  String get customExamCoverAllTopics => 'تغطية جميع المواضيع';

  @override
  String get customExamSpecificCourse => 'التدريب على دورة محددة';

  @override
  String customExamCoursePrefix(String name) {
    return 'الدورة: $name';
  }

  @override
  String get customExamStepSource => 'الخطوة 2: مصدر الأسئلة';

  @override
  String get customExamSourcePrevYear => 'أسئلة السنوات السابقة';

  @override
  String get customExamSourceBoard => 'أوراق المجلس';

  @override
  String get customExamSourceImportant => 'أسئلة هامة';

  @override
  String get customExamStepCount => 'الخطوة 3: عدد الأسئلة';

  @override
  String get customExamStepDifficulty => 'الخطوة 4: مستوى الصعوبة';

  @override
  String get customExamDiffEasy => 'سهل';

  @override
  String get customExamDiffMedium => 'متوسط';

  @override
  String get customExamDiffHard => 'صعب';

  @override
  String get customExamDiffMixed => 'مختلط';

  @override
  String get customExamStepMode => 'الخطوة 5: وضع المحاولة';

  @override
  String get customExamModeQuiz => 'اختبار قصير';

  @override
  String get customExamModeQuizDesc =>
      'احصل على ملاحظات وتفسيرات فورية بعد كل سؤال';

  @override
  String get customExamModeTest => 'اختبار';

  @override
  String get customExamModeTestDesc =>
      'محاولة كاختبار حقيقي مع مؤقت ونتيجة نهائية';

  @override
  String get customExamBtnCreate => 'امتحان مخصص';

  @override
  String get customExamBtnGoBack => 'العودة';

  @override
  String customExamCountLabel(int count) {
    return '$count أسئلة';
  }

  @override
  String get customExamSelectAtLeastOneSubject =>
      'يرجى تحديد موضوع واحد على الأقل';

  @override
  String get customExamDifficultyLevel => 'مستوى الصعوبة';

  @override
  String get customExamGenerateCustomExam => 'إنشاء امتحان مخصص';

  @override
  String get customExamPleaseSelectAtLeastOneQuestionType =>
      'يرجى تحديد نوع سؤال واحد على الأقل';

  @override
  String get customExamPleaseSelectTestMode => 'يرجى تحديد وضع الاختبار';

  @override
  String get customExamErrorLoading => 'خطأ في تحميل الدورات';

  @override
  String get customExamSelectSubjects => 'حدد المواضيع';

  @override
  String get customExamDailyLimitExhausted =>
      'لقد استنفدت حدودك اليومية للامتحانات المخصصة.';

  @override
  String get customExamMonthlyLimitExhausted =>
      'لقد استنفدت حدودك الشهرية للامتحانات المخصصة.';

  @override
  String get examsTabTitle => 'الامتحانات';

  @override
  String get availableExamCoursesTitle => 'دورات الامتحانات المتاحة';

  @override
  String get testSubmitting => 'جارٍ تسليم الاختبار...';

  @override
  String get reviewSubjectPerformanceTitle => 'الأداء حسب المادة';

  @override
  String get labelOverallPerformance => 'الأداء العام';

  @override
  String get labelSectionPerformance => 'أداء القسم';

  @override
  String get reviewSubjectPerformanceDesc => 'تفصيل أدائك في كل مادة';

  @override
  String reviewSubjectAnalyticsError(String error) {
    return 'فشل تحميل تحليلات المادة: $error';
  }

  @override
  String testScoreResult(String score) {
    return 'درجتك: $score';
  }

  @override
  String get reviewPerformanceOverviewTitle => 'نظرة عامة على الأداء';

  @override
  String get reviewSubjectPerformanceTileDesc => 'حلل أدائك في المواد المختلفة';

  @override
  String get reviewExploreDetailsTitle => 'استكشف المزيد من التفاصيل';

  @override
  String get reviewExamReviewTitle => 'مراجعة الامتحان';

  @override
  String get reviewExamReviewDesc => 'راجع كل سؤال مع الإجابات والشروحات';

  @override
  String reviewAnalyticsForTitle(String title) {
    return 'تحليلات المراجعة لـ $title';
  }

  @override
  String get defaultStudentName => 'طالب';

  @override
  String get examCompletedLabel => 'تم إكمال الامتحان';

  @override
  String get downloadingExam => 'جاري تنزيل الامتحان...';

  @override
  String get deadlinePassedCannotSync =>
      'انتهى الموعد النهائي. لا يمكن مزامنة الامتحان.';

  @override
  String get pendingSyncConnectToUpload =>
      'في انتظار المزامنة. اتصل بالإنترنت لتحميل الإجابات.';

  @override
  String get resumeOfflineExam => 'استئناف الامتحان غير المتصل';

  @override
  String get startOfflineExam => 'بدء الامتحان غير المتصل';

  @override
  String get downloadExamOffline => 'تنزيل الامتحان (للاستخدام غير المتصل)';

  @override
  String get testSavedLocallyOffline =>
      'تم حفظ الاختبار محليًا. ستكون النتائج متاحة بمجرد المزامنة.';

  @override
  String get noAnswerGiven => '(لم يتم تقديم إجابة)';

  @override
  String get correctAnswerLabel => 'الإجابة الصحيحة:';

  @override
  String get errorOfflineDataNotFound =>
      'لم يتم العثور على بيانات الاختبار. قد لا يتم إرسال إجاباتك.';

  @override
  String get reviewScore => 'النتيجة';

  @override
  String get reviewPerformanceExcellent => 'أداء ممتاز';

  @override
  String get reviewPerformanceAverage => 'أداء متوسط';

  @override
  String get reviewPerformanceLow => 'يحتاج إلى تحسين';

  @override
  String get reviewAttempted => 'تمت المحاولة';

  @override
  String get reviewCorrect => 'صحيح';

  @override
  String get reviewAccuracy => 'الدقة';

  @override
  String get reviewTimeTaken => 'الوقت المستغرق';

  @override
  String get reviewRank => 'المرتبة';

  @override
  String get reviewPercentile => 'النسبة المئوية';

  @override
  String get reviewOfTotal => 'من الإجمالي';

  @override
  String get lessonDetails => 'تفاصيل الدرس';

  @override
  String questionIdArgs(String id) {
    return 'معرف السؤال: $id';
  }

  @override
  String get customExamPleaseSelectDifficultyLevel =>
      'يرجى تحديد مستوى الصعوبة';

  @override
  String get exploreProductBack => 'رجوع';

  @override
  String get exploreSelectPlan => 'حدد الخطة';

  @override
  String get exploreBuyNow => 'اشتري الآن';

  @override
  String get exploreCheckoutComingSoon => 'عملية الدفع قريباً';

  @override
  String exploreValidityDays(String days) {
    return 'الصلاحية: $days أيام';
  }

  @override
  String exploreFromTo(String start, String end) {
    return 'من $start إلى $end';
  }

  @override
  String get exploreNoProductsFound => 'لم يتم العثور على منتجات.';

  @override
  String get exploreProductsLabel => 'المنتجات';

  @override
  String get exploreCategoriesLabel => 'الفئات';

  @override
  String explorePlanSelected(String planName, String price) {
    return '$planName، ₹$price، محدد';
  }

  @override
  String explorePlanUnselected(String planName, String price) {
    return '$planName، ₹$price';
  }

  @override
  String get exploreDescription => 'وصف';

  @override
  String get exploreCurriculum => 'المنهج';

  @override
  String get exploreHaveDiscountCode => 'هل لديك كود خصم؟';

  @override
  String get explorePayInstallments => 'الدفع على أقساط';

  @override
  String get exploreDiscountCoupon => 'كوبون الخصم';

  @override
  String get exploreChoosePlan => 'اختر خطة';

  @override
  String explorePayAmountNow(String amount) {
    return 'ادفع ₹$amount الآن';
  }

  @override
  String exploreCouponAppliedSuccess(String total) {
    return 'Coupon applied successfully! New total: $total';
  }

  @override
  String exploreStatisticsChapters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '1 Chapter',
    );
    return '$_temp0';
  }

  @override
  String exploreStatisticsVideos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Videos',
      one: '1 Video',
    );
    return '$_temp0';
  }

  @override
  String exploreStatisticsExams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Exams',
      one: '1 Exam',
    );
    return '$_temp0';
  }

  @override
  String exploreStatisticsAttachments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Attachments',
      one: '1 Attachment',
    );
    return '$_temp0';
  }

  @override
  String exploreStatisticsNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Notes',
      one: '1 Note',
    );
    return '$_temp0';
  }

  @override
  String exploreInstallmentOrdinal(String installment) {
    return 'القسط $installment';
  }

  @override
  String get exploreCouponHint => 'أدخل رمز القسيمة';

  @override
  String get exploreApplyCoupon => 'تطبيق';

  @override
  String get exploreNoInstallmentPlans =>
      'لا توجد خطط تقسيط متاحة لهذا المنتج.';

  @override
  String get exploreLoading => 'جاري التحميل...';

  @override
  String get exploreFailedToLoadPlans => 'فشل تحميل الخطط';

  @override
  String exploreInstallmentPlansCalculationBase(String price) {
    return 'يتم حساب خطط التقسيط بناءً على السعر الأصلي البالغ $price ₹.';
  }

  @override
  String explorePaidOn(String date) {
    return 'تم الدفع في $date';
  }

  @override
  String get exploreNoContentAvailable => 'لا يوجد محتوى متاح';

  @override
  String get paymentProcessing => 'جاري معالجة الدفع...';

  @override
  String get paymentSuccessful => 'اكتمل الدفع بنجاح!';

  @override
  String get paymentSuccessDescription => 'تم تأكيد تسجيلك بنجاح.';

  @override
  String get paymentFailed => 'فشل الدفع';

  @override
  String get paymentFailedDescription => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';

  @override
  String get paymentPending => 'الدفع قيد الانتظار';

  @override
  String get paymentPendingDescription => 'جاري معالجة دفعتك.';

  @override
  String get paymentCancelled => 'تم إلغاء الدفع';

  @override
  String get paymentCancelledDescription => 'لقد قمت بإلغاء الدفع.';

  @override
  String get paymentStartLearning => 'ابدأ التعلم';

  @override
  String get paymentBackToHome => 'العودة للرئيسية';

  @override
  String get paymentTryAgain => 'حاول مرة أخرى';

  @override
  String get paymentCancel => 'إلغاء';
}
