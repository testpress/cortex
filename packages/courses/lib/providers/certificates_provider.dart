import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data/data.dart';

import '../models/certificate.dart';

final paidActiveCertificatesProvider = Provider<List<CourseCertificate>>((ref) {
  return _paidActiveCertificates;
});

final List<CourseCertificate> _paidActiveCertificates = <CourseCertificate>[
  CourseCertificate(
    id: 'cert-phy-2025',
    course: CourseDto(
      id: 'course-physics',
      title: 'JEE Main Physics - Complete Course',
      colorIndex: 3,
      chapterCount: 24,
      totalDuration: '48h',
      progress: 100,
      completedLessons: 84,
      totalLessons: 84,
    ),
    studentName: 'Rahul Sharma',
    completionDate: DateTime(2025, 12, 15),
    certificateId: 'CERT-2025-PHY-1234',
    progress: 100,
    isLocked: false,
    signerOneName: 'Dr. Rajesh Kumar',
    signerOneRole: 'Academic Director',
    signerTwoName: 'Prof. Priya Sharma',
    signerTwoRole: 'Course Instructor',
    instituteName: 'Excellence Academy',
    instituteTagline: 'Empowering students to achieve their dreams',
  ),
  CourseCertificate(
    id: 'cert-chem-2025',
    course: CourseDto(
      id: 'course-chemistry',
      title: 'Organic Chemistry Fundamentals',
      colorIndex: 1,
      chapterCount: 18,
      totalDuration: '32h',
      progress: 45,
      completedLessons: 27,
      totalLessons: 60,
    ),
    studentName: 'Rahul Sharma',
    progress: 45,
    isLocked: true,
  ),
  CourseCertificate(
    id: 'cert-math-2025',
    course: CourseDto(
      id: 'course-math',
      title: 'Advanced Calculus for JEE',
      colorIndex: 2,
      chapterCount: 21,
      totalDuration: '36h',
      progress: 28,
      completedLessons: 14,
      totalLessons: 50,
    ),
    studentName: 'Rahul Sharma',
    progress: 28,
    isLocked: true,
  ),
  CourseCertificate(
    id: 'cert-bio-2025',
    course: CourseDto(
      id: 'course-biology',
      title: 'NEET Biology - Cell Biology & Genetics',
      colorIndex: 3,
      chapterCount: 16,
      totalDuration: '30h',
      progress: 12,
      completedLessons: 8,
      totalLessons: 66,
    ),
    studentName: 'Rahul Sharma',
    progress: 12,
    isLocked: true,
  ),
];
