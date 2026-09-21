## ADDED Requirements

### Requirement: Parse Progressive Lock State
The system SHALL parse the `locked_contents` array from curriculum API responses and mark corresponding lessons as locked.

#### Scenario: Lesson present in locked_contents
- **WHEN** curriculum JSON payload contains `locked_contents` containing lesson ID
- **THEN** the parsed `LessonDto` has `isLocked` set to `true`

#### Scenario: Lesson with explicit is_locked flag
- **WHEN** curriculum JSON payload contains explicit `is_locked` or `isLocked` set to `true`
- **THEN** the parsed `LessonDto` has `isLocked` set to `true` even if not in `locked_contents`

#### Scenario: Lesson not present in locked_contents and not explicitly locked
- **WHEN** curriculum JSON payload contains active lesson not in `locked_contents` and `is_locked` is not true
- **THEN** the parsed `LessonDto` has `isLocked` set to `false`

#### Scenario: Preserving lock state during partial updates
- **WHEN** `LessonDto.mergeWith` merges a lesson update into an existing lesson
- **THEN** `isLocked` remains `true` if either the existing or updated instance is locked

### Requirement: Block List Navigation for Locked Lessons
The system SHALL display a lock icon for locked lessons in chapter and course content lists, and prevent navigation on tap with an explanatory toast.

#### Scenario: Tapping a locked chapter content item
- **WHEN** user taps a lesson where `isLocked` is `true`
- **THEN** navigation to the lesson detail is prevented
- **AND** an error toast displaying "Complete previous content to unlock" is shown

#### Scenario: Visual badges on locked content items
- **WHEN** a lesson item is locked
- **THEN** trailing icon is `LucideIcons.lock`
- **AND** progress status badges and completion checkmarks are suppressed

### Requirement: Render Locked Notice View in Player and Exam Screens
The system SHALL render an informational notice explaining prerequisites and disable secondary actions while preserving navigation when a locked lesson is viewed in the lesson orchestrator or exam prescreen.

#### Scenario: Viewing a locked lesson in orchestrator
- **WHEN** `LessonDetailOrchestrator` receives a lesson with `isLocked == true`
- **THEN** `ContentNoticeView` is displayed with a lock icon, title "This content is Locked", and subtitle explaining prerequisite completion
- **AND** Bookmark, Mark as completed, Download, and Ask Doubt FAB actions are disabled
- **AND** Previous and Next buttons remain visible and functional in the footer

#### Scenario: Viewing a locked exam in prescreen
- **WHEN** `ExamPrescreen` receives an exam lesson with `isLocked == true`
- **THEN** `ContentNoticeView` is displayed with a lock icon, title "This content is Locked", and subtitle explaining prerequisite completion
