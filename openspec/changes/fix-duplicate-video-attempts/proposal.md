## Why

When students watch video lessons in the Cortex app, watch progress updates previously called `POST /api/v2.5/chapter_content_attempts/videos/update/` with only `chapter_content_id` and watched ranges, without an attempt ID. Whenever a course has a completion threshold configured (such as 1%), the backend evaluates this endpoint and automatically generates a new attempt as soon as the watch threshold is met, resulting in duplicate and unwanted attempts for active students.

## What Changes

- Retrieve or initialize the active video attempt session using `GET /api/v2.3/contents/{id}/attempts/` (with fallback to `POST` if none exists).
- Support extracting the attempt ID from `attempt['video']['id']` with fallback to `attempt['object_id']` (aligned with Native Android SDK).
- Send video progress updates using `PUT /api/v2.4/user_videos/{video_attempt_id}/` for active video sessions, matching the Native Android flow.
- Retain `POST /api/v2.5/chapter_content_attempts/videos/update/` as a graceful fallback when an attempt ID cannot be resolved (or for offline synchronization).
- Cache resolved video attempt IDs in `CourseRepository`.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `resume-playback`: Video progress synchronization targets the specific active attempt session (`user_videos/{video_attempt_id}/`) instead of triggering duplicate attempt creation on the chapter content.

## Impact

- `packages/core/lib/network/api_endpoints.dart`: Added `userVideo(int id)` endpoint.
- `packages/core/lib/data/sources/`: Added `getVideoAttemptId` and `updateUserVideo` on `DataSource`, implemented in `HttpDataSource` and `MockDataSource`.
- `packages/courses/lib/repositories/course_repository.dart`: Cached attempt IDs and routed progress syncs to `updateUserVideo` when an attempt ID is available.
- `packages/courses/lib/providers/video_attempt_provider.dart`: Synchronized video progress through `CourseRepository`.
