import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/data.dart';

part 'study_momentum_provider.g.dart';

@riverpod
Future<StudyMomentumDto> studyMomentum(StudyMomentumRef ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  return mockStudyMomentum;
}
