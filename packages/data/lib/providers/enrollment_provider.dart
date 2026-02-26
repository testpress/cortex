import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course_dto.dart';
import 'repository_providers.dart';

part 'enrollment_provider.g.dart';

/// Provider for the list of courses the user is currently enrolled in.
@riverpod
Stream<List<CourseDto>> enrollment(Ref ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);

  // Surface errors/loading via AsyncValue automatically
  yield* repo.watchCourses();
}
