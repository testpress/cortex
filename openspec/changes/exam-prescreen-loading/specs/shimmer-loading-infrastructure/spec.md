## ADDED Requirements

### Requirement: Exam Pre-screen Full Card Shimmer Loading
The system SHALL display a unified high-fidelity skeleton shimmer (using `Skeletonizer`) for the entire options and details card in the Exam Pre-screen while the detailed exam metadata is loading, and block all interactive tap events on the start button during this period.

#### Scenario: Exam pre-screen metadata loading with full shimmer
- **WHEN** the exam pre-screen is opened and detailed exam metadata is loading (`isMetadataLoading` is true)
- **THEN** the system SHALL render a unified `Skeletonizer` shimmer effect over the title, metadata, and "Start Exam Online" button inside the options card
- **AND** the system SHALL block any tap interactions on the "Start Exam Online" action button/tile
- **AND** once metadata loading completes, the shimmer effect SHALL turn off and the "Start Exam Online" action button SHALL become fully interactive

### Requirement: Lesson List Skeleton Chapter Title Integration
The system SHALL ensure that the lesson list skeleton objects (`_skeletonLessons`) define a non-null, non-empty `chapterTitle` placeholder to render the chapter title subtitle shimmer bone in `LessonListItem`, preventing visual height collapse and mismatch between standard and skeletonized lists.

#### Scenario: Lesson list skeleton rendering with chapter title
- **WHEN** building lesson list skeleton items via `_skeletonLessons`
- **THEN** each `LessonDto` SHALL contain a valid non-empty `chapterTitle` placeholder (e.g. 'Loading chapter title text')
- **AND** the resulting `LessonListItem` skeleton card SHALL render the subtitle shimmer bone matching the active chapter subtitle row

### Requirement: Hide Lesson Duration in Filtered Views
The system SHALL NOT render the lesson duration inside `LessonListItem` in filtered lists. This keeps the design aligned with a clean visual layout and prevents displaying duration beneath the chapter subtitle line.

#### Scenario: Lesson item hides duration in filtered views
- **WHEN** building `LessonListItem` in standard or skeletonized states
- **THEN** the system SHALL NOT render the `duration` caption in the widget tree



