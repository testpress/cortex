## ADDED Requirements

### Requirement: Centralized Lesson Navigation
The system SHALL provide a unified mechanism for navigating to lesson details that decouples UI components from specific URL path structures.

#### Scenario: Named Route Mapping
- **WHEN** any component needs to navigate to a lesson (Video, PDF, Test, Assessment, etc.)
- **THEN** it MUST use a centralized `LessonRouter` that maps the content type to a Named Route.
- **AND** the route names MUST be defined as constants in the `core` package.

#### Scenario: Route Parameter Injection
- **WHEN** navigating to a lesson detail screen
- **THEN** the router MUST automatically inject the required parameters (like `id`) into the path parameters of the route.

#### Scenario: Elimination of Duplicate Logic
- **WHEN** the centralized navigation system is implemented
- **THEN** all manual `switch` blocks for lesson routing in `ChaptersListPage`, `LessonCardsSectionWidget`, and `AppRouter` MUST be removed in favor of the centralized call.
