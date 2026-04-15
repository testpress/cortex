import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/client_info_mock_data.dart';
import '../models/client_info_models.dart';

final clientInfoCoursesProvider = Provider<List<ClientInfoCourse>>(
  (ref) => mockClientInfoCourses,
);

final clientInfoCourseByIdProvider = Provider.family<ClientInfoCourse?, String>(
  (ref, courseId) {
    final courses = ref.watch(clientInfoCoursesProvider);
    for (final course in courses) {
      if (course.id == courseId) return course;
    }
    return null;
  },
);

typedef ClientInfoLauncher = Future<bool> Function(Uri uri);

final clientInfoLauncherProvider = Provider<ClientInfoLauncher>((ref) {
  return (uri) => launchUrl(uri, mode: LaunchMode.externalApplication);
});
