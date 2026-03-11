import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/data/data.dart';
import '../models/study_momentum_dto.dart';
import '../data/mock_data.dart';

part 'study_momentum_provider.g.dart';

@riverpod
Future<StudyMomentumDto> studyMomentum(StudyMomentumRef ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  return mockStudyMomentum;
}
