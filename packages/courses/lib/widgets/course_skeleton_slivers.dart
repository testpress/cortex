import 'package:flutter/widgets.dart';
import 'package:core/core.dart';

import 'course_skeleton_card.dart';

/// Sliver list of Study course skeleton cards for the initial loading state.
class CourseSkeletonList extends StatelessWidget {
  const CourseSkeletonList({
    super.key,
    this.itemCount = 6,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: design.spacing.md),
            child: const CourseSkeletonCard(),
          ),
          childCount: itemCount,
        ),
      ),
    );
  }
}

/// Trailing Study course skeleton card used while paginating more courses.
class CourseLoadMoreSkeleton extends StatelessWidget {
  const CourseLoadMoreSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final design = Design.of(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: design.spacing.md),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(bottom: design.spacing.md),
          child: const CourseSkeletonCard(),
        ),
      ),
    );
  }
}
