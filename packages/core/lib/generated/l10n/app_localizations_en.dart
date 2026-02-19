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
  String get labelCourseProgress => 'Course progress';
}
