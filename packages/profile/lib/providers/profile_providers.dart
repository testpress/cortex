import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import '../data/profile_mock_data.dart';

part 'profile_providers.g.dart';

@riverpod
Future<StudyMomentumDto> profileStats(Ref ref) async {
  // Simulate API delay
  await Future.delayed(const Duration(milliseconds: 800));
  // In a real app, this would fetch from a repository
  return mockStudyMomentum; 
}

@riverpod
Future<List<RecentActivityDto>> profileRecentActivity(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockRecentActivity;
}

final profileDesignModeProvider = StateProvider<DesignMode>(
  (ref) => DesignMode.system,
);
