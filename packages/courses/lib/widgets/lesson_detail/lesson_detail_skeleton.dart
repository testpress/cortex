import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:core/data/data.dart';

/// Skeleton layout for the lesson detail screen while content is loading.
/// This widget adapts its mock layout (bones) based on the [LessonType],
/// ensuring a non-scrollable, static placeholder.
class LessonDetailSkeleton extends StatelessWidget {
  const LessonDetailSkeleton({super.key, this.lessonType});

  final LessonType? lessonType;

  @override
  Widget build(BuildContext context) {
    if (lessonType == LessonType.video || lessonType == LessonType.liveStream) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: Bone(),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Bone.text(words: 5, fontSize: 24),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Bone.multiText(lines: 4),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Bone.circle(size: 40),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Bone.text(words: 2, fontSize: 16),
                    SizedBox(height: 4),
                    Bone.text(words: 1, fontSize: 12),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      );
    }

    if (lessonType == LessonType.pdf || lessonType == LessonType.attachment) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Bone.icon(),
                Bone.text(words: 3),
                Bone.icon(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const Bone(),
              ),
            ),
          ),
        ],
      );
    }

    // Generic fallback for notes, embeds, etc.
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Bone.text(words: 4, fontSize: 28),
          SizedBox(height: 24),
          Bone.multiText(lines: 12),
          SizedBox(height: 24),
          Bone.multiText(lines: 8),
        ],
      ),
    );
  }
}
