import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:data/data.dart';
import '../data/profile_mock_data.dart';

part 'profile_providers.g.dart';

@riverpod
Future<List<RecentActivityDto>> profileRecentActivity(Ref ref) async {
  await Future.delayed(const Duration(milliseconds: 400));
  return mockRecentActivity;
}

final isLogoutSheetOpenProvider = StateProvider<bool>((ref) => false);
