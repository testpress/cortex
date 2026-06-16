## 1. Data Model Updates

- [x] 1.1 Update `LessonDto._parseBase` in `packages/core/lib/data/models/lesson_dto.dart` to map `cover_image` to the `image` field, without falling back to `icon`. Store `null` if it is missing.

## 2. UI Updates

- [x] 2.1 Update `LessonListItem` in `packages/courses/lib/widgets/lesson_list_item.dart` to use a 16:9 container for the image (e.g., width 72, height 40) instead of a 1x1 square.
- [x] 2.2 Update the image rendering logic in `LessonListItem` to display the `cover_image` using `BoxFit.cover`, or fallback to displaying a local vector icon centered in the 16:9 box if the image is `null`.
