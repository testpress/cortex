import '../models/course_dto.dart';

/// ExamRepository stub — to be fully implemented in the `lms-assessment-detail` change.
/// Returns empty data for all methods to allow other repositories and screens to compile.
class ExamRepository {
  const ExamRepository();

  /// Placeholder: returns empty exam list.
  Stream<List<CourseDto>> watchExams() => const Stream.empty();

  /// Placeholder: no-op refresh.
  Future<void> refreshExams() async {}
}
