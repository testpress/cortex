## ADDED Requirements

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

