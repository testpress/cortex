# shimmer-loading-infrastructure Specification

## Purpose
Support structural loading states with `Skeletonizer` for dashboard surfaces and the Study tab course list.
## Requirements
### Requirement: Global Skeletonizer Support
The system SHALL support wrapping dashboard components in a `Skeletonizer` widget to provide structural loading states.

#### Scenario: Dashboard loading with skeletons
- **WHEN** the user opens the app and dashboard data is being fetched
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the final widgets

### Requirement: Pure Providers with UI-Local Skeleton Placeholders
Providers for dashboard feeds SHALL remain pure and return only real stream data, loading, or error states. Skeleton placeholder objects, if needed, SHALL be created only in the UI layer.

#### Scenario: First install with empty cache
- **WHEN** the app is launched for the first time and `dashboardRepository.watchHeroBanners()` is called
- **THEN** the provider emits database-backed stream values (including empty lists while loading)
- **AND** the UI decides whether to show skeleton structures

### Requirement: Zero-Height Prevention
Dashboard widgets (like `HeroBannerCarousel`) SHALL NOT return `SizedBox.shrink()` when empty if they are being skeletonized.

#### Scenario: Maintaining carousel height during load
- **WHEN** `HeroBannerCarousel` receives an empty list but skeletonization is enabled
- **THEN** it maintains its standard aspect ratio and displays shimmer blocks instead of disappearing

### Requirement: Backend Empty Emission Handling
The system SHALL treat backend empty emissions as valid final data and exit skeleton state once bootstrap loading completes.

#### Scenario: Empty list returned after bootstrap refresh
- **WHEN** dashboard refresh completes and a section feed resolves to an empty list from backend
- **THEN** the section renders its empty-state layout
- **AND** the section does not remain in skeleton mode

### Requirement: Study Course List Skeleton Support
The system SHALL support the Study tab course list structural loading state by skeletonizing the real course card layout.

#### Scenario: Real layout skeletonization
- **WHEN** the Study tab course list is in its loading state
- **THEN** the system SHALL wrap the real course card list in `Skeletonizer`
- **AND** the screen shell SHALL remain responsible only for choosing when to show the loading state
- **AND** targeted annotations MAY be used where a specific shape must be preserved

#### Scenario: Study course list loading
- **WHEN** the Study tab course list is fetching its initial data
- **THEN** the system displays shimmer skeleton placeholders that match the layout of the course cards
- **AND** the section header remains outside the skeleton boundary
- **AND** the skeleton state remains visible during the initial sync even if cached courses are already available

#### Scenario: Pagination skeleton alignment
- **WHEN** the Study tab course list is fetching the next page of courses
- **THEN** the trailing skeleton card SHALL use the same horizontal inset and card proportions as the loaded course cards
- **AND** it SHALL not span the full width of the scroll area

### Requirement: Chapter List Skeleton Support
The system SHALL display high-fidelity shimmer skeleton items in the Chapter List during initial loading or background syncing when no cached chapters are present.

#### Scenario: Chapter list initial loading
- **WHEN** the Chapter List screen (`ChaptersListPage`) is loading its initial content or syncing in the background with empty cache
- **THEN** the system SHALL display structured shimmer skeleton placeholders using `Skeletonizer`
- **AND** the shimmer effect SHALL use the design system's customized tokens (`design.colors.skeleton` and `design.colors.onSkeleton`)
- **AND** the skeleton cards SHALL match the layout, insets, and spacing of `ChapterCurriculumItem`

### Requirement: Lesson List Skeleton Support
The system SHALL display high-fidelity shimmer skeleton items in the filtered Lesson List and Chapter Detail screens during initial loading or syncing.

#### Scenario: Lesson list initial loading
- **WHEN** the Lesson List view within `ChaptersListPage` is loading and has no cached lessons
- **THEN** the system SHALL display structured shimmer skeleton placeholders using `Skeletonizer`
- **AND** the skeleton items SHALL match the layout, badges, and typography of `LessonListItem`

#### Scenario: Chapter detail initial loading
- **WHEN** the Chapter Detail screen (`ChapterDetailPage`) is loading its content for the first time and has no cached items
- **THEN** the system SHALL display structured shimmer skeleton placeholders using `Skeletonizer`
- **AND** the skeleton items SHALL match the layout and typography of `ChapterContentItem`

### Requirement: Conditional Chapter Metadata Formatting
The system SHALL conditionally format the chapter metadata so that if the assessment count is 0, only the lesson count is shown. If there is one or more assessments, both the lesson count and assessment count SHALL be displayed, separated by a middle dot.

#### Scenario: Chapter metadata with 0 assessments
- **WHEN** rendering a chapter card or chapter detail header
- **AND** the chapter's assessment count is 0
- **THEN** the metadata string SHALL only show the lesson count (e.g., "5 Lessons")

#### Scenario: Chapter metadata with 1 or more assessments
- **WHEN** rendering a chapter card or chapter detail header
- **AND** the chapter's assessment count is greater than 0
- **THEN** the metadata string SHALL show both the lesson count and assessment count, separated by a middle dot (e.g., "5 Lessons · 2 Assessments")

### Requirement: High-Fidelity Icon Shimmer Sizes
The system SHALL ensure that the chapter and lesson icons/images shimmer with a full-size (40x40) bone placeholder in skeleton states, preventing them from appearing too small.

#### Scenario: Chapter or lesson card skeleton icon rendering
- **WHEN** a chapter card, lesson item card, or chapter content item is skeletonized
- **THEN** the icon/image placeholder SHALL render as a full 40x40 skeleton shape matching the actual icon container's boundary (e.g., using `Skeleton.replace` with a 40x40 replacement shape).

### Requirement: Centralized Design Sizing Constants
The system SHALL centralize the layout sizing constants (e.g., the 40.0 width/height for curriculum and lesson icons) within each widget's scope to avoid duplication and hardcoding in both standard and skeletonized states.

#### Scenario: Declaring icon size local constant
- **WHEN** building `ChapterCurriculumItem`, `LessonListItem`, or `ChapterContentItem`
- **THEN** the system SHALL declare a local `const double iconSize = 40;` inside the `build` method
- **AND** both the skeleton replacement and the original child widget SHALL utilize the `iconSize` constant

### Requirement: Exam Course List Skeleton Support
The system SHALL support the Exams screen course list structural loading state by skeletonizing the real course card layout to match the Study tab course list experience.

#### Scenario: Real layout skeletonization in Exams Screen
- **WHEN** the Exams screen course list is in its loading state or performing initial database sync
- **THEN** the system SHALL display structured shimmer skeleton placeholders using `Skeletonizer`
- **AND** the shimmer effect SHALL use the design system's customized tokens (`design.colors.skeleton` and `design.colors.onSkeleton`)
- **AND** the skeleton cards SHALL match the layout, insets, and spacing of `CourseCard`
- **AND** the skeleton state remains visible during the initial sync even if cached courses are already available

#### Scenario: Exams pagination skeleton alignment
- **WHEN** the Exams screen course list is fetching the next page of courses
- **THEN** the trailing skeleton card SHALL use the same horizontal inset and card proportions as the loaded course cards
- **AND** it SHALL not span the full width of the scroll area

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




