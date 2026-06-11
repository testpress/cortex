# lesson-detail-loading-experience Specification

## Purpose
TBD - created by archiving change skeletonize-lesson-detail. Update Purpose after archive.
## Requirements
### Requirement: Skeletonized Loading State
The system SHALL display a skeleton loader instead of a generic loading indicator while lesson detail content is being prepared or fetched.

#### Scenario: Displaying skeleton loader
- **WHEN** the lesson detail orchestrator does not have complete lesson data to render the viewer
- **THEN** it SHALL display a `LessonDetailSkeleton` wrapped in a `Skeletonizer` to provide a visually structured loading experience.

### Requirement: Type-Aware Mock Bones
The system SHALL provide mock skeleton structures (bones) that approximate the visual layout of specific lesson types when they cannot be natively inferred by textual contents.

#### Scenario: Mocking PDF Viewer
- **WHEN** the lesson type is PDF and the skeleton loader is active
- **THEN** it SHALL render a full-screen rectangular mock container to represent the PDF surface.

#### Scenario: Mocking Video Player
- **WHEN** the lesson type is Video or Live Stream and the skeleton loader is active
- **THEN** it SHALL render a 16:9 rectangular mock container to represent the video player surface.

#### Scenario: Unknown Type Mocking
- **WHEN** the lesson type is unknown or not yet available
- **THEN** it SHALL render a generic content block structure as the skeleton bone.

