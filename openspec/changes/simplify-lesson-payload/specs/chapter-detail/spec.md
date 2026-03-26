## MODIFIED Requirements

### Requirement: Navigation To Content
The system SHALL navigate to the appropriate full-screen viewer or reader when a content item is tapped. For PDF lessons, the system SHALL navigate to a dedicated PDF viewer that renders the file from a remote URL.

#### Scenario: Tapping a video lesson
- **WHEN** the user taps a "Video" lesson item
- **THEN** the system pushes the Video Lesson Detail screen onto the navigation stack

#### Scenario: Tapping a PDF lesson
- **WHEN** the user taps a "PDF" lesson item
- **THEN** the system pushes the PDF Lesson Detail screen (PDF Viewer) with the provided `contentUrl`

## REMOVED Requirements

### Requirement: Multi-part text rendering for lessons
**Reason**: Replaced by dedicated viewers for common media types (PDF/Video).
**Migration**: Use the individual playback widgets (`LessonPdfViewer`, `LessonVideoPlayer`) instead of the multi-atom rendering loop in `LessonDetailScreen`.
