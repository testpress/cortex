import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course_dto.dart';
import 'repository_providers.dart';

part 'course_list_provider.g.dart';

/// Stream provider for the full course list.
/// On first watch: triggers a refresh from DataSource → Drift.
/// Thereafter: streams live updates from the Drift DB.
@riverpod
Stream<List<CourseDto>> courseList(CourseListRef ref) async* {
  final repo = await ref.watch(courseRepositoryProvider.future);
  yield* repo.watchCourses();
}
