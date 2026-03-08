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
    this.signerOneName,
    this.signerOneRole,
    this.signerTwoName,
    this.signerTwoRole,
    this.instituteName,
    this.instituteTagline,
  });

  final String id;
  final CourseDto course;
  final String studentName;
  final DateTime? completionDate;
  final String? certificateId;
  final int progress;
  final bool isLocked;
  final String? signerOneName;
  final String? signerOneRole;
  final String? signerTwoName;
  final String? signerTwoRole;
  final String? instituteName;
  final String? instituteTagline;
}
