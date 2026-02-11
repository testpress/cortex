import '../models/course.dart';

/// Mock course data for demonstration.
///
/// In production, this would come from an API or local database.
const mockCourses = [
  Course(
    id: '1',
    title: 'Flutter Fundamentals',
    description:
        'Master the basics of Flutter development with hands-on projects and real-world examples.',
    progress: 0.65,
  ),
  Course(
    id: '2',
    title: 'Advanced State Management',
    description:
        'Deep dive into state management patterns including Provider, Riverpod, and Bloc.',
    progress: 0.30,
  ),
  Course(
    id: '3',
    title: 'Custom Animations',
    description:
        'Create stunning animations and transitions using Flutter\'s animation framework.',
    progress: 0.0,
  ),
  Course(
    id: '4',
    title: 'Firebase Integration',
    description:
        'Build production-ready apps with Firebase authentication, Firestore, and cloud functions.',
    progress: 0.85,
  ),
  Course(
    id: '5',
    title: 'Testing Strategies',
    description:
        'Write comprehensive unit, widget, and integration tests for bulletproof Flutter apps.',
    progress: 0.15,
  ),
  Course(
    id: '6',
    title: 'Performance Optimization',
    description:
        'Optimize your Flutter apps for smooth 60fps performance on all devices.',
    progress: 0.0,
  ),
];
