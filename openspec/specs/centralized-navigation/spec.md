# centralized-navigation Specification

## Purpose
TBD - created by archiving change integrate-whats-new-section. Update Purpose after archive.
## Requirements
### Requirement: Centralized Lesson Navigation
The system SHALL provide a unified mechanism for navigating to lesson details that maps content types to registered named routes.

#### Scenario: Assessment route resolution
- **WHEN** a component navigates to an assessment lesson via `LessonRouter`
- **THEN** the router MUST resolve `AppRouteNames.assessmentDetail` to `/study/assessment/:id`
- **AND** the route parameters (such as `id`) MUST be injected into the path parameters

#### Scenario: Elimination of manual route branching
- **WHEN** navigating to study lessons
- **THEN** navigation MUST execute through `LessonRouter.navigateToLesson` rather than local route switches

