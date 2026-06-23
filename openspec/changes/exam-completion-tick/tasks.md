## 1. Widget Implementation

- [x] 1.1 Open `packages/courses/lib/widgets/chapter_content_item.dart`
- [x] 1.2 Wrap the left thumbnail widget in a `Stack`
- [x] 1.3 Add a `ClipRRect` to the thumbnail container to clip its left corners to `design.radius.md`, and remove `clipBehavior: Clip.hardEdge` from the outer card `Container`
- [x] 1.4 Add the green badge widget as a `Positioned` child of the `Stack` at `top: -6` and `right: -6`: a `Container` of size 20×20 with `BoxShape.circle`, `color: design.colors.accent4`, a border of width 1.5 and color `design.colors.card`, and child `Icon(LucideIcons.check, size: 11, color: Colors.white)`
- [x] 1.5 Show the badge conditionally only when `lesson.hasAttempts == true && (lesson.type == LessonType.test || lesson.type == LessonType.assessment)`
- [x] 1.6 Restore the trailing `Padding` widget to its original form containing only the chevron icon
- [x] 1.7 Fix `hasAttempts` detection across the app by checking `attempts_count > 0` in `LessonDto.fromJson`, parsing the `content_attempts` key in `HttpDataSource.getContentAttempts`, and filtering `historyIds` by `hasAttempts` in `CourseRepository._applyContentStatuses`

## 2. Visual Verification

- [x] 2.1 Run the app on a real device or emulator against a course that has at least one completed exam (`hasAttempts == true`)
- [x] 2.2 Confirm the green tick badge appears on the completed exam card and NOT on video/PDF cards
- [x] 2.3 Confirm the badge does NOT appear on exam cards with no attempts (`hasAttempts == false`)
- [x] 2.4 Verify the badge renders correctly in both light and dark themes using `design.colors.accent4`
- [x] 2.5 Confirm the chevron arrow remains visible and the layout doesn't clip on small screen widths
