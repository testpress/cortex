import 'package:core/data/data.dart';

/// Mock course data for demonstration.
///
/// In production, this would come from an API or local database.
const mockCourses = [
  CourseDto(
    id: '1',
    title: 'Flutter Fundamentals',
    colorIndex: 0,
    chapterCount: 5,
    totalContents: 20,
    completedLessons: 13,
    totalLessons: 20,
    progress: 65.0,
  ),
  CourseDto(
    id: '2',
    title: 'Advanced State Management',
    colorIndex: 1,
    chapterCount: 4,
    totalContents: 15,
    completedLessons: 5,
    totalLessons: 15,
    progress: 30.0,
  ),
  CourseDto(
    id: '3',
    title: 'Custom Animations',
    colorIndex: 2,
    chapterCount: 3,
    totalContents: 10,
    completedLessons: 0,
    totalLessons: 10,
    progress: 0.0,
  ),
  CourseDto(
    id: '4',
    title: 'Firebase Integration',
    colorIndex: 3,
    chapterCount: 6,
    totalContents: 25,
    completedLessons: 21,
    totalLessons: 25,
    progress: 85.0,
  ),
  CourseDto(
    id: '5',
    title: 'Testing Strategies',
    colorIndex: 4,
    chapterCount: 3,
    totalContents: 12,
    completedLessons: 2,
    totalLessons: 12,
    progress: 15.0,
  ),
  CourseDto(
    id: '6',
    title: 'Performance Optimization',
    colorIndex: 5,
    chapterCount: 2,
    totalContents: 8,
    completedLessons: 0,
    totalLessons: 8,
    progress: 0.0,
  ),
];
