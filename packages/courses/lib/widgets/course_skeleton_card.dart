import 'package:core/data/data.dart';
import 'package:flutter/widgets.dart';

import 'course_card.dart';

/// Skeleton card used while Study tab courses are loading.
class CourseSkeletonCard extends StatelessWidget {
  const CourseSkeletonCard({super.key});

  static const CourseDto _loadingCourse = CourseDto(
    id: 'loading-course',
    title: 'Loading course title for Study',
    colorIndex: 0,
    chapterCount: 93,
    totalContents: 410,
    progress: 0,
    completedLessons: 0,
    totalLessons: 410,
    image: '',
    examsCount: 0,
    order: 0,
  );

  @override
  Widget build(BuildContext context) {
    return CourseCard(
      course: _loadingCourse,
      loading: true,
    );
  }
}
