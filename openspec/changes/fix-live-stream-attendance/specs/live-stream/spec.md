## ADDED Requirements

### Requirement: Live Stream Attempt Tracking and Attendance
The system SHALL pass the lesson ID, thumbnail URL, and completion callback to `CustomVideoPlayer` when rendering active TPStreams live streams, enabling attempt tracking and attendance logging.

#### Scenario: TPStreams live stream renders with attempt tracking parameters
- **WHEN** a user opens an active TPStreams live stream in `LiveStreamViewer`
- **THEN** `LiveStreamViewer` SHALL pass `lessonId: lesson.id` to `CustomVideoPlayer`
- **AND** `CustomVideoPlayer` SHALL initialize `_contentId` and attach `videoAttemptNotifierProvider`
- **AND** playback progress SHALL trigger attempt initialization (`POST /api/v2.3/contents/<id>/attempts/`) to log attendance on the backend
