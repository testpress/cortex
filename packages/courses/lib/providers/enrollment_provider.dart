import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:core/data/data.dart';
import 'course_list_provider.dart';

part 'enrollment_provider.g.dart';

/// Provider for the list of courses the user is currently enrolled in.
@riverpod
Stream<List<CourseDto>> enrollment(Ref ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // Surface errors/loading via AsyncValue automatically
  yield* repo.watchCourses();
}
