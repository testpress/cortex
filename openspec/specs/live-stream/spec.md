# live-stream Specification

## Purpose
Enables automatic background status polling and accurate local cache synchronization for live stream sessions.
## Requirements
### Requirement: Scheduled Live Stream Active State Cache Synchronization
The system SHALL ensure that when fresh lesson detail metadata is fetched from the server with `isScheduled == false`, the local storage cache is updated with `isScheduled = false`, overwriting any previously cached `isScheduled = true` state.

#### Scenario: Live stream becomes active on backend
- **WHEN** a scheduled live stream starts on the backend and fresh lesson details are fetched
- **THEN** `isScheduled` in local storage SHALL be updated to `false`
- **AND** any existing scheduled status message SHALL be cleared

### Requirement: Scheduled Live Stream Periodic Refresh
The system SHALL run a periodic 5-second refresh timer while a live stream is in the scheduled state (`isScheduled == true`) and active in the detail viewer.

#### Scenario: Periodic background status check during scheduled state
- **WHEN** a user views a scheduled live stream
- **THEN** the system SHALL poll the lesson detail endpoint every 5 seconds
- **AND** when the API returns an active status (`isScheduled == false`), the UI SHALL automatically rebuild and render the video player or session lobby
- **AND** the periodic refresh timer SHALL be cancelled

### Requirement: Live Stream Attempt Tracking and Attendance
The system SHALL pass the lesson ID and thumbnail URL to `CustomVideoPlayer` when rendering active TPStreams live streams, enabling attempt tracking and attendance logging while omitting `onComplete` to prevent premature completion on stream stalls.

#### Scenario: TPStreams live stream renders with attempt tracking parameters
- **WHEN** a user opens an active TPStreams live stream in `LiveStreamViewer`
- **THEN** `LiveStreamViewer` SHALL pass `lessonId: lesson.id` and `thumbnailUrl: lesson.image` to `CustomVideoPlayer`
- **AND** `CustomVideoPlayer` SHALL NOT receive `onComplete`
- **AND** `CustomVideoPlayer` SHALL initialize `_contentId` and attach `videoAttemptNotifierProvider`
- **AND** playback progress SHALL trigger attempt initialization (`POST /api/v2.3/contents/<id>/attempts/`) to log attendance on the backend

