import 'dart:async';
import 'package:core/data/data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_exam_repository.g.dart';

abstract class CustomExamRepository {
  Future<List<CourseDto>> getCustomTestCourses({
    required int page,
    required int pageSize,
  });
  Future<CustomTestConfigDto> getCustomTestConfig(String courseId);
  Future<AttemptDto> generateCustomExam(CustomExamGenerationRequestDto request);
}

class OnlineCustomExamRepository implements CustomExamRepository {
  final DataSource _dataSource;

  OnlineCustomExamRepository({required DataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<CourseDto>> getCustomTestCourses({
    required int page,
    required int pageSize,
  }) async {
    final response = await _dataSource.getCourses(
      page: page,
      pageSize: pageSize,
      allowCustomTest: true,
    );
    return response.results;
  }

  @override
  Future<CustomTestConfigDto> getCustomTestConfig(String courseId) async {
    return await _dataSource.getCustomTestConfig(courseId);
  }

  @override
  Future<AttemptDto> generateCustomExam(
    CustomExamGenerationRequestDto request,
  ) async {
    return await _dataSource.generateCustomExam(request);
  }
}

@Riverpod(keepAlive: true)
CustomExamRepository customExamRepository(Ref ref) {
  final dataSource = ref.watch(dataSourceProvider);
  return OnlineCustomExamRepository(dataSource: dataSource);
}
