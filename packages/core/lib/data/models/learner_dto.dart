import 'package:flutter/foundation.dart';

@immutable
class LearnerDto {
  final String id;
  final int rank;
  final String name;
  final String avatar;
  final double points;
  final int coursesCompleted;
  final int streakDays;

  const LearnerDto({
    required this.id,
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.coursesCompleted,
    required this.streakDays,
  });

  factory LearnerDto.fromJson(Map<String, dynamic> json, int rank) {
    return LearnerDto(
      id: json['id']?.toString() ?? '',
      rank: rank,
      name: json['user']?['display_name'] ?? '',
      avatar: json['user']?['medium_image'] ?? '',
      points: double.tryParse(json['trophies_count']?.toString() ?? '0') ?? 0.0,
      coursesCompleted: json['courses_completed']?.toInt() ?? 0,
      streakDays: json['streak_days']?.toInt() ?? 0,
    );
  }
}
