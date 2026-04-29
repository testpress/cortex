import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/info_mock_data.dart';
import '../models/info_models.dart';

final infoCoursesProvider = Provider<List<InfoCourse>>(
  (ref) => mockInfoCourses,
);

final infoCourseByIdProvider = Provider.family<InfoCourse?, String>(
  (ref, courseId) {
    final courses = ref.watch(infoCoursesProvider);
    for (final course in courses) {
      if (course.id == courseId) return course;
    }
    return null;
  },
);

typedef InfoLauncher = Future<bool> Function(Uri uri);

final infoLauncherProvider = Provider<InfoLauncher>((ref) {
  return (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
});

