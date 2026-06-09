## Why

The backend API for forum comments now includes an `is_public` boolean field. We need to ingest this field and use it to visually indicate when a comment is pending moderation (i.e., when `is_public` is false).

## What Changes

- Update `ForumCommentDto` to include the `isPublic` boolean property mapped from `is_public`.
- Update `ForumCommentsTable` in the local Drift database to store an `isPublic` boolean column.
- Update mapping methods in the forum (and potentially doubt) repositories to handle the new `isPublic` property.
- Update the UI where comments are rendered to display a "Pending Moderation" label next to the timestamp if `isPublic` is false.

## Capabilities

### New Capabilities

### Modified Capabilities
- `forum-thread-detail`: Add requirement to display a "Pending Moderation" badge next to comment timestamps for non-public comments.

## Impact

- **Models**: `packages/core/lib/data/models/forum_thread_dto.dart` (adds `isPublic`).
- **Database**: `packages/core/lib/data/db/tables/forum_threads_table.dart` (schema change, requires drift build).
- **Mappers**: `packages/discussions/lib/repositories/forum_repository.dart`
- **UI**: `packages/discussions/lib/screens/forum_post_detail_screen.dart` (adds badge).
