import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

/// Centralized navigation helper for lessons.
class LessonRouter {
  /// Navigates to the appropriate detail screen for a lesson.
  /// 
  /// Supports [LessonDto], [DashboardContentDto], and other models
  /// that expose an ID and content type.
  static void navigateToLesson(BuildContext context, {required String id, required dynamic type}) {
    final typeStr = type is Enum ? type.name.toLowerCase() : type.toString().toLowerCase();
    
    final routeName = switch (typeStr) {
      'video' || 'pdf' || 'notes' || 'embedcontent' || 'livestream' || 'attachment' => 
          AppRouteNames.lessonDetail,
      'test' => AppRouteNames.testDetail,
      'assessment' => AppRouteNames.assessmentDetail,
      _ => null,
    };

    if (routeName != null) {
      context.pushNamed(routeName, pathParameters: {'id': id});
    }
  }
}
