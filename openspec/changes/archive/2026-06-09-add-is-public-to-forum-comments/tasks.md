## 1. Database and Data Layer

- [x] 1.1 Add `BoolColumn get isPublic` (defaulting to true) to `ForumCommentsTable` in `packages/core/lib/data/db/tables/forum_threads_table.dart`.
- [x] 1.2 Run `build_runner` for the `core` package to generate updated Drift classes.
- [x] 1.3 Add `isPublic` property to `ForumCommentDto` and update its `.fromJson` to parse `"is_public"` with a fallback to `true`.

## 2. Repository Layer

- [x] 2.1 Update `_commentRowToDto` in `packages/discussions/lib/repositories/forum_repository.dart` to map the `isPublic` property.
- [x] 2.2 Update `_commentDtoToCompanion` in `packages/discussions/lib/repositories/forum_repository.dart` to map the `isPublic` property.
- [x] 2.3 Check `doubt_repository.dart` and update if it shares the same `is_public` comment data flow.

## 3. UI Layer

- [x] 3.1 Update `packages/discussions/lib/screens/forum_post_detail_screen.dart` to conditionally display a "Pending Moderation" badge next to the comment timestamp if `isPublic` is false.
