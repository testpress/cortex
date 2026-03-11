import 'package:flutter/foundation.dart';
import 'assignment_dto.dart';

enum DashboardTestType { mock, chapter, practice }

enum ClassStatus { upcoming, live, completed }

@immutable
class ClassItem {
  final String id;
  final String subject;
  final String time;
  final String faculty;
  final ClassStatus status;
  final String? topic;

  const ClassItem({
    required this.id,
    required this.subject,
    required this.time,
    required this.faculty,
    required this.status,
    this.topic,
  });
}

@immutable
class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueTime;
  final AssignmentStatus status;
  final double? progress; // 0.0 to 1.0
  final String? description;

  const Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueTime,
    required this.status,
    this.progress,
    this.description,
  });
}

@immutable
class ScheduledTest {
  final String id;
  final String title;
  final String time;
  final String duration;
  final DashboardTestType? type;
  final bool isImportant;

  const ScheduledTest({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    this.type,
    this.isImportant = false,
  });
}
