import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/exam_repository.dart';

part 'exam_providers.g.dart';

/// Provides the [ExamRepository].
@Riverpod(keepAlive: true)
ExamRepository examRepository(Ref ref) {
  return const ExamRepository();
}
