import 'package:core/data/data.dart';
import '../models/test_dto.dart';
import '../data/mock_tests.dart';

/// ExamRepository stub — to be fully implemented in the `lms-assessment-detail` change.
/// Returns empty data for all methods to allow other repositories and screens to compile.
class ExamRepository {
  const ExamRepository();

  /// Placeholder: returns empty exam list.
  Stream<List<CourseDto>> watchExams() => const Stream.empty();

  /// Placeholder: no-op refresh.
  Future<void> refreshExams() async {}

  Future<List<TestDto>> getUpcomingTests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockTests;
  }
}
