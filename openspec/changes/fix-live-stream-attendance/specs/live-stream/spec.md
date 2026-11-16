## ADDED Requirements

### Requirement: Live Stream Attempt Tracking and Attendance
The system SHALL pass the lesson ID and thumbnail URL to `CustomVideoPlayer` when rendering active TPStreams live streams, enabling attempt tracking and attendance logging while omitting `onComplete` to prevent premature completion on stream stalls.

#### Scenario: TPStreams live stream renders with attempt tracking parameters
- **WHEN** a user opens an active TPStreams live stream in `LiveStreamViewer`
- **THEN** `LiveStreamViewer` SHALL pass `lessonId: lesson.id` and `thumbnailUrl: lesson.image` to `CustomVideoPlayer`
- **AND** `CustomVideoPlayer` SHALL NOT receive `onComplete`
- **AND** `CustomVideoPlayer` SHALL initialize `_contentId` and attach `videoAttemptNotifierProvider`
- **AND** playback progress SHALL trigger attempt initialization (`POST /api/v2.3/contents/<id>/attempts/`) to log attendance on the backend
