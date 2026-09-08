## Why

When a scheduled live stream starts, the app currently fails to transition from the scheduled view to the playable stream. This happens because local model merging (`LessonDto.mergeWith`) logic retains `isScheduled = true` from cached database records even when fresh API requests return `isScheduled = false`. Additionally, when users remain on the scheduled screen, the app does not automatically poll the backend to detect when the stream goes live.

## What Changes

- **Update `LessonDto.mergeWith`**: Ensure fresh network responses (`isScheduled == false`) properly overwrite cached scheduled flags (`isScheduled == true`) when detail metadata is refreshed.
- **Implement 5-Second Periodic Polling**: While viewing a scheduled stream (`isScheduled == true`), run a 5-second periodic refresh timer (matching native Android SDK behavior) to fetch updated status from the backend.
- **Automatic UI Transition**: Once the backend API returns HTTP 200 OK (live stream active), the updated state is persisted to the local database and the UI automatically switches from `ScheduledMessageView` to the playable video player / lobby.

## Capabilities

### Modified Capabilities
- `live-stream`: Update scheduled live stream handling to support automatic background refresh and correct database persistence of active stream states.

## Impact

- `packages/core/lib/data/models/lesson_dto.dart` (`LessonDto.mergeWith`)
- `packages/courses/lib/widgets/lesson_detail/live_stream_viewer.dart` (5-second polling timer)
- `packages/courses/lib/providers/lesson_detail_provider.dart`
