import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/models/live_class_dto.dart';
import 'package:data/models/assignment_dto.dart';
import 'package:data/models/test_dto.dart';
import 'package:data/models/study_momentum_dto.dart';
import '../data/mock_data.dart';

part 'dashboard_providers.g.dart';

@riverpod
Future<List<LiveClassDto>> todayClasses(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 500));
  return mockTodayClasses;
}

@riverpod
Future<List<AssignmentDto>> pendingAssignments(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 600));
  return mockAssignments
      .where((a) => a.status != AssignmentStatus.submitted)
      .toList();
}

@riverpod
Future<List<TestDto>> upcomingTests(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 700));
  return mockTests;
}

@riverpod
Future<StudyMomentumDto> studyMomentum(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  return mockStudyMomentum;
}
