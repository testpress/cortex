## ADDED Requirements

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
