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
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginPasswordSubtitle =>
      'Sign in using your username and password';

  @override
  String get loginOtpSubtitle => 'Sign in using OTP verification';

  @override
  String get loginModePassword => 'Password';

  @override
  String get loginModeOtp => 'OTP';

  @override
  String get loginUsernameLabel => 'Username or email';

  @override
  String get loginUsernameHint => 'Enter username or email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter password';

  @override
  String get loginSigningIn => 'Signing in...';

  @override
  String get loginCountryCodeLabel => 'Country code';

  @override
  String get loginCountryCodeHint => '+91';

  @override
  String get loginPhoneNumberLabel => 'Phone number';

  @override
  String get loginPhoneNumberHint => '9876543210';

  @override
  String get loginEmailOptionalLabel => 'Email (optional)';

  @override
  String get loginEmailHint => 'student@example.com';

  @override
  String get loginGenerateOtp => 'Generate OTP';

  @override
  String get loginSendingOtp => 'Sending OTP...';

  @override
  String get loginOtpCodeLabel => 'OTP';

  @override
  String get loginOtpCodeHint => '1234';

  @override
  String get loginVerifyOtp => 'Verify OTP';

  @override
  String get loginVerifyingOtp => 'Verifying...';

  @override
  String get loginOtpSentInfo => 'OTP sent. Enter the code to continue.';

  @override
  String get loginErrorUsernamePasswordRequired =>
      'Username and password are required.';

  @override
  String get loginErrorOtpIdentityRequired =>
      'Country code and phone number are required for OTP.';

  @override
  String get loginErrorPhoneOtpRequired => 'Phone number and OTP are required.';

  @override
  String get loginErrorGenericRequest =>
      'Unable to complete request. Please try again.';

  @override
  String get loginErrorInvalidCredentials => 'Incorrect username or password.';

  @override
  String get loginErrorValidation =>
      'Please check and correct the entered fields.';

  @override
  String get loginErrorThrottled =>
      'Too many attempts. Please wait before retrying.';

  @override
  String get loginErrorLockout =>
      'This account is locked. Contact your administrator.';

  @override
  String get loginErrorNetwork =>
      'Network error. Check your internet connection.';

  @override
  String get loginErrorServer => 'Server error. Please try again shortly.';

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
  String get labelRetry => 'Retry';

  @override
  String get labelLoading => 'Loading...';

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
  String get viewAllAction => 'View all';

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
  String get profileLearningSnapshotTitle => 'Your learning at a glance';

  @override
  String get profileActiveCoursesTitle => 'Your active courses';

  @override
  String get profileRecentLearningTitle => 'Your recent learning';

  @override
  String get profileAccountSettingsTitle => 'Account & preferences';

  @override
  String get profileEditProfile => 'Edit Profile';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get notificationsManagePreferences =>
      'Manage your notification preferences';

  @override
  String get notificationsLiveClassReminders => 'Live class reminders';

  @override
  String get notificationsLiveClassRemindersDesc =>
      'Get notified before your live classes start';

  @override
  String get notificationsTestAssessmentAlerts => 'Test and assessment alerts';

  @override
  String get notificationsTestAssessmentAlertsDesc =>
      'Reminders for upcoming tests and deadlines';

  @override
  String get notificationsAnnouncementsUpdates => 'Announcements and updates';

  @override
  String get notificationsAnnouncementsUpdatesDesc =>
      'Important news and platform updates';

  @override
  String get notificationsAchievementsBadges => 'Achievements and badges';

  @override
  String get notificationsAchievementsBadgesDesc =>
      'Celebrate when you earn achievements';

  @override
  String get notificationsStateOn => 'On';

  @override
  String get notificationsStateOff => 'Off';

  @override
  String get profileCertificates => 'Your certificates';

  @override
  String get profileLogout => 'Logout';

  @override
  String get logoutConfirmationTitle => 'Log out?';

  @override
  String get logoutConfirmationMessage =>
      'You\'ll need to log in again to access your account';

  @override
  String get logoutButtonLabel => 'Log out';

  @override
  String get certificatesSubtitleAvailable =>
      'View and download your course completion certificates';

  @override
  String get certificatesEmptyPaidNewDesc => 'No certificates available yet';

  @override
  String get certificatesLockedBadge => 'COMPLETE COURSE TO UNLOCK';

  @override
  String get certificatesUnlockedBadge => 'CERTIFICATE OF COMPLETION';

  @override
  String get certificatesCourseProgress => 'Course progress';

  @override
  String get certificatesKeepGoing => 'Keep going to unlock your certificate';

  @override
  String get certificatesContinueCourse => 'Continue Course';

  @override
  String certificatesCompletedOn(String date) {
    return 'Completed on $date';
  }

  @override
  String get certificatesCertificateId => 'Certificate ID';

  @override
  String get certificatesViewCertificate => 'View Certificate';

  @override
  String get certificatesDownload => 'Download';

  @override
  String get certificatesPreviewTitle => 'Certificate Preview';

  @override
  String get certificatesShareAchievementTitle => 'Share your achievement';

  @override
  String get certificatesShareAchievementDescription =>
      'Download or share this certificate to showcase your accomplishment';

  @override
  String get certificatesShare => 'Share';

  @override
  String get certificatesHelpText =>
      'This certificate is digitally signed and can be verified using the certificate ID';

  @override
  String get certificatesCertificateOfCompletion => 'Certificate of Completion';

  @override
  String get certificatesCertifyLine => 'This is to certify that';

  @override
  String get certificatesCompletedCourseLine =>
      'has successfully completed the course';

  @override
  String certificatesAwardedOn(String date) {
    return 'Awarded on $date';
  }

  @override
  String get certificatesVerified => 'Verified';

  @override
  String get activityStatusStarted => 'Started';

  @override
  String activityScoreLabel(int score) {
    return 'Score: $score%';
  }

  @override
  String activityProgressLabel(int progress) {
    return '$progress% watched so far';
  }

  @override
  String get profileTabTitle => 'Profile';

  @override
  String profileMembershipLabel(String date) {
    return 'Learning with us since $date';
  }

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
    return '$type Test';
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
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get errorGenericMessage =>
      'Failed to load data. Please check your connection and try again.';

  @override
  String get labelLessonsPlural => 'lessons';

  @override
  String get labelContentsPlural => 'contents';

  @override
  String get curriculumBackButton => 'Back';

  @override
  String get commonCloseButton => 'Close';

  @override
  String curriculumChaptersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chapters',
      one: '1 Chapter',
    );
    return '$_temp0';
  }

  @override
  String courseContentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contents',
      one: '1 content',
    );
    return '$_temp0';
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

  @override
  String get chapterStatusRunning => 'Running';

  @override
  String get chapterStatusUpcoming => 'Upcoming';

  @override
  String get chapterStatusHistory => 'History';

  @override
  String get chapterTypeVideo => 'Video Lesson';

  @override
  String get chapterTypePdf => 'PDF Notes';

  @override
  String get chapterTypeAssessment => 'Practice Assessment';

  @override
  String get chapterTypeTest => 'Test';

  @override
  String get chapterNoContent => 'No content available';

  @override
  String get chapterNotFound => 'Chapter not found';

  @override
  String lessonXofY(int index, int total) {
    return 'Lesson $index of $total';
  }

  @override
  String get lessonBookmarkAdd => 'Bookmark lesson';

  @override
  String get lessonBookmarkRemove => 'Remove bookmark';

  @override
  String get lessonDownload => 'Download lesson';

  @override
  String get navigationPrevious => 'Previous';

  @override
  String get navigationNext => 'Next Lesson';

  @override
  String openDetailedLesson(String title) {
    return 'Open lesson: $title';
  }

  @override
  String get videoLessonTabNotes => 'Notes';

  @override
  String get videoLessonTabTranscript => 'Transcript';

  @override
  String get videoLessonTabAskDoubt => 'Ask Doubt';

  @override
  String get videoLessonTabAiSupport => 'AI Support';

  @override
  String get videoLessonLectureNotes => 'Lecture Notes';

  @override
  String get videoLessonDownloadPdf => 'Download PDF';

  @override
  String get videoLessonKeyFormula => 'Key Formula';

  @override
  String get videoLessonTranscript => 'Video Transcript';

  @override
  String get videoLessonContinueNext => 'Continue to Next Lesson';

  @override
  String get videoLessonAskYourDoubt => 'Ask Your Doubt';

  @override
  String get videoLessonDoubtDescription =>
      'Have a question about this lecture? Our expert instructors will answer within 24 hours.';

  @override
  String get videoLessonRecentDoubts => 'Recent Doubts';

  @override
  String get videoLessonPostYourDoubt => 'Post Your Doubt';

  @override
  String get videoLessonDoubtHint =>
      'Type your question here... Be specific about what you\'re confused about.';

  @override
  String videoLessonCharacterCount(int current, int max) {
    return '$current/$max characters';
  }

  @override
  String get videoLessonSubmitDoubt => 'Submit Doubt';

  @override
  String get videoLessonPending => 'Pending';

  @override
  String get videoLessonAiAssistant => 'AI Study Assistant';

  @override
  String get videoLessonAiHelp => 'Get instant help with your questions';

  @override
  String get videoLessonAiHint => 'Ask AI anything about this lecture...';

  @override
  String get videoLessonAiDisclaimer =>
      'AI responses are generated instantly and based on lecture content';

  @override
  String get testExit => 'Exit Test';

  @override
  String testTimeLeft(Object time) {
    return '$time left';
  }

  @override
  String testQuestionXofY(int index, int total) {
    return 'Question $index of $total';
  }

  @override
  String get testSaved => 'Saved';

  @override
  String get testMarked => 'Marked';

  @override
  String get testMarkForReview => 'Mark for Review';

  @override
  String get testPrevious => 'Previous';

  @override
  String get testNext => 'Next';

  @override
  String get testFinish => 'Finish';

  @override
  String testViewAllQuestions(Object answered, Object total) {
    return 'View All Questions ($answered/$total answered)';
  }

  @override
  String get testCompleteTitle => 'Test Complete!';

  @override
  String get testCompleteSubtitle =>
      'Great job! You\'ve completed the practice test.';

  @override
  String get testRetake => 'Retake Test';

  @override
  String get testBackToChapter => 'Back to Chapter';

  @override
  String testScorePercentage(Object percentage) {
    return '$percentage%';
  }

  @override
  String testScoreSummary(Object correct, Object total) {
    return '$correct out of $total correct';
  }

  @override
  String get testPaletteTitle => 'Hey! Review Your Answers';

  @override
  String testPaletteAnsweredCount(Object answered, Object total) {
    return '$answered of $total answered';
  }

  @override
  String get testStatusNotVisited => 'Not visited';

  @override
  String get testStatusAnswered => 'Answered';

  @override
  String get testStatusMarked => 'Marked';

  @override
  String get testStatusAnsweredMarked => 'Answered & Reviewed';

  @override
  String testAttemptXofY(int index, int total) {
    return 'Attempt $index of $total';
  }

  @override
  String get testSelectAllApply => 'Select all that apply';

  @override
  String get testSubmitConfirmationTitle => 'Submit Test?';

  @override
  String testSubmitConfirmationBody(int answered, int total) {
    return 'You have answered $answered out of $total questions.';
  }

  @override
  String testSubmitConfirmationUnanswered(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions remain unanswered',
      one: '1 question remains unanswered',
      zero: 'All questions answered',
    );
    return '$_temp0';
  }

  @override
  String get labelCancel => 'Cancel';

  @override
  String get labelSubmitNow => 'Submit Now';

  @override
  String get testSubmittedTitle => 'Test Submitted!';

  @override
  String get testSubmittedBody =>
      'Your test has been successfully submitted. Review your answers or view detailed analytics.';

  @override
  String get testReviewAnswers => 'Review Answers';

  @override
  String get testViewAnalytics => 'View Analytics';

  @override
  String get assessmentCheckAnswer => 'Check Answer';

  @override
  String get assessmentCorrect => 'Correct!';

  @override
  String get assessmentIncorrect => 'Not quite right';

  @override
  String get assessmentTryAgain => 'Try Again';

  @override
  String get assessmentNext => 'Next';

  @override
  String get assessmentExplanation => 'Explanation';

  @override
  String get assessmentPracticeComplete => 'Practice Assessment Complete!';

  @override
  String get assessmentExit => 'Exit Assessment';

  @override
  String get assessmentPaletteTitle => 'Question Palette';

  @override
  String get assessmentUnanswered => 'Unanswered';

  @override
  String get assessmentBackToChapter => 'Back to Chapter';

  @override
  String get examReviewTitle => 'Exam Review';

  @override
  String get examReviewFilterWrong => 'Wrong';

  @override
  String get examReviewFilterCorrect => 'Correct';

  @override
  String get examReviewFilterUnanswered => 'Unanswered';

  @override
  String get examReviewCorrectAnswerLabel => 'Correct Answer:';

  @override
  String get examReviewYourAnswerLabel => 'Your Answer:';

  @override
  String get examReviewFilterAnswered => 'Answered';

  @override
  String get labelAskDoubt => 'Ask Doubt';

  @override
  String get labelComment => 'Comment';

  @override
  String get labelReport => 'Report';

  @override
  String get labelOverallSummary => 'Overall Summary';

  @override
  String get labelFilter => 'Filter:';

  @override
  String get labelAccuracy => 'Accuracy';

  @override
  String get labelScore => 'Score';

  @override
  String get labelTimeTaken => 'Time Taken';

  @override
  String get labelPercentile => 'Percentile';

  @override
  String get labelRank => 'Rank';

  @override
  String get labelPerformance => 'Performance';

  @override
  String get labelSubject => 'Subject';

  @override
  String get labelAttempted => 'Attempted';

  @override
  String get labelTotalQuestions => 'Total Questions';

  @override
  String get performanceExcellent => 'Excellent';

  @override
  String get performanceGood => 'Good';

  @override
  String get performanceAverage => 'Average';

  @override
  String get performancePoor => 'Poor';

  @override
  String get recommendationHigh => 'High';

  @override
  String get recommendationMedium => 'Medium';

  @override
  String get recommendationLow => 'Low';

  @override
  String get reviewAskDoubtTitle => 'Ask a Doubt';

  @override
  String get reviewSubmitDoubt => 'Submit Doubt';

  @override
  String get reviewAddCommentTitle => 'Add Comment';

  @override
  String get reviewPostComment => 'Post Comment';

  @override
  String get reviewReportIssueTitle => 'Report Issue';

  @override
  String get reviewSubmitReport => 'Submit Report';

  @override
  String reviewReportIssueWithQuestion(int number) {
    return 'Report an issue with Question $number';
  }

  @override
  String get reviewDescribeDoubtHint => 'Describe your doubt here...';

  @override
  String get reviewWriteCommentHint => 'Write your comment...';

  @override
  String get reviewReportOptionIncorrect =>
      'Incorrect answer marked as correct';

  @override
  String get reviewReportOptionUnclear => 'Question is unclear';

  @override
  String get reviewReportOptionWrongExplanation => 'Explanation is wrong';

  @override
  String get reviewReportOptionOther => 'Other issue';

  @override
  String get reviewReportDetailsHint => 'Additional details (optional)...';

  @override
  String reviewShareThoughtsOnQuestion(int number) {
    return 'Share your thoughts on Question $number';
  }

  @override
  String reviewQuestionLabel(String number) {
    return 'Question $number';
  }

  @override
  String get reviewEmptyStateMessage => 'No questions found for this filter.';

  @override
  String reviewAnswersTitle(String title) {
    return 'Review Answers - $title';
  }

  @override
  String reviewQuestionCount(int current, int total) {
    return '$current of $total';
  }

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsPlaybackTitle => 'Learning & Playback';

  @override
  String get settingsAccessibilityTitle => 'Accessibility';

  @override
  String get settingsVideoQuality => 'Video quality';

  @override
  String get settingsVideoQualityCaption =>
      'Set your preferred default quality';

  @override
  String get settingsAutoPlay => 'Auto-play next lesson';

  @override
  String get settingsTextSize => 'Text size';

  @override
  String get settingsHighContrast => 'High Contrast';

  @override
  String get settingsDescription => 'Customize your learning experience';

  @override
  String get settingsThemeLightMode => 'Light mode';

  @override
  String get settingsThemeDarkMode => 'Dark mode';

  @override
  String get settingsThemeSystemDefault => 'System default';

  @override
  String get settingsPlaybackDescription => 'Choose playback quality';

  @override
  String get settingsTextSizeDescription => 'Adjust reading comfort';

  @override
  String get settingsRecommended => 'Recommended';

  @override
  String get settingsDefault => 'Default';

  @override
  String get settingsAutoPlaySubtitle => 'Automatically start the next lesson';

  @override
  String get settingsHighContrastSubtitle => 'Increase visual contrast';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileNameLabel => 'Full Name';

  @override
  String get editProfileNameHint => 'Enter your full name';

  @override
  String get editProfileEmailLabel => 'Email';

  @override
  String get editProfileEmailHint => 'Enter your email address';

  @override
  String get editProfileEmailHelper => 'Email cannot be changed';

  @override
  String get editProfilePhoneLabel => 'Phone Number';

  @override
  String get editProfilePhoneHint => 'Enter your phone number';

  @override
  String get editProfileSave => 'Save';

  @override
  String get editProfileSuccess => 'Profile updated successfully';

  @override
  String get editProfileErrorNameEmpty => 'Name cannot be empty';

  @override
  String get editProfilePhotoLabel => 'Profile Photo';

  @override
  String get editProfileChangePhoto => 'Change photo';

  @override
  String get editProfileBack => 'Back';

  @override
  String get exploreTabTitle => 'Explore';

  @override
  String get exploreSearchHint => 'Search courses, lessons, topics...';

  @override
  String get exploreSearchResultsTitle => 'Search Results';

  @override
  String get exploreTrendingTitle => 'Trending Now';

  @override
  String get exploreRecommendedTitle => 'Recommended For You';

  @override
  String get exploreShortLessonsTitle => 'Most Viewed Videos';

  @override
  String get explorePopularTestsTitle => 'Popular Tests';

  @override
  String get exploreStudyTipsTitle => 'Study Tips & Updates';

  @override
  String get exploreFilterTrending => 'Trending';

  @override
  String get exploreFilterRecommended => 'Recommended';

  @override
  String get exploreFilterShortLessons => 'Short Lessons';

  @override
  String get exploreFilterPopular => 'Popular';

  @override
  String get exploreFilterStudyTips => 'Study Tips';

  @override
  String get labelMock => 'Mock';

  @override
  String get labelPractice => 'Practice';
}
