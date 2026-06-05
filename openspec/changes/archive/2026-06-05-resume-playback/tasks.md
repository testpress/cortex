## 1. Domain Model Changes

- [x] 1.1 Update `LessonDto` in `package:core` to include `last_watched_duration`
- [x] 1.2 Update `Lesson` domain model and its `toDto` method in `package:courses` to map the new field

## 2. API Integration

- [x] 2.1 Update the API client/repository to fetch `attempts_url` when a Video lesson is loaded and extract `last_position`
- [x] 2.2 Create the POST API service for `/api/v2.5/chapter_content_attempts/videos/update/` to sync `last_watch_position` and `watched_time_ranges`

## 3. State Management

- [x] 3.1 Create a Riverpod provider to track the user's current session delta ranges and `last_position`
- [x] 3.2 Implement debounce logic (2-3s) for event-driven syncs and a periodic 5-minute timer to trigger the POST API sync

## 4. Video Player Integration

- [x] 4.1 Update the Video Player widget to initialize and seek to `last_position` (if non-zero) on load
- [x] 4.2 Attach listeners to `TPStreamsPlayerController` (`isPlaying`, `position` events) to track continuous chunks of playback
- [x] 4.3 Trigger the state management sync logic on pause, seek, and back navigation events
