// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'Cortex SDK';

  @override
  String get loginButton => 'உள்நுழைக';

  @override
  String get loginWelcomeBack => 'மீண்டும் வரவேற்கிறோம்';

  @override
  String get loginPasswordSubtitle =>
      'உங்கள் பயனர் பெயர் மற்றும் கடவுச்சொல்லைப் பயன்படுத்தி உள்நுழையவும்';

  @override
  String get loginOtpSubtitle => 'OTP சரிபார்ப்பைப் பயன்படுத்தி உள்நுழையவும்';

  @override
  String get loginModePassword => 'கடவுச்சொல்';

  @override
  String get loginModeOtp => 'OTP';

  @override
  String get loginUsernameLabel => 'பயனர் பெயர் அல்லது மின்னஞ்சல்';

  @override
  String get loginUsernameHint => 'பயனர் பெயர் அல்லது மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get loginPasswordLabel => 'கடவுச்சொல்';

  @override
  String get loginPasswordHint => 'கடவுச்சொல்லை உள்ளிடவும்';

  @override
  String get loginSigningIn => 'உள்நுழைகிறது...';

  @override
  String get loginCountryCodeLabel => 'நாட்டின் குறியீடு';

  @override
  String get loginCountryCodeHint => '+91';

  @override
  String get loginPhoneNumberLabel => 'தொலைபேசி எண்';

  @override
  String get loginPhoneNumberHint => '9876543210';

  @override
  String get loginEmailOptionalLabel => 'மின்னஞ்சல் (விருப்பத்திற்குரியது)';

  @override
  String get loginEmailHint => 'student@example.com';

  @override
  String get loginGenerateOtp => 'OTP உருவாக்கு';

  @override
  String get loginSendingOtp => 'OTP அனுப்பப்படுகிறது...';

  @override
  String get loginOtpCodeLabel => 'OTP';

  @override
  String get loginOtpCodeHint => '1234';

  @override
  String get loginVerifyOtp => 'OTP ஐச் சரிபார்';

  @override
  String get loginVerifyingOtp => 'சரிபார்க்கப்படுகிறது...';

  @override
  String get loginOtpSentInfo =>
      'OTP அனுப்பப்பட்டது. தொடர குறியீட்டை உள்ளிடவும்.';

  @override
  String get loginErrorUsernamePasswordRequired =>
      'பயனர் பெயர் மற்றும் கடவுச்சொல் தேவை.';

  @override
  String get loginErrorOtpIdentityRequired =>
      'OTP க்கு நாட்டின் குறியீடு மற்றும் தொலைபேசி எண் தேவை.';

  @override
  String get loginErrorPhoneOtpRequired => 'தொலைபேசி எண் மற்றும் OTP தேவை.';

  @override
  String get loginErrorGenericRequest =>
      'கோரிக்கையை முடிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get loginErrorInvalidCredentials =>
      'தவறான பயனர் பெயர் அல்லது கடவுச்சொல்.';

  @override
  String get loginErrorValidation =>
      'உள்ளிடப்பட்ட புலங்களைச் சரிபார்த்து திருத்தவும்.';

  @override
  String get loginErrorThrottled =>
      'பல முயற்சிகள் செய்யப்பட்டன. மீண்டும் முயற்சிக்கும் முன் காத்திருக்கவும்.';

  @override
  String get loginErrorLockout =>
      'இந்த கணக்கு பூட்டப்பட்டுள்ளது. உங்கள் நிர்வாகியைத் தொடர்பு கொள்ளவும்.';

  @override
  String get loginErrorNetwork =>
      'நெட்வொர்க் பிழை. உங்கள் இணைய இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get loginErrorServer =>
      'சேவையக பிழை. சிறிது நேரத்திற்குப் பிறகு மீண்டும் முயற்சிக்கவும்.';

  @override
  String get loginErrorGoogleTokenFailed =>
      'கூகுளில் இருந்து அடையாள டோக்கனைப் பெறுவதில் தோல்வி.';

  @override
  String get loginSignIn => 'உள்நுழைக';

  @override
  String get loginSignUp => 'பதிவு செய்க';

  @override
  String get loginSignUpPrompt => 'கணக்கு இல்லையா? ';

  @override
  String get loginAlreadyHaveAccount => 'ஏற்கனவே கணக்கு உள்ளதா? ';

  @override
  String get loginForgotPassword => 'கடவுச்சொல் மறந்துவிட்டதா?';

  @override
  String get loginOr => 'அல்லது';

  @override
  String get loginContinueWithMobile => 'மொபைலுடன் தொடர்க';

  @override
  String get loginContinueWithGoogle => 'Google-உடன் தொடர்க';

  @override
  String get loginMobileLoginTitle => 'மொபைல் உள்நுழைவு';

  @override
  String get loginMobileLoginSubtitle =>
      'தொடர உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get loginCountryCodeShortLabel => 'குறியீடு';

  @override
  String get loginContinue => 'தொடர்க';

  @override
  String get loginVerifyOtpTitle => 'OTP சரிபார்க்கவும்';

  @override
  String get loginVerify => 'சரிபார்க்க';

  @override
  String loginResendCodeIn(String time) {
    return '$time நேரத்தில் குறியீட்டை மீண்டும் அனுப்பு';
  }

  @override
  String get loginDidntReceiveCode => 'குறியீடு வரவில்லையா? ';

  @override
  String get loginResend => 'மீண்டும் அனுப்பு';

  @override
  String get loginOtpError => 'சரியான 4 இலக்க OTP ஐ உள்ளிடவும்';

  @override
  String get loginResendSuccess =>
      'குறியீடு வெற்றிகரமாக மீண்டும் அனுப்பப்பட்டது!';

  @override
  String get loginResendFailed =>
      'குறியீட்டை மீண்டும் அனுப்ப முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get loginForgotPasswordTitle => 'கடவுச்சொல் மறந்துவிட்டது';

  @override
  String get loginForgotPasswordSubtitle =>
      'உங்கள் கணக்குடன் இணைக்கப்பட்ட மின்னஞ்சலை உள்ளிடவும். கடவுச்சொல்லை மீட்டமைக்க சரிபார்ப்பு குறியீடு அனுப்பப்படும்.';

  @override
  String get loginForgotPasswordSent =>
      'உங்கள் மின்னஞ்சலுக்கு கடவுச்சொல் மீட்டமைப்பு இணைப்பை அனுப்பியுள்ளோம்.';

  @override
  String get loginSendResetLink => 'மீட்டமைப்பு இணைப்பை அனுப்பு';

  @override
  String get loginBackToLogin => 'உள்நுழைவுக்கு திரும்பு';

  @override
  String get loginEmailLabel => 'மின்னஞ்சல்';

  @override
  String get loginEmailHintFull => 'உங்கள் மின்னஞ்சலை உள்ளிடவும்';

  @override
  String get loginEmailRequired => 'உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்.';

  @override
  String get loginSignUpTitle => 'பதிவு செய்க';

  @override
  String get loginEmailHintId => 'உங்கள் மின்னஞ்சல் ஐடியை உள்ளிடவும்';

  @override
  String get loginSignupUsernameLabel => 'பயனர் பெயர்';

  @override
  String get loginSignupUsernameHint => 'உங்கள் பயனர் பெயரை உள்ளிடவும்';

  @override
  String get loginRequiredError => '*தேவையானது';

  @override
  String get loginPhoneNumberShortHint => '92726-05921';

  @override
  String get loginSetPasswordLabel => 'கடவுச்சொல் அமை';

  @override
  String get loginRegister => 'பதிவு செய்';

  @override
  String get loginGoBack => 'திரும்பு';

  @override
  String get loginShowPassword => 'கடவுச்சொல்லை காட்டு';

  @override
  String get loginHidePassword => 'கடவுச்சொல்லை மறை';

  @override
  String loginEnterFieldHint(String field) {
    return '$field உள்ளிடவும்';
  }

  @override
  String loginOtpVerifySubtitle(String phone) {
    return 'உங்கள் $phone க்கு அனுப்பப்பட்ட 4 இலக்க குறியீட்டை உள்ளிடவும்';
  }

  @override
  String get welcomeMessage => 'Cortex-க்கு வரவேற்கிறோம்';

  @override
  String get courseLibraryTitle => 'Cortex';

  @override
  String get courseLibrarySubtitle => 'பாடநூல் நூலகம்';

  @override
  String get course_1_title => 'Flutter அடிப்படைகள்';

  @override
  String get course_1_description =>
      'செய்முறை திட்டங்கள் மற்றும் நிஜ உலக உதாரணங்களுடன் Flutter மேம்பாட்டின் அடிப்படைகளைக் கற்றுக்கொள்ளுங்கள்.';

  @override
  String get course_2_title => 'மேம்பட்ட நிலை மேலாண்மை';

  @override
  String get course_2_description =>
      'Provider, Riverpod, மற்றும் Bloc உள்ளிட்ட நிலை மேலாண்மை முறைகளை ஆழமாகப் படிக்கவும்.';

  @override
  String get course_3_title => 'தனிப்பயன் அனிமேஷன்கள்';

  @override
  String get course_3_description =>
      'Flutter அனிமேஷன் கட்டமைப்பைப் பயன்படுத்தி அற்புதமான அனிமேஷன்களை உருவாக்கவும்.';

  @override
  String get course_4_title => 'Firebase ஒருங்கிணைப்பு';

  @override
  String get course_4_description =>
      'Firebase அங்கீகாரம், Firestore மற்றும் கிளவுட் செயல்பாடுகளுடன் தயாரிப்புக்கான பயன்பாடுகளை உருவாக்கவும்.';

  @override
  String get course_5_title => 'சோதனை உத்திகள்';

  @override
  String get course_5_description =>
      'Flutter பயன்பாடுகளுக்கான விரிவான யூனிட் மற்றும் ஒருங்கிணைப்பு சோதனைகளை எழுதவும்.';

  @override
  String get course_6_title => 'செயல்திறன் மேம்படுத்தல்';

  @override
  String get course_6_description =>
      'அனைத்து சாதனங்களிலும் மென்மையான 60fps செயல்திறனுக்காக உங்கள் Flutter பயன்பாடுகளை மேம்படுத்தவும்.';

  @override
  String get labelStart => 'தொடங்கு';

  @override
  String get labelContinue => 'தொடரவும்';

  @override
  String get labelRetry => 'மீண்டும் முயற்சி செய்';

  @override
  String get labelLoading => 'ஏற்றுகிறது...';

  @override
  String get labelGeneral => 'பொதுவானவை';

  @override
  String filterBy(String name) {
    return '$name மூலம் வடிகட்டவும்';
  }

  @override
  String get labelProgress => 'முன்னேற்றம்';

  @override
  String get labelResume => 'மீண்டும் தொடங்கு';

  @override
  String get labelCourseProgress => 'பாட முன்னேற்றம்';

  @override
  String get homeHeaderTitle => 'BrightMinds Academy';

  @override
  String get todayScheduleTitle => 'இன்றைய அட்டவணை';

  @override
  String get viewAllAction => 'அனைத்தையும் காண்க';

  @override
  String get nowAndNextSection => 'இப்போது & அடுத்து';

  @override
  String get deadlinesSection => 'கெடு தேதிகள்';

  @override
  String get upcomingTestsSection => 'வரவிருக்கும் தேர்வுகள்';

  @override
  String get laterTodaySection => 'இன்று பின்னர்';

  @override
  String get topLearnersTitle => 'இந்த வாரத்தின் சிறந்த கற்பவர்கள்';

  @override
  String get updatesAnnouncementsTitle => 'புதுப்பிப்புகள் & அறிவிப்புகள்';

  @override
  String get quickAccessTitle => 'விரைவு அணுகல்';

  @override
  String get greetingMorning => 'காலை வணக்கம்';

  @override
  String get greetingAfternoon => 'மதிய வணக்கம்';

  @override
  String get greetingEvening => 'மாலை வணக்கம்';

  @override
  String get shortcutRecordings => 'பதிவுகள்';

  @override
  String get shortcutPractice => 'பயிற்சி';

  @override
  String get shortcutTests => 'தேர்வுகள்';

  @override
  String get shortcutNotes => 'குறிப்புகள்';

  @override
  String get shortcutAskDoubt => 'சந்தேகம் கேள்';

  @override
  String get shortcutSchedule => 'அட்டவணை';

  @override
  String get learningPerformanceTitle => 'கற்றல் செயல்திறன்';

  @override
  String get profileLearningSnapshotTitle => 'உங்கள் கற்றல் ஒரு பார்வையில்';

  @override
  String get profileActiveCoursesTitle => 'உங்கள் தற்போதைய பாடங்கள்';

  @override
  String get profileRecentLearningTitle => 'உங்கள் சமீபத்திய கற்றல்';

  @override
  String get profileAccountSettingsTitle => 'கணக்கு மற்றும் விருப்பங்கள்';

  @override
  String get profileEditProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get profileNotifications => 'அறிவிப்புகள்';

  @override
  String get notificationsManagePreferences =>
      'உங்கள் அறிவிப்பு விருப்பங்களை நிர்வகிக்கவும்';

  @override
  String get notificationsLiveClassReminders => 'நேரலை வகுப்பு நினைவூட்டல்கள்';

  @override
  String get notificationsLiveClassRemindersDesc =>
      'உங்கள் நேரலை வகுப்புகள் தொடங்கும் முன் அறிவிப்பைப் பெறவும்';

  @override
  String get notificationsTestAssessmentAlerts =>
      'தேர்வு மற்றும் மதிப்பீட்டு விழிப்பூட்டல்கள்';

  @override
  String get notificationsTestAssessmentAlertsDesc =>
      'வரவிருக்கும் தேர்வுகள் மற்றும் கெடு தேதிகளுக்கான நினைவூட்டல்கள்';

  @override
  String get notificationsAnnouncementsUpdates =>
      'அறிவிப்புகள் மற்றும் புதுப்பிப்புகள்';

  @override
  String get notificationsAnnouncementsUpdatesDesc =>
      'முக்கியமான செய்திகள் மற்றும் தள புதுப்பிப்புகள்';

  @override
  String get notificationsAchievementsBadges => 'சாதனைகள் மற்றும் பேட்ஜ்கள்';

  @override
  String get notificationsAchievementsBadgesDesc =>
      'நீங்கள் சாதனைகளைப் பெறும்போது கொண்டாடவும்';

  @override
  String get notificationsStateOn => 'ஆன்';

  @override
  String get notificationsStateOff => 'ஆஃப்';

  @override
  String get profileCertificates => 'உங்கள் சான்றிதழ்கள்';

  @override
  String get profileLogout => 'வெளியேறு';

  @override
  String get logoutConfirmationTitle => 'வெளியேறவா?';

  @override
  String get logoutConfirmationMessage =>
      'உங்கள் கணக்கை அணுக மீண்டும் உள்நுழைய வேண்டும்';

  @override
  String get logoutButtonLabel => 'வெளியேறு';

  @override
  String get certificatesSubtitleAvailable =>
      'உங்கள் பாடநெறி முடித்த சான்றிதழ்களைப் பார்த்து பதிவிறக்கவும்';

  @override
  String get certificatesEmptyPaidNewDesc =>
      'இன்னும் சான்றிதழ்கள் கிடைக்கவில்லை';

  @override
  String get certificatesLockedBadge => 'திறக்க பாடத்தை முடிக்கவும்';

  @override
  String get certificatesUnlockedBadge => 'முடித்ததற்கான சான்றிதழ்';

  @override
  String get certificatesCourseProgress => 'பாட முன்னேற்றம்';

  @override
  String get certificatesKeepGoing =>
      'உங்கள் சான்றிதழைத் திறக்க தொடர்ந்து செல்லுங்கள்';

  @override
  String get certificatesContinueCourse => 'பாடத்தைத் தொடரவும்';

  @override
  String certificatesCompletedOn(String date) {
    return '$date அன்று முடிக்கப்பட்டது';
  }

  @override
  String get certificatesCertificateId => 'சான்றிதழ் ஐடி';

  @override
  String get certificatesViewCertificate => 'சான்றிதழைக் காண்க';

  @override
  String get certificatesDownload => 'பதிவிறக்கு';

  @override
  String get certificatesPreviewTitle => 'சான்றிதழ் முன்னோட்டம்';

  @override
  String get certificatesShareAchievementTitle => 'உங்கள் சாதனையைப் பகிரவும்';

  @override
  String get certificatesShareAchievementDescription =>
      'உங்கள் சாதனையை வெளிப்படுத்த இந்த சான்றிதழைப் பதிவிறக்கவும் அல்லது பகிரவும்';

  @override
  String get certificatesShare => 'பகிர்';

  @override
  String get certificatesHelpText =>
      'இந்த சான்றிதழ் டிஜிட்டல் முறையில் கையொப்பமிடப்பட்டுள்ளது மற்றும் சான்றிதழ் ஐடியைப் பயன்படுத்தி சரிபார்க்கலாம்';

  @override
  String get certificatesCertificateOfCompletion => 'முடித்ததற்கான சான்றிதழ்';

  @override
  String get certificatesCertifyLine => 'இது சான்றளிப்பது என்னவென்றால்';

  @override
  String get certificatesCompletedCourseLine =>
      'பாடத்தை வெற்றிகரமாக முடித்துள்ளார்';

  @override
  String certificatesAwardedOn(String date) {
    return '$date அன்று வழங்கப்பட்டது';
  }

  @override
  String get certificatesVerified => 'சரிபார்க்கப்பட்டது';

  @override
  String get activityStatusStarted => 'தொடங்கப்பட்டது';

  @override
  String activityScoreLabel(int score) {
    return 'மதிப்பெண்: $score%';
  }

  @override
  String activityProgressLabel(int progress) {
    return 'இதுவரை $progress% பார்க்கப்பட்டது';
  }

  @override
  String get profileTabTitle => 'சுயவிவரம்';

  @override
  String profileMembershipLabel(String date) {
    return '$date முதல் எங்களுடன் கற்கிறீர்கள்';
  }

  @override
  String get latestActivityLabel => 'சமீபத்திய செயல்பாடு';

  @override
  String streakMomentumLabel(int days) {
    return '$days நாள் தொடர்ச்சி';
  }

  @override
  String weeklyHoursLabel(String hours) {
    return 'இந்த வாரம் $hours மணி';
  }

  @override
  String get lessonsFinishedLabel => 'பாடங்கள்';

  @override
  String get testsAttemptedLabel => 'தேர்வுகள்';

  @override
  String get assessmentsDoneLabel => 'மதிப்பீடுகள்';

  @override
  String get strongestSubjectLabel => 'நீங்கள் இதில் வலுவாக உள்ளீர்கள்';

  @override
  String get weakSubjectLabel => 'இங்கு கவனம் தேவை';

  @override
  String get noActivityTitle => 'இன்னும் ஆய்வு செயல்பாடு இல்லை';

  @override
  String get noActivitySubtitle =>
      'வேகத்தை உருவாக்க ஒரு அமர்வுடன் தொடங்குங்கள்';

  @override
  String get allCaughtUpTitle => 'அனைத்தும் முடிந்தது!';

  @override
  String get noScheduledActivitiesSubtitle =>
      'தற்போது திட்டமிடப்பட்ட செயல்பாடுகள் எதுவும் இல்லை';

  @override
  String get liveLabel => 'நேரலை';

  @override
  String get importantLabel => 'முக்கியம்';

  @override
  String testTypeLabel(String type) {
    return '$type தேர்வு';
  }

  @override
  String get achievementsLabel => 'சாதனைகள்';

  @override
  String moreBadgesLabel(int count) {
    return 'மேலும் $count';
  }

  @override
  String get drawerMenuTitle => 'பட்டியல்';

  @override
  String get drawerBookmark => 'புக்மார்க்';

  @override
  String get drawerPosts => 'அறிவிப்புகள்';

  @override
  String get drawerAnalytics => 'பகுப்பாய்வு';

  @override
  String get drawerForum => 'விவாத மன்றம்';

  @override
  String get drawerDoubts => 'சந்தேகங்கள்';

  @override
  String get drawerCustomExam => 'தனிப்பயன் தேர்வு';

  @override
  String get drawerReports => 'அறிக்கைகள்';

  @override
  String get drawerProfile => 'சுயவிவரம்';

  @override
  String get drawerSettings => 'பயன்பாட்டு அமைப்புகள்';

  @override
  String get drawerLoginActivity => 'உள்நுழைவு செயல்பாடு';

  @override
  String get drawerLogout => 'வெளியேறு';

  @override
  String get drawerPrivacy => 'தனியுரிமைக் கொள்கை';

  @override
  String get drawerThemeLight => 'ஒளி பயன்முறை';

  @override
  String get drawerThemeDark => 'இருண்ட பயன்முறை';

  @override
  String drawerVersion(String version) {
    return 'பதிப்பு - $version';
  }

  @override
  String get studyTabTitle => 'படிப்பு';

  @override
  String get studySearchHint => 'பாடங்கள், அத்தியாயங்களைத் தேடுங்கள்';

  @override
  String get studyYourCoursesTitle => 'உங்கள் பாடங்கள்';

  @override
  String get studyLessonsTitle => 'பாடங்கள்';

  @override
  String get noCoursesAvailable => 'பாடநெறிகள் கிடைக்கவில்லை';

  @override
  String get selectExamToViewQuestions =>
      'கேள்வித் தாள்களைக் காண ஒரு தேர்வைத் தேர்ந்தெடுக்கவும்';

  @override
  String get filterVideo => 'வீடியோக்கள்';

  @override
  String get filterAssessment => 'மதிப்பீடுகள்';

  @override
  String get filterTest => 'தேர்வுகள்';

  @override
  String get filterNotes => 'குறிப்புகள்';

  @override
  String get filterAttachment => 'இணைப்புகள்';

  @override
  String get resumeStudyHeader => 'படிப்பை தொடரவும்';

  @override
  String get labelCompleted => 'முடிக்கப்பட்டது';

  @override
  String get errorGenericTitle => 'ஏதோ தவறு நடந்துவிட்டது';

  @override
  String get errorGenericMessage =>
      'தரவை ஏற்ற முடியவில்லை. உங்கள் இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorLessonLoad =>
      'பாடத்தை ஏற்ற முடியவில்லை. உங்கள் இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String errorLoadingLesson(String error) {
    return 'பாடத்தை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String get noQuestionsFound => 'கேள்விகள் எதுவும் காணப்படவில்லை.';

  @override
  String get semanticExamStatistics => 'தேர்வு புள்ளிவிவரங்கள்';

  @override
  String get semanticMarksPerQuestion => 'ஒவ்வொரு கேள்விக்கும் மதிப்பெண்கள்';

  @override
  String get semanticExamTimeline => 'தேர்வு காலக்கோடு';

  @override
  String get lessonNotFound => 'பாடம் காணப்படவில்லை';

  @override
  String get labelLessonsPlural => 'பாடங்கள்';

  @override
  String get labelContentsPlural => 'உள்ளடக்கங்கள்';

  @override
  String get curriculumBackButton => 'பின்செல்';

  @override
  String get commonCloseButton => 'மூடு';

  @override
  String curriculumChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count அத்தியாயங்கள்',
      one: '1 அத்தியாயம்',
    );
    return '$_temp0';
  }

  @override
  String courseContentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count உள்ளடக்கங்கள்',
      one: '1 உள்ளடக்கம்',
    );
    return '$_temp0';
  }

  @override
  String get filterAll => 'அனைத்தும்';

  @override
  String get curriculumLessonsLabel => 'பாடங்கள்';

  @override
  String get curriculumAssessmentsLabel => 'மதிப்பீடுகள்';

  @override
  String curriculumTestsCompletedLabel(Object count) {
    return '$count தேர்வுகள் முடிக்கப்பட்டன';
  }

  @override
  String chapterIndexLabel(int index, String title) {
    return 'அத்தியாயம் $index: $title';
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
  String get statusLocked => 'பூட்டப்பட்டது';

  @override
  String get statusInProgress => 'செயல்பாட்டில் உள்ளது';

  @override
  String get statusCompleted => 'முடிக்கப்பட்டது';

  @override
  String get chapterStatusRunning => 'இயங்குகிறது';

  @override
  String get chapterStatusUpcoming => 'வரவிருக்கிறது';

  @override
  String get chapterStatusHistory => 'வரலாறு';

  @override
  String get chapterTypeVideo => 'வீடியோ பாடம்';

  @override
  String get chapterTypePdf => 'PDF குறிப்புகள்';

  @override
  String get chapterTypeAssessment => 'பயிற்சி மதிப்பீடு';

  @override
  String get chapterTypeTest => 'தேர்வு';

  @override
  String get chapterTypeLiveStream => 'நேரலை ஸ்ட்ரீம்';

  @override
  String get chapterTypeEmbed => 'உட்பொதி உள்ளடக்கம்';

  @override
  String get chapterTypeNotes => 'குறிப்புகள்';

  @override
  String get chapterTypeAttachment => 'இணைப்பு';

  @override
  String get chapterTypeUnknown => 'தெரியவில்லை';

  @override
  String get chapterNoContent => 'உள்ளடக்கம் இல்லை';

  @override
  String get chapterNotFound => 'அத்தியாயம் காணவில்லை';

  @override
  String lessonXofY(int index, int total) {
    return 'பாடம் $index / $total';
  }

  @override
  String get lessonBookmarkAdd => 'பாடத்தை புக்மார்க் செய்';

  @override
  String get lessonBookmarkRemove => 'புக்மார்க்கை அகற்று';

  @override
  String get lessonDownload => 'பாடத்தைப் பதிவிறக்கு';

  @override
  String get navigationPrevious => 'முந்தைய பாடம்';

  @override
  String get navigationNext => 'அடுத்த பாடம்';

  @override
  String openDetailedLesson(String title) {
    return 'பாடத்தைத் திற: $title';
  }

  @override
  String get videoLessonTabNotes => 'குறிப்புகள்';

  @override
  String get videoLessonTabTranscript => 'டிரான்ஸ்கிரிப்ட்';

  @override
  String get videoLessonTabAskDoubt => 'சந்தேகம் கேள்';

  @override
  String get videoLessonTabAiSupport => 'AI ஆதரவு';

  @override
  String get videoLessonLectureNotes => 'விரிவுரை குறிப்புகள்';

  @override
  String get videoLessonDownloadPdf => 'PDF பதிவிறக்கு';

  @override
  String get videoLessonKeyFormula => 'முக்கிய சூத்திரம்';

  @override
  String get videoLessonTranscript => 'வீடியோ டிரான்ஸ்கிரிப்ட்';

  @override
  String get videoLessonContinueNext => 'அடுத்த பாடத்திற்குத் தொடரவும்';

  @override
  String get videoLessonAskYourDoubt => 'உங்கள் சந்தேகத்தைக் கேளுங்கள்';

  @override
  String get videoLessonDoubtDescription =>
      'இந்த விரிவுரையைப் பற்றி ஏதேனும் கேள்வி உள்ளதா? எங்கள் நிபுணர் 24 மணி நேரத்திற்குள் பதிலளிப்பார்.';

  @override
  String get videoLessonRecentDoubts => 'சமீபத்திய சந்தேகங்கள்';

  @override
  String get videoLessonPostYourDoubt => 'உங்கள் சந்தேகத்தை பதிவு செய்யவும்';

  @override
  String get videoLessonDoubtHint => 'உங்கள் கேள்வியை இங்கே தட்டச்சு செய்க...';

  @override
  String videoLessonCharacterCount(int current, int max) {
    return '$current/$max எழுத்துக்கள்';
  }

  @override
  String get videoLessonSubmitDoubt => 'சந்தேகத்தை சமர்ப்பி';

  @override
  String get videoLessonPending => 'நிலுவையில் உள்ளது';

  @override
  String get videoLessonAiAssistant => 'AI கற்றல் உதவியாளர்';

  @override
  String get videoLessonAiHelp => 'உங்கள் கேள்விகளுக்கு உடனடி உதவி பெறுங்கள்';

  @override
  String get videoLessonAiHint =>
      'இந்த விரிவுரையைப் பற்றி AI-யிடம் எதையும் கேளுங்கள்...';

  @override
  String get videoLessonAiDisclaimer =>
      'AI பதில்கள் உடனடியாக உருவாக்கப்படுகின்றன';

  @override
  String get testExit => 'தேர்விலிருந்து வெளியேறு';

  @override
  String testTimeLeft(Object time) {
    return '$time மீதமுள்ளது';
  }

  @override
  String testQuestionXofY(int index, int total) {
    return 'கேள்வி $index / $total';
  }

  @override
  String get testSaved => 'சேமிக்கப்பட்டது';

  @override
  String get testMarked => 'குறிக்கப்பட்டது';

  @override
  String get testMarkForReview => 'மதிப்பாய்வுக்கு குறிக்கவும்';

  @override
  String get testPrevious => 'முந்தையது';

  @override
  String get testNext => 'அடுத்தது';

  @override
  String get testFinish => 'முடித்துவிடு';

  @override
  String testViewAllQuestions(Object answered, Object total) {
    return 'அனைத்து கேள்விகளையும் காண்க ($answered/$total பதிலளிக்கப்பட்டது)';
  }

  @override
  String get testViewAllQuestionsShort => 'அனைத்து கேள்விகளையும் காண்க';

  @override
  String get testCompleteTitle => 'தேர்வு முடிந்தது!';

  @override
  String get testCompleteSubtitle =>
      'சிறந்த வேலை! நீங்கள் பயிற்சி தேர்வை முடித்துவிட்டீர்கள்.';

  @override
  String get testRetake => 'தேர்வை மீண்டும் எழுது';

  @override
  String get testBackToChapter => 'அத்தியாயத்திற்குத் திரும்பு';

  @override
  String testScorePercentage(Object percentage) {
    return '$percentage%';
  }

  @override
  String testScoreSummary(Object correct, Object total) {
    return '$total-ல் $correct சரியானவை';
  }

  @override
  String get testPaletteTitle => 'உங்கள் பதில்களை மதிப்பாய்வு செய்யவும்';

  @override
  String testPaletteAnsweredCount(Object answered, Object total) {
    return '$total-ல் $answered பதிலளிக்கப்பட்டது';
  }

  @override
  String get testStatusNotVisited => 'பதிலளிக்கப்படவில்லை';

  @override
  String get testStatusAnswered => 'பதிலளிக்கப்பட்டது';

  @override
  String get testStatusMarked => 'குறிக்கப்பட்டது';

  @override
  String get testStatusAnsweredMarked =>
      'பதிலளிக்கப்பட்டு மதிப்பாய்வு செய்யப்பட்டது';

  @override
  String testAttemptXofY(int index, int total) {
    return 'முயற்சி $index / $total';
  }

  @override
  String get testSelectAllApply =>
      'பொருந்தக்கூடிய அனைத்தையும் தேர்ந்தெடுக்கவும்';

  @override
  String get testSubmitConfirmationTitle => 'தேர்வை சமர்ப்பிக்கவா?';

  @override
  String testSubmitConfirmationBody(int answered, int total) {
    return 'நீங்கள் $total கேள்விகளில் $answered க்கு பதிலளித்துள்ளீர்கள்.';
  }

  @override
  String testSubmitConfirmationUnanswered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count கேள்விகள் பதிலளிக்கப்படவில்லை',
      one: '1 கேள்வி பதிலளிக்கப்படவில்லை',
      zero: 'அனைத்து கேள்விகளுக்கும் பதிலளிக்கப்பட்டது',
    );
    return '$_temp0';
  }

  @override
  String get labelCancel => 'ரத்துசெய்';

  @override
  String get labelSubmitNow => 'இப்போதே சமர்ப்பி';

  @override
  String get testSubmittedTitle => 'தேர்வு சமர்ப்பிக்கப்பட்டது!';

  @override
  String get testSubmittedBody =>
      'உங்கள் தேர்வு வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது.';

  @override
  String get testReview => 'மதிப்பாய்வு';

  @override
  String get testReviewAnswers => 'பதில்களை மதிப்பாய்வு செய்யவும்';

  @override
  String get testViewAnalytics => 'பகுப்பாய்வுகளைக் காண்க';

  @override
  String get assessmentCheckAnswer => 'பதிலைச் சரிபார்க்கவும்';

  @override
  String get assessmentCorrect => 'சரியானது!';

  @override
  String get assessmentIncorrect => 'சரியல்ல';

  @override
  String get assessmentTryAgain => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get assessmentNext => 'அடுத்தது';

  @override
  String get assessmentExplanation => 'விளக்கம்';

  @override
  String get assessmentPracticeComplete => 'பயிற்சி மதிப்பீடு முடிந்தது!';

  @override
  String get assessmentExit => 'மதிப்பீட்டிலிருந்து வெளியேறு';

  @override
  String get assessmentPaletteTitle => 'கேள்வித் தட்டு';

  @override
  String get assessmentUnanswered => 'பதிலளிக்கப்படவில்லை';

  @override
  String get assessmentBackToChapter => 'அத்தியாயத்திற்குத் திரும்பு';

  @override
  String get examReviewTitle => 'தேர்வு மதிப்பாய்வு';

  @override
  String get examReviewFilterWrong => 'தவறு';

  @override
  String get examReviewFilterCorrect => 'சரி';

  @override
  String get examReviewFilterUnanswered => 'பதிலளிக்கப்படவில்லை';

  @override
  String get examReviewCorrectAnswerLabel => 'சரியான பதில்:';

  @override
  String get examReviewYourAnswerLabel => 'உங்கள் பதில்:';

  @override
  String get examReviewFilterAnswered => 'பதிலளிக்கப்பட்டது';

  @override
  String get labelAskDoubt => 'சந்தேகம் கேள்';

  @override
  String get labelComment => 'கருத்து';

  @override
  String get labelReport => 'புகாரளி';

  @override
  String get labelReported => 'புகாரளிக்கப்பட்டது';

  @override
  String get labelOverallSummary => 'ஒட்டுமொத்த சுருக்கம்';

  @override
  String get labelFilter => 'வடிகட்டி:';

  @override
  String get labelAccuracy => 'துல்லியம்';

  @override
  String get labelScore => 'மதிப்பெண்';

  @override
  String get labelTimeTaken => 'எடுத்துக்கொண்ட நேரம்';

  @override
  String get labelPercentile => 'சதவீதம்';

  @override
  String get labelRank => 'தரம்';

  @override
  String get labelPerformance => 'செயல்திறன்';

  @override
  String get labelSubject => 'பாடம்';

  @override
  String get labelAttempted => 'முயற்சிக்கப்பட்டது';

  @override
  String get labelTotalQuestions => 'மொத்த கேள்விகள்';

  @override
  String get performanceExcellent => 'மிகச் சிறப்பு';

  @override
  String get performanceGood => 'நன்று';

  @override
  String get performanceAverage => 'சராசரி';

  @override
  String get performancePoor => 'மோசம்';

  @override
  String get recommendationHigh => 'உயர்';

  @override
  String get recommendationMedium => 'நடுத்தரம்';

  @override
  String get recommendationLow => 'குறைந்த';

  @override
  String get reviewAskDoubtTitle => 'சந்தேகம் கேள்';

  @override
  String get reviewSubmitDoubt => 'சந்தேகத்தை சமர்ப்பி';

  @override
  String get reviewAddCommentTitle => 'கருத்தைச் சேர்';

  @override
  String get reviewPostComment => 'கருத்தைப் பதிவிடு';

  @override
  String get reviewReportIssueTitle => 'சிக்கலைப் புகாரளி';

  @override
  String get reviewSubmitReport => 'புகாரைச் சமர்ப்பி';

  @override
  String get reviewReportSuccess => 'புகார் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது';

  @override
  String get reviewReportFailed => 'புகாரைச் சமர்ப்பிக்க முடியவில்லை';

  @override
  String reviewReportIssueWithQuestion(int number) {
    return 'கேள்வி $number இல் ஒரு சிக்கலைப் புகாரளி';
  }

  @override
  String get reviewDescribeDoubtHint =>
      'உங்கள் சந்தேகத்தை இங்கே விவரிக்கவும்...';

  @override
  String get reviewWriteCommentHint => 'உங்கள் கருத்தை எழுதுங்கள்...';

  @override
  String get reviewReportOptionErrorInQuestion => 'கேள்வியில் பிழை';

  @override
  String get reviewReportOptionIncorrectAnswer => 'தவறான பதில்';

  @override
  String get reviewReportOptionNoExplanation => 'விளக்கம் இல்லை';

  @override
  String get reviewReportOptionIncompleteExplanation => 'முழுமையற்ற விளக்கம்';

  @override
  String get reviewReportOptionOthers => 'மற்றவை';

  @override
  String get reviewReportDetailsHint =>
      'கூடுதல் விவரங்கள் (விருப்பத்திற்குரியது)...';

  @override
  String reviewShareThoughtsOnQuestion(int number) {
    return 'கேள்வி $number பற்றி உங்கள் கருத்துகளைப் பகிரவும்';
  }

  @override
  String reviewQuestionLabel(String number) {
    return 'கேள்வி $number';
  }

  @override
  String get examsEmptyStateDesc => 'தற்போது எந்த தேர்வுகளும் இல்லை.';

  @override
  String get customExamTitle => 'தனிப்பயன் தேர்வு';

  @override
  String get customExamCourseSelectionInfo =>
      'ஒரு பாடநெறியைத் தேர்ந்தெடுத்த பிறகு, பாடங்கள், கடினத்தன்மை நிலை, தேர்வு முறை மற்றும் கேள்விகளின் எண்ணிக்கையை நீங்கள் தேர்ந்தெடுக்கலாம்.';

  @override
  String get customExamLoadingCourse => 'பாடநெறியின் பெயர் ஏற்றப்படுகிறது...';

  @override
  String get customExamSelectedCourse => 'தேர்ந்தெடுக்கப்பட்ட பாடநெறி';

  @override
  String get customExamQuestionType => 'கேள்வி வகை';

  @override
  String get customExamSelectQuestionType =>
      'கேள்விகளின் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customExamTestMode => 'தேர்வு முறை';

  @override
  String get customExamChooseTestExperience =>
      'தேர்வு அனுபவத்தைத் தேர்வுசெய்யவும்';

  @override
  String get customExamNumberOfQuestions => 'கேள்விகளின் எண்ணிக்கை';

  @override
  String get customExamChooseNumberOfQuestions =>
      'கேள்விகளின் எண்ணிக்கையைத் தேர்வுசெய்யவும்';

  @override
  String get customExamSelectOneOrMoreSubjects =>
      'ஒன்று அல்லது அதற்கு மேற்பட்ட பாடங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customExamSelectDifficultyLevel =>
      'கடினத்தன்மை நிலையைத் தேர்ந்தெடுக்கவும்';

  @override
  String customExamRemoveItem(String item) {
    return '$item ஐ அகற்று';
  }

  @override
  String get reviewEmptyStateMessage =>
      'இந்த வடிகட்டிக்கு கேள்விகள் எதுவும் கிடைக்கவில்லை.';

  @override
  String reviewAnswersTitle(String title) {
    return 'பதில்களை மதிப்பாய்வு செய் - $title';
  }

  @override
  String reviewQuestionCount(int current, int total) {
    return '$total இல் $current';
  }

  @override
  String get settingsAppearanceTitle => 'தோற்றம்';

  @override
  String get settingsPlaybackTitle => 'கற்றல் & இயக்கம்';

  @override
  String get settingsAccessibilityTitle => 'அணுகல்தன்மை';

  @override
  String get settingsLanguageTitle => 'மொழி';

  @override
  String get settingsVideoQuality => 'காணொளி தரம்';

  @override
  String get settingsVideoQualityCaption =>
      'உங்கள் விருப்பமான இயல்புநிலை தரத்தை அமைக்கவும்';

  @override
  String get settingsAutoPlay => 'அடுத்த பாடத்தை தானாக இயக்கு';

  @override
  String get settingsTextSize => 'உரை அளவு';

  @override
  String get settingsHighContrast => 'அதிக முரண்பாடு';

  @override
  String get settingsDescription =>
      'உங்கள் கற்றல் அனுபவத்தைத் தனிப்பயனாக்குங்கள்';

  @override
  String get settingsThemeLightMode => 'ஒளி பயன்முறை';

  @override
  String get settingsThemeDarkMode => 'இருண்ட பயன்முறை';

  @override
  String get settingsThemeSystemDefault => 'கணினி இயல்புநிலை';

  @override
  String get settingsPlaybackDescription => 'பின்னணி தரத்தைத் தேர்வுசெய்க';

  @override
  String get settingsTextSizeDescription => 'வாசிப்பு வசதியைச் சரிசெய்யவும்';

  @override
  String get settingsRecommended => 'பரிந்துரைக்கப்படுகிறது';

  @override
  String get settingsDefault => 'இயல்புநிலை';

  @override
  String get settingsAutoPlaySubtitle => 'அடுத்த பாடத்தை தானாகத் தொடங்கு';

  @override
  String get settingsHighContrastSubtitle => 'காட்சி முரண்பாட்டை அதிகரிக்கவும்';

  @override
  String get editProfileTitle => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get editProfileNameLabel => 'முழு பெயர்';

  @override
  String get editProfileNameHint => 'உங்கள் முழு பெயரை உள்ளிடவும்';

  @override
  String get editProfileEmailLabel => 'மின்னஞ்சல்';

  @override
  String get editProfileEmailHint => 'உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get editProfileEmailHelper => 'மின்னஞ்சலை மாற்ற முடியாது';

  @override
  String get editProfilePhoneLabel => 'தொலைபேசி எண்';

  @override
  String get editProfilePhoneHint => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get editProfileSave => 'சேமி';

  @override
  String get editProfileSuccess => 'சுயவிவரம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get editProfileErrorNameEmpty => 'பெயர் காலியாக இருக்கக்கூடாது';

  @override
  String get editProfilePhotoLabel => 'சுயவிவரப் புகைப்படம்';

  @override
  String get editProfileChangePhoto => 'புகைப்படத்தை மாற்று';

  @override
  String get editProfileBack => 'பின்செல்';

  @override
  String get exploreTabTitle => 'ஆராயுங்கள்';

  @override
  String get exploreSearchHint => 'பாடங்கள், தலைப்புகளைத் தேடுங்கள்...';

  @override
  String get exploreSearchResultsTitle => 'தேடல் முடிவுகள்';

  @override
  String get exploreTrendingTitle => 'தற்போது பிரபலமாக இருப்பவை';

  @override
  String get exploreRecommendedTitle => 'உங்களுக்காக பரிந்துரைக்கப்படுகிறது';

  @override
  String get exploreShortLessonsTitle => 'அதிகம் பார்க்கப்பட்ட வீடியோக்கள்';

  @override
  String get explorePopularTestsTitle => 'பிரபலமான தேர்வுகள்';

  @override
  String get exploreStudyTipsTitle => 'கற்றல் குறிப்புகள் & புதுப்பிப்புகள்';

  @override
  String get exploreFilterTrending => 'பிரபலமானவை';

  @override
  String get exploreFilterRecommended => 'பரிந்துரைக்கப்பட்டவை';

  @override
  String get exploreFilterShortLessons => 'குறுகிய பாடங்கள்';

  @override
  String get exploreFilterPopular => 'பிரபலமானவை';

  @override
  String get exploreFilterStudyTips => 'கற்றல் குறிப்புகள்';

  @override
  String get editProfileFirstNameLabel => 'முதல் பெயர்';

  @override
  String get editProfileFirstNameHint => 'உங்கள் முதல் பெயரை உள்ளிடவும்';

  @override
  String get editProfileLastNameLabel => 'கடைசி பெயர்';

  @override
  String get editProfileLastNameHint => 'உங்கள் கடைசி பெயரை உள்ளிடவும்';

  @override
  String get labelMock => 'மாதிரி';

  @override
  String get labelPractice => 'பயிற்சி';

  @override
  String get forumTitle => 'விவாத மன்றம்';

  @override
  String get forumFilterTitle => 'வடிகட்டிகள்';

  @override
  String get forumFilterByActivity => 'செயல்பாட்டின்படி வடிகட்டுக';

  @override
  String get forumFilterClearAll => 'அனைத்தையும் அழி';

  @override
  String get forumBackSemantic => 'பின்செல்';

  @override
  String get forumFilterSemantic => 'வடிகட்டி';

  @override
  String get forumFilterActivityPosted => 'நான் பதிவிட்டது';

  @override
  String get forumFilterActivityCommented => 'நான் கருத்துத் தெரிவித்தது';

  @override
  String get forumFilterActivityLiked => 'நான் விரும்பியது';

  @override
  String get forumFilterActivityBookmarked => 'நான் குறித்தது';

  @override
  String get forumSortRecent => 'சமீபத்தியவை';

  @override
  String get forumSortMostLiked => 'அதிகம் விரும்பப்பட்டவை';

  @override
  String get forumSortMostViewed => 'அதிகம் பார்க்கப்பட்டவை';

  @override
  String get forumSelectCourse =>
      'விவாதங்களைக் காண ஒரு பாடத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String forumThreadsCount(int count) {
    return '$count இழைகள்';
  }

  @override
  String forumUnansweredCount(int count) {
    return '$count பதிலளிக்கப்படாதவை';
  }

  @override
  String get forumLabelAnswered => 'பதிலளிக்கப்பட்டது';

  @override
  String get forumLabelUnanswered => 'பதிலளிக்கப்படவில்லை';

  @override
  String get forumSearchDiscussions => 'விவாதங்களைத் தேடுங்கள்';

  @override
  String get forumCreatePost => 'புதிய இடுகையை உருவாக்கு';

  @override
  String get forumNoDiscussions => 'விவாதங்கள் எதுவும் காணப்படவில்லை';

  @override
  String get forumDiscussion => 'விவாதம்';

  @override
  String get forumReplyPlaceholder => 'உங்கள் பதிலை இங்கே எழுதுங்கள்...';

  @override
  String get forumCreateNewPost => 'புதிய இடுகையை உருவாக்கு';

  @override
  String get forumPostTitleHint => 'ஒரு தலைப்பைச் சேர்க்கவும்...';

  @override
  String get forumPostDescriptionHint =>
      'உங்கள் கேள்வியை விரிவாக விவரிக்கவும்...';

  @override
  String get forumPostSubjectLabel => 'தலைப்பு';

  @override
  String get forumPostDescriptionLabel => 'விளக்கம்';

  @override
  String get forumPostCategoryLabel => 'வகை';

  @override
  String get forumPostSelectCategoryTitle => 'வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get forumButtonSubmit => 'சமர்ப்பி';

  @override
  String get forumButtonCancel => 'ரத்துசெய்';

  @override
  String attachmentSize(String size) {
    return 'அளவு: $size';
  }

  @override
  String get attachmentDownload => 'பதிவிறக்கு';

  @override
  String get attachmentDownloading => 'பதிவிறக்கப்படுகிறது...';

  @override
  String get attachmentViewFile => 'பதிவிறக்கிய கோப்பைக் காண்க';

  @override
  String get dashboardWhatsNewTitle => 'புதியவை என்ன';

  @override
  String get dashboardRecentlyCompletedTitle => 'சமீபத்தில் முடிக்கப்பட்டவை';

  @override
  String get dashboardResumeTitle => 'கற்றலை மீண்டும் தொடங்கு';

  @override
  String get downloadsTitle => 'பதிவிறக்கங்கள்';

  @override
  String get downloadsVideosTab => 'வீடியோக்கள்';

  @override
  String get downloadsAttachmentsTab => 'இணைப்புகள்';

  @override
  String downloadsVideosTabCount(int count) {
    return 'வீடியோக்கள் ($count)';
  }

  @override
  String downloadsAttachmentsTabCount(int count) {
    return 'இணைப்புகள் ($count)';
  }

  @override
  String get downloadsEmpty => 'பதிவிறக்கங்கள் எதுவும் கிடைக்கவில்லை';

  @override
  String get downloadsEmptyVideosSubtitle =>
      'நீங்கள் பதிவிறக்கிய வீடியோக்கள் இங்கே தோன்றும்';

  @override
  String get downloadsEmptyAttachmentsSubtitle =>
      'நீங்கள் பதிவிறக்கிய கோப்புகள் இங்கே தோன்றும்';

  @override
  String downloadsTotalVideos(int count) {
    return 'மொத்த வீடியோக்கள்: $count';
  }

  @override
  String downloadsTotalFiles(int count) {
    return 'மொத்த கோப்புகள்: $count';
  }

  @override
  String downloadsStorageUsed(String size) {
    return '$size பயன்படுத்தப்பட்டுள்ளது';
  }

  @override
  String get doubtsEmptyTitle => 'சந்தேகங்கள் எதுவும் கிடைக்கவில்லை';

  @override
  String get doubtsEmptySubtitle =>
      'வழிகாட்டிகளிடமிருந்து உதவி பெற உங்கள் முதல் சந்தேகத்தைக் கேளுங்கள்.';

  @override
  String get doubtsSearchNoResults => 'பொருத்தங்கள் எதுவும் காணப்படவில்லை';

  @override
  String get doubtsSearchNoResultsSubtitle =>
      'உங்கள் தேடல் வினவலைச் சரிசெய்து முயற்சிக்கவும்';

  @override
  String get doubtsHeaderAskDoubt => 'சந்தேகம் கேள்';

  @override
  String get doubtsSearchHint => 'சந்தேகங்களைத் தேடு';

  @override
  String get doubtsLabelUnanswered => 'பதிலளிக்கப்படவில்லை';

  @override
  String get doubtsLabelAnswered => 'பதிலளிக்கப்பட்டது';

  @override
  String doubtsReplyCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பதில்கள்',
      one: '1 பதில்',
    );
    return '$_temp0';
  }

  @override
  String get doubtsFormTitleLabel => 'உங்கள் சந்தேகம் எதைப்பற்றியது?';

  @override
  String get doubtsFormTitleHint =>
      'உதாரணமாக, இந்த கேள்வியை என்னால் புரிந்து கொள்ள முடியவில்லை';

  @override
  String get doubtsFormDescriptionLabel =>
      'உங்கள் சந்தேகம் பற்றி விரிவாக விளக்கவும்';

  @override
  String get doubtsFormCategoryLabel => 'தலைப்பைத் தேர்ந்தெடுக்கவும்';

  @override
  String get doubtsFormAttachmentsLabel => 'இணைப்புகள் (விருப்பத்திற்குரியது)';

  @override
  String get doubtsFormUploadAction => 'படம் அல்லது PDF ஐ பதிவேற்று';

  @override
  String get doubtsFormSubmitAction => 'சந்தேகத்தை சமர்ப்பி';

  @override
  String get doubtsFormNextAction => 'அடுத்தது';

  @override
  String get doubtsSubmitSheetTitle =>
      'நீங்கள் எப்படி கேட்க விரும்புகிறீர்கள்?';

  @override
  String get doubtsSubmitSheetAskAi => 'AI இடம் கேள்';

  @override
  String get doubtsSubmitSheetAskAiDesc =>
      'உங்கள் சந்தேகத்திற்கு உடனடி AI-உருவாக்கப்பட்ட பதிலைப் பெறுங்கள்';

  @override
  String get doubtsSubmitSheetAskMentor => 'வழிகாட்டியிடம் கேள்';

  @override
  String get doubtsSubmitSheetAskMentorDesc =>
      'உங்கள் சந்தேகத்திற்கு வழிகாட்டியின் உதவியைப் பெறுங்கள்';

  @override
  String get doubtsSubmitSuccessMessage =>
      'சந்தேகம் வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது';

  @override
  String get doubtsSubmitErrorMessage =>
      'சந்தேகத்தை சமர்ப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get doubtsFormCancelAction => 'ரத்துசெய்';

  @override
  String get doubtsFormTopicsLabel => 'தலைப்புகள்';

  @override
  String get doubtsFormIdkLabel => 'எனக்குத் தெரியாது';

  @override
  String get doubtsFormFailedToLoadTopics => 'தலைப்புகளை ஏற்ற முடியவில்லை';

  @override
  String get examInstructions => 'தேர்வு வழிமுறைகள்';

  @override
  String get startExam => 'தேர்வைத் தொடங்கு';

  @override
  String get examTotalQuestions => 'மொத்த கேள்விகள்';

  @override
  String get examDuration => 'கால அளவு';

  @override
  String get examTotalMarks => 'மொத்த மதிப்பெண்கள்';

  @override
  String get examCorrectAnswer => 'சரியான பதில்';

  @override
  String get examWrongAnswer => 'தவறான பதில்';

  @override
  String get examStartsOn => 'தொடங்கும் தேதி';

  @override
  String get examEndsOn => 'முடியும் தேதி';

  @override
  String get examForever => 'என்றென்றும்';

  @override
  String get examDetailsTitle => 'தேர்வு விவரங்கள்';

  @override
  String get errorCannotStartExam => 'மன்னிக்கவும்! தேர்வைத் தொடங்க முடியாது';

  @override
  String get errorUnknownOccurred => 'அறியப்படாத பிழை ஏற்பட்டது.';

  @override
  String get actionGoBack => 'திரும்பிச் செல்';

  @override
  String get nextSubject => 'அடுத்த பாடம்';

  @override
  String get nextSection => 'அடுத்த பகுதி';

  @override
  String get doubtDetailTitle => 'சந்தேகம்';

  @override
  String get errorFailedToLoadReplies => 'பதில்களை ஏற்ற முடியவில்லை';

  @override
  String get errorFailedToLoadDoubtDetails =>
      'சந்தேக விவரங்களை ஏற்ற முடியவில்லை';

  @override
  String get labelMentor => 'வழிகாட்டி';

  @override
  String get infoPageTitle => 'கற்றல் வளங்கள்';

  @override
  String get infoPageSubtitle =>
      'விவரங்களைக் காண ஒரு வளத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get infoPageEmptyState => 'கற்றல் வளங்கள் இன்னும் கிடைக்கவில்லை.';

  @override
  String get infoPageLoadError =>
      'வளங்களை ஏற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String infoPageOpenCourse(String title) {
    return 'திற: $title';
  }

  @override
  String infoPageLessonsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பாடங்கள்',
      one: '1 பாடம்',
    );
    return '$_temp0';
  }

  @override
  String get videoLessonNoTranscriptAvailable =>
      'இந்த பாடத்திற்கான டிரான்ஸ்கிரிப்ட் கிடைக்கவில்லை.';

  @override
  String get videoLessonTranscriptionInProgress =>
      'டிரான்ஸ்கிரிப்ஷன் செயல்பாட்டில் உள்ளது';

  @override
  String get videoLessonTranscriptionInProgressDesc =>
      'இந்த வீடியோவிற்கான டிரான்ஸ்கிரிப்டை தற்போது உருவாக்குகிறோம். சிறிது நேரம் கழித்து சரிபார்க்கவும்.';

  @override
  String get videoLessonFailedToLoadTranscript =>
      'டிரான்ஸ்கிரிப்டை ஏற்ற முடியவில்லை.';

  @override
  String get videoLessonNoNotesAvailable =>
      'இந்த பாடத்திற்கு குறிப்புகள் எதுவும் கிடைக்கவில்லை.';

  @override
  String get videoLessonNotesEmpty => 'குறிப்புகள் தற்போது காலியாக உள்ளன.';

  @override
  String get videoLessonFailedToLoadNotes =>
      'விரிவுரை குறிப்புகளை ஏற்ற முடியவில்லை.';

  @override
  String get labelSave => 'சேமி';

  @override
  String get labelUncategorized => 'வகைப்படுத்தப்படாதவை';

  @override
  String get labelNewFolder => 'புதிய கோப்புறை';

  @override
  String get actionCreateNewFolder => 'புதிய கோப்புறையை உருவாக்கு';

  @override
  String get hintEnterFolderName => 'கோப்புறையின் பெயரை உள்ளிடவும்';

  @override
  String get hintExampleFolderName => 'உதாரணமாக: இயற்பியல், திருப்புதல்';

  @override
  String get errorFailedToLoadFolders => 'கோப்புறைகளை ஏற்ற முடியவில்லை.';

  @override
  String get errorFailedToCreateFolder =>
      'கோப்புறையை உருவாக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get bookmarkSaveToFolders =>
      'பிளேலிஸ்ட் அல்லது கோப்புறைகளில் சேமிக்கவும்';

  @override
  String get bookmarkSaveTo => 'சேமி...';

  @override
  String bookmarkAddedToFolder(String folderName) {
    return '$folderName கோப்புறையில் புக்மார்க் சேர்க்கப்பட்டது';
  }

  @override
  String bookmarkRemovedFromFolder(String folderName) {
    return '$folderName கோப்புறையிலிருந்து புக்மார்க் அகற்றப்பட்டது';
  }

  @override
  String get bookmarkRemoved => 'புக்மார்க் அகற்றப்பட்டது';

  @override
  String get errorFailedToUpdateBookmark =>
      'புக்மார்க்கைப் புதுப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get errorFailedToRemoveBookmark =>
      'புக்மார்க்கை அகற்ற முடியவில்லை. மீண்டும் முயற்சிக்கவும்.';

  @override
  String lessonSpecializedViewerRequired(String type) {
    return '$type க்கு சிறப்புப் பார்வையாளர் தேவை';
  }

  @override
  String get leaderboardTitle => 'தரவரிசைப் பலகை';

  @override
  String get leaderboardRankListTab => 'தரவரிசை பட்டியல்';

  @override
  String get leaderboardCompetitorsTab => 'போட்டியாளர்கள்';

  @override
  String get leaderboardTimelineThisWeek => 'இந்த வாரம்';

  @override
  String get leaderboardTimelineThisMonth => 'இந்த மாதம்';

  @override
  String get leaderboardTimelineAllTime => 'எல்லா நேரமும்';

  @override
  String get leaderboardNoLearnersFound => 'கற்பவர்கள் எவரும் காணப்படவில்லை';

  @override
  String get leaderboardErrorLoading => 'தரவரிசைப் பலகையை ஏற்றுவதில் பிழை';

  @override
  String get leaderboardNoCompetitorsFound => 'போட்டியாளர்கள் யாரும் இல்லை';

  @override
  String get leaderboardErrorLoadingCompetitors =>
      'போட்டியாளர்களை ஏற்றுவதில் பிழை';

  @override
  String get leaderboardYouSuffix => ' (நீங்கள்)';

  @override
  String get loginActivityCurrentDevice => 'தற்போதைய சாதனம்';

  @override
  String get loginActivityNoActivityFound =>
      'உள்நுழைவு செயல்பாடு எதுவும் காணப்படவில்லை';

  @override
  String get loginActivityLogoutOtherDevices =>
      'பிற சாதனங்களிலிருந்து வெளியேறு';

  @override
  String get loginActivityLogoutSuccess =>
      'பிற சாதனங்களிலிருந்து வெற்றிகரமாக வெளியேறினீர்கள்';

  @override
  String get actionMarkAsResolved => 'தீர்க்கப்பட்டதாகக் குறிக்கவும்';

  @override
  String get actionCloseDoubt => 'சந்தேகத்தை மூடு';

  @override
  String get messageDoubtResolved =>
      'இந்த சந்தேகம் தீர்க்கப்பட்டதாக குறிக்கப்பட்டுள்ளது.';

  @override
  String get messageDiscussionClosed =>
      'இந்த விவாத இழை மூடப்பட்டுள்ளது மற்றும் படிக்க மட்டுமே முடியும்.';

  @override
  String get loginActivityLogoutFailed => 'வெளியேற முடியவில்லை';

  @override
  String get forumErrorFailedToCreatePost => 'இடுகையை உருவாக்க முடியவில்லை';

  @override
  String get forumErrorDiscussionNotFound => 'விவாதம் காணப்படவில்லை';

  @override
  String get forumErrorLoadingComments => 'கருத்துகளை ஏற்றுவதில் பிழை';

  @override
  String get forumCommentsEmptyTitle => 'இன்னும் கருத்துகள் இல்லை';

  @override
  String get forumCommentsEmptySubtitle =>
      'இந்த இழைக்கு முதலில் பதிலளிக்கவும்.';

  @override
  String forumRepliesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count பதில்கள்',
      one: '1 பதில்',
    );
    return '$_temp0';
  }

  @override
  String get forumRoleInstructor => 'பயிற்றுவிப்பாளர்';

  @override
  String get forumPendingModeration => 'மதிப்பீட்டிற்காக காத்திருக்கிறது';

  @override
  String get forumErrorFailedToPostReply => 'பதிலை இடுகையிட முடியவில்லை';

  @override
  String get noAnnouncementsFound => 'அறிவிப்புகள் எதுவும் காணப்படவில்லை.';

  @override
  String get commentsDisabledByAdmin =>
      'இந்த இடுகைக்கு நிர்வாகியால் கருத்துகள் முடக்கப்பட்டுள்ளன';

  @override
  String bookmarkFolderItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count உருப்படிகள்',
      one: '1 உருப்படி',
    );
    return '$_temp0';
  }

  @override
  String get bookmarksTitle => 'புக்மார்க்குகள்';

  @override
  String get bookmarkFilterAllContents => 'அனைத்து உள்ளடக்கங்களும்';

  @override
  String get bookmarkFilterQuestions => 'கேள்விகள்';

  @override
  String get bookmarkFilterVideos => 'வீடியோக்கள்';

  @override
  String get bookmarkFilterPDFs => 'PDF-கள்';

  @override
  String get bookmarkFilterNotes => 'குறிப்புகள்';

  @override
  String get bookmarkFilterExamsAndQuiz => 'தேர்வுகள் மற்றும் வினாடி வினாக்கள்';

  @override
  String get bookmarkFilterLiveClasses => 'நேரலை வகுப்புகள்';

  @override
  String get bookmarkSortRecent => 'சமீபத்தியவை';

  @override
  String get bookmarkSortOldest => 'பழையவை';

  @override
  String get bookmarkSortLastlyOpened => 'கடைசியாக திறக்கப்பட்டவை';

  @override
  String get bookmarkTabAll => 'அனைத்தும்';

  @override
  String get bookmarkTabFolders => 'கோப்புறைகள்';

  @override
  String get bookmarkActionRenameFolder => 'கோப்புறையின் பெயரை மாற்று';

  @override
  String get bookmarkActionDeleteFolder => 'கோப்புறையை நீக்கு';

  @override
  String get bookmarkActionMoveBookmark => 'புக்மார்க்கை நகர்த்து';

  @override
  String get bookmarkActionRemoveBookmark => 'புக்மார்க்கை அகற்று';

  @override
  String get bookmarkDeleteFolderConfirmation =>
      'இந்த கோப்புறையை நிச்சயமாக நீக்க விரும்புகிறீர்களா?';

  @override
  String get bookmarkLabelContentType => 'உள்ளடக்க வகை';

  @override
  String get bookmarkLabelSortBy => 'வரிசைப்படுத்து';

  @override
  String get bookmarkActionCreateFolder => 'கோப்புறையை உருவாக்கு';

  @override
  String get bookmarkLabelName => 'பெயர்';

  @override
  String get bookmarkActionDelete => 'நீக்கு';

  @override
  String get actionCheck => 'சரிபார்க்கவும்';

  @override
  String get examModeSelectTitle => 'தேர்வு முறையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get examModeRegularTitle => 'வழக்கமான முறை';

  @override
  String get examModeRegularDesc =>
      'நேரக் கட்டுப்பாடுடன் கூடிய சாதாரண தேர்வு முறையில் தேர்வை எழுதவும்.';

  @override
  String get examModeQuizTitle => 'வினாடி வினா முறை';

  @override
  String get examModeQuizDesc =>
      'ஒவ்வொரு கேள்விக்கும் உடனுக்குடன் பதில்களைச் சரிபார்க்கவும்.';

  @override
  String get resumeExamOnline => 'தேர்வை ஆன்லைனில் தொடரவும்';

  @override
  String get startExamOnline => 'தேர்வை ஆன்லைனில் தொடங்கவும்';

  @override
  String get retakeExamOnline => 'மீண்டும் எழுதுக';

  @override
  String get retakeIncorrectExamOnline => 'தவறானவற்றை மீண்டும் செய்';

  @override
  String get examPreviousAttempts => 'முந்தைய முயற்சிகள்';

  @override
  String get labelDate => 'தேதி';

  @override
  String get analyticsInvalidTopicId => 'தவறான தலைப்பு ஐடி';

  @override
  String get analyticsTopicNotFound => 'தலைப்பு கிடைக்கவில்லை';

  @override
  String analyticsErrorLoadingTopic(String error) {
    return 'தலைப்பு பகுப்பாய்வை ஏற்றுவதில் பிழை: $error';
  }

  @override
  String get analyticsSubCategory => 'துணை வகை';

  @override
  String get analyticsStrength => 'பலம்';

  @override
  String get analyticsWeakness => 'பலவீனம்';

  @override
  String get analyticsUnanswered => 'பதிலளிக்கப்படாதவை';

  @override
  String get analyticsCorrect => 'சரியானது';

  @override
  String get analyticsIncorrect => 'தவறானது';

  @override
  String get analyticsAccuracy => 'துல்லியம்';

  @override
  String get analyticsNoSubjectsFound => 'பாடங்கள் எதுவும் கிடைக்கவில்லை.';

  @override
  String filterEmptyStateMessage(String name) {
    return '$name எதுவும் கிடைக்கவில்லை.';
  }

  @override
  String get labelExams => 'தேர்வுகள்';

  @override
  String get analyticsStrengthCorrect => 'பலம் / சரியானது';

  @override
  String get analyticsWeaknessIncorrect => 'பலவீனம் / தவறானது';

  @override
  String get analyticsSubjectUppercase => 'பாடம்';

  @override
  String get analyticsCorrectUppercase => 'சரியானது';

  @override
  String get analyticsIncorrectUppercase => 'தவறானது';

  @override
  String get analyticsUnansweredUppercase => 'பதிலளிக்கப்படாதவை';

  @override
  String get analyticsFilterSubjects => 'பாடங்களை வடிகட்டு';

  @override
  String get analyticsGraphReports => 'வரைபட அறிக்கைகள்';

  @override
  String get analyticsTableReports => 'அட்டவணை அறிக்கைகள்';

  @override
  String analyticsSelectTab(String label) {
    return '$label தாவலைத் தேர்ந்தெடு';
  }

  @override
  String get customExamCreateTitle => 'தனிப்பயன் தேர்வு';

  @override
  String get customExamSelectCourse => 'ஒரு பாடநெறியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customExamSearchCourses => 'பாடநெறிகளைத் தேடுக';

  @override
  String get customExamNoCoursesFound => 'பாடநெறிகள் எதுவும் கிடைக்கவில்லை';

  @override
  String get customExamStepScope => 'படி 1: பயிற்சியின் வரம்பு';

  @override
  String get customExamFullCourse => 'முழு பாடநெறி பயிற்சி';

  @override
  String get customExamCoverAllTopics => 'அனைத்து தலைப்புகளையும் உள்ளடக்கும்';

  @override
  String get customExamSpecificCourse =>
      'ஒரு குறிப்பிட்ட பாடநெறியைப் பயிற்சி செய்யவும்';

  @override
  String customExamCoursePrefix(String name) {
    return 'பாடநெறி: $name';
  }

  @override
  String get customExamStepSource => 'படி 2: கேள்வி ஆதாரம்';

  @override
  String get customExamSourcePrevYear => 'முந்தைய ஆண்டுக் கேள்விகள்';

  @override
  String get customExamSourceBoard => 'வாரியத் தேர்வு வினாத்தாள்கள்';

  @override
  String get customExamSourceImportant => 'முக்கியமான கேள்விகள்';

  @override
  String get customExamStepCount => 'படி 3: கேள்விகளின் எண்ணிக்கை';

  @override
  String get customExamStepDifficulty => 'படி 4: சிரம நிலை';

  @override
  String get customExamDiffEasy => 'எளிது';

  @override
  String get customExamDiffMedium => 'நடுத்தரம்';

  @override
  String get customExamDiffHard => 'கடினம்';

  @override
  String get customExamDiffMixed => 'கலப்பு';

  @override
  String get customExamStepMode => 'படி 5: தேர்வு முறை';

  @override
  String get customExamModeQuiz => 'வினாடி வினா';

  @override
  String get customExamModeQuizDesc =>
      'ஒவ்வொரு கேள்விக்கும் பிறகு உடனடி பின்னூட்டமும் விளக்கமும் பெறுங்கள்';

  @override
  String get customExamModeTest => 'தேர்வு';

  @override
  String get customExamModeTestDesc =>
      'நேரக் கணிப்பானுடன் உண்மையான தேர்வு போல எழுதுங்கள்; இறுதியில் முடிவைப் பெறுங்கள்';

  @override
  String get customExamBtnCreate => 'தனிப்பயன் தேர்வு';

  @override
  String get customExamBtnGoBack => 'திரும்பிச் செல்';

  @override
  String customExamCountLabel(int count) {
    return '$count கேள்விகள்';
  }

  @override
  String get customExamSelectAtLeastOneSubject =>
      'குறைந்தபட்சம் ஒரு பாடத்தையாவது தேர்ந்தெடுக்கவும்';

  @override
  String get customExamDifficultyLevel => 'கடினத்தன்மை நிலை';

  @override
  String get customExamGenerateCustomExam => 'தனிப்பயன் தேர்வை உருவாக்கு';

  @override
  String get customExamPleaseSelectAtLeastOneQuestionType =>
      'குறைந்தபட்சம் ஒரு கேள்வி வகையையாவது தேர்ந்தெடுக்கவும்';

  @override
  String get customExamPleaseSelectTestMode =>
      'தேர்வு முறையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customExamErrorLoading => 'பாடநெறிகளை ஏற்றுவதில் பிழை';

  @override
  String get customExamSelectSubjects => 'பாடங்களைத் தேர்ந்தெடுக்கவும்';

  @override
  String get customExamDailyLimitExhausted =>
      'தனிப்பயன் தேர்வுகளுக்கான உங்கள் தினசரி வரம்புகள் முடிந்துவிட்டன.';

  @override
  String get customExamMonthlyLimitExhausted =>
      'தனிப்பயன் தேர்வுகளுக்கான உங்கள் மாதாந்திர வரம்புகள் முடிந்துவிட்டன.';

  @override
  String get examsTabTitle => 'தேர்வுகள்';

  @override
  String get availableExamCoursesTitle => 'கிடைக்கக்கூடிய தேர்வுப் படிப்புகள்';

  @override
  String get testSubmitting => 'தேர்வு சமர்ப்பிக்கப்படுகிறது...';

  @override
  String get reviewSubjectPerformanceTitle => 'பாட வாரியான செயல்திறன்';

  @override
  String get labelOverallPerformance => 'ஒட்டுமொத்த செயல்திறன்';

  @override
  String get labelSectionPerformance => 'பிரிவு செயல்திறன்';

  @override
  String get reviewSubjectPerformanceDesc =>
      'ஒவ்வொரு பாடத்திலும் உங்கள் செயல்திறனின் விவரம்';

  @override
  String reviewSubjectAnalyticsError(String error) {
    return 'பாடப் பகுப்பாய்வை ஏற்ற முடியவில்லை: $error';
  }

  @override
  String testScoreResult(String score) {
    return 'உங்கள் மதிப்பெண்: $score';
  }

  @override
  String get reviewPerformanceOverviewTitle => 'செயல்திறன் கண்ணோட்டம்';

  @override
  String get reviewSubjectPerformanceTileDesc =>
      'வெவ்வேறு பாடங்களில் உங்கள் செயல்திறனை பகுப்பாய்வு செய்யுங்கள்';

  @override
  String get reviewExploreDetailsTitle => 'கூடுதல் விவரங்களை ஆராயுங்கள்';

  @override
  String get reviewExamReviewTitle => 'தேர்வு மதிப்பாய்வு';

  @override
  String get reviewExamReviewDesc =>
      'பதில்கள் மற்றும் விளக்கங்களுடன் ஒவ்வொரு கேள்வியையும் மதிப்பாய்வு செய்யவும்';

  @override
  String reviewAnalyticsForTitle(String title) {
    return '$title க்கான மதிப்பாய்வு பகுப்பாய்வு';
  }

  @override
  String get defaultStudentName => 'மாணவர்';

  @override
  String get examCompletedLabel => 'தேர்வு முடிந்தது';

  @override
  String get downloadingExam => 'தேர்வு பதிவிறக்கப்படுகிறது...';

  @override
  String get deadlinePassedCannotSync =>
      'காலக்கெடு முடிந்தது. தேர்வை ஒத்திசைக்க முடியாது.';

  @override
  String get pendingSyncConnectToUpload =>
      'ஒத்திசைக்க காத்திருக்கிறது. பதில்களைப் பதிவேற்ற இணையத்துடன் இணைக்கவும்.';

  @override
  String get resumeOfflineExam => 'ஆஃப்லைன் தேர்வை மீண்டும் தொடங்கு';

  @override
  String get startOfflineExam => 'ஆஃப்லைன் தேர்வைத் தொடங்கு';

  @override
  String get downloadExamOffline => 'தேர்வைப் பதிவிறக்கு (ஆஃப்லைன்)';

  @override
  String get testSavedLocallyOffline =>
      'தேர்வு லோக்கலாக சேமிக்கப்பட்டது. ஒத்திசைக்கப்பட்டதும் முடிவுகள் கிடைக்கும்.';

  @override
  String get noAnswerGiven => '(பதில் அளிக்கப்படவில்லை)';

  @override
  String get correctAnswerLabel => 'சரியான பதில்:';

  @override
  String get errorOfflineDataNotFound =>
      'தேர்வு தரவு கிடைக்கவில்லை. உங்கள் பதில்கள் சமர்ப்பிக்கப்படாமல் போகலாம்.';

  @override
  String get reviewScore => 'மதிப்பெண்';

  @override
  String get reviewPerformanceExcellent => 'சிறப்பான செயல்பாடு';

  @override
  String get reviewPerformanceAverage => 'சராசரி செயல்பாடு';

  @override
  String get reviewPerformanceLow => 'முன்னேற்றம் தேவை';

  @override
  String get reviewAttempted => 'முயற்சித்தவை';

  @override
  String get reviewCorrect => 'சரியானவை';

  @override
  String get reviewAccuracy => 'துல்லியம்';

  @override
  String get reviewTimeTaken => 'எடுத்துக்கொண்ட நேரம்';

  @override
  String get reviewRank => 'தரம்';

  @override
  String get reviewPercentile => 'சதவீதம்';

  @override
  String get reviewOfTotal => 'மொத்தத்தில்';

  @override
  String get lessonDetails => 'பாடம் விவரங்கள்';

  @override
  String questionIdArgs(String id) {
    return 'கேள்வி ஐடி: $id';
  }

  @override
  String get customExamPleaseSelectDifficultyLevel =>
      'தயவுசெய்து கடினத்தன்மை நிலையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get exploreProductBack => 'பின்செல்க';

  @override
  String get exploreSelectPlan => 'திட்டத்தை தேர்ந்தெடுக்கவும்';

  @override
  String get exploreBuyNow => 'இப்போது வாங்குங்கள்';

  @override
  String get exploreCheckoutComingSoon => 'செக்அவுட் செயல்முறை விரைவில் வரும்';

  @override
  String exploreValidityDays(String days) {
    return 'செல்லுபடியாகும் காலம்: $days நாட்கள்';
  }

  @override
  String exploreFromTo(String start, String end) {
    return '$start முதல் $end வரை';
  }

  @override
  String get exploreNoProductsFound => 'எந்த தயாரிப்புகளும் கிடைக்கவில்லை.';

  @override
  String get exploreProductsLabel => 'தயாரிப்புகள்';

  @override
  String get exploreCategoriesLabel => 'வகைகள்';

  @override
  String explorePlanSelected(String planName, String price) {
    return '$planName, ₹$price, தேர்ந்தெடுக்கப்பட்டது';
  }

  @override
  String explorePlanUnselected(String planName, String price) {
    return '$planName, ₹$price';
  }

  @override
  String get exploreDescription => 'விளக்கம்';

  @override
  String get exploreCurriculum => 'பாடத்திட்டம்';

  @override
  String get exploreHaveDiscountCode => 'தள்ளுபடி குறியீடு உள்ளதா?';

  @override
  String get explorePayInstallments => 'தவணைகளில் செலுத்தவும்';

  @override
  String get exploreDiscountCoupon => 'தள்ளுபடி கூப்பன்';

  @override
  String get exploreChoosePlan => 'ஒரு திட்டத்தை தேர்வு செய்யவும்';

  @override
  String explorePayAmountNow(String amount) {
    return '₹$amount இப்போது செலுத்தவும்';
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
    return 'தவணை $installment';
  }

  @override
  String get exploreCouponHint => 'கூப்பன் குறியீட்டை உள்ளிடவும்';

  @override
  String get exploreApplyCoupon => 'பயன்படுத்து';

  @override
  String get exploreNoInstallmentPlans =>
      'இந்த தயாரிப்புக்கு தவணைத் திட்டங்கள் எதுவும் இல்லை.';

  @override
  String get exploreLoading => 'ஏற்றுகிறது...';

  @override
  String get exploreFailedToLoadPlans => 'திட்டங்களை ஏற்றுவதில் தோல்வி';

  @override
  String exploreInstallmentPlansCalculationBase(String price) {
    return '₹$price அசல் விலையின் அடிப்படையில் தவணைத் திட்டங்கள் கணக்கிடப்படுகின்றன.';
  }

  @override
  String explorePaidOn(String date) {
    return '$date இல் செலுத்தப்பட்டது';
  }

  @override
  String get exploreNoContentAvailable => 'உள்ளடக்கம் எதுவும் இல்லை';

  @override
  String get paymentProcessing => 'உங்கள் கட்டணத்தை செயலாக்குகிறது...';

  @override
  String get paymentSuccessful => 'கட்டணம் வெற்றிகரமாக செலுத்தப்பட்டது!';

  @override
  String get paymentSuccessDescription =>
      'உங்கள் பதிவு வெற்றிகரமாக உறுதிசெய்யப்பட்டுள்ளது.';

  @override
  String get paymentFailed => 'கட்டணம் தோல்வியடைந்தது';

  @override
  String get paymentFailedDescription =>
      'ஏதோ தவறு நடந்துவிட்டது. தயவுசெய்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get paymentPending => 'கட்டணம் நிலுவையில் உள்ளது';

  @override
  String get paymentPendingDescription => 'உங்கள் கட்டணம் செயலாக்கப்படுகிறது.';

  @override
  String get paymentCancelled => 'கட்டணம் ரத்துசெய்யப்பட்டது';

  @override
  String get paymentCancelledDescription =>
      'நீங்கள் கட்டணத்தை ரத்து செய்துவிட்டீர்கள்.';

  @override
  String get paymentStartLearning => 'கற்கத் தொடங்கு';

  @override
  String get paymentBackToHome => 'முகப்புக்குத் திரும்பு';

  @override
  String get paymentTryAgain => 'மீண்டும் முயற்சி செய்';

  @override
  String get paymentCancel => 'ரத்துசெய்';
}
