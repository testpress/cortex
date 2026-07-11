import 'package:core/data/data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/custom_exam_repository.dart';

part 'custom_exam_courses_provider.g.dart';

@riverpod
class CustomExamCourses extends _$CustomExamCourses {
  @override
  FutureOr<List<CourseDto>> build() async {
    final repository = ref.watch(customExamRepositoryProvider);

    // Fetch courses with allow_custom_test=true
    // We only fetch the first page here for simplicity, assuming the number of
    // custom exam courses is small. (Or we could implement pagination if needed).
    return await repository.getCustomTestCourses(page: 1, pageSize: 50);
  }
}
