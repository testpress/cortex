import 'package:flutter/foundation.dart';
import 'package:data/data.dart';

@immutable
class CourseCertificate {
  const CourseCertificate({
    required this.id,
    required this.course,
    required this.studentName,
    this.completionDate,
    this.certificateId,
    this.progress = 0,
    required this.isLocked,
  });

  final String id;
  final CourseDto course;
  final String studentName;
  final DateTime? completionDate;
  final String? certificateId;
  final int progress;
  final bool isLocked;
}
