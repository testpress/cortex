## Why

Users currently lose their progress when they close a lesson video. This change will allow them to resume playback from where they left off by tracking their last watched duration. Additionally, it tracks the actual time ranges the user watched to provide accurate progress tracking.

## What Changes

- Fetch the `attempts_url` (only for Video lessons) on load to determine the user's `last_position` and initialize the player at that position.
- Add a new field `last_watched_duration` to the Lesson DTO to keep this value in memory.
- Implement logic to listen to `TPStreamsPlayerController` events to track continuous `watched_time_ranges`.
- Add a periodic sync (every 5 minutes) and event-based sync (pause, seek, play, or back navigation) to POST the `last_watch_position` and `watched_time_ranges` to the `/api/v2.5/chapter_content_attempts/videos/update/` API.

## Capabilities

### New Capabilities
- `resume-playback`: Track and resume video playback from the user's last watched duration, including watched time intervals tracking and syncing.

### Modified Capabilities


## Impact

- `Lesson DTO`: Schema change to include `last_watched_duration`.
- Video player component: Needs to read the initial duration and implement a range tracking algorithm using player listeners.
- API/Backend: Will interact with the `attempts_url` GET API for initialization and the `/api/v2.5/chapter_content_attempts/videos/update/` POST API for saving progress.
