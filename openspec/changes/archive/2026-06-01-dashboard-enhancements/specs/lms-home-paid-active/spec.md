## ADDED Requirements

### Requirement: Hero Banner Interaction
The system SHALL pause the hero banner auto-play timer while the user is actively interacting with the carousel.

#### Scenario: User touches the hero banner
- **WHEN** the user presses down on the hero banner
- **THEN** the auto-play timer MUST pause
- **AND** it MUST resume only when the user releases or cancels the touch

### Requirement: Smooth Horizontal Scrolling
The system SHALL provide smooth, continuous scrolling for horizontal carousels (e.g., `AppCarousel`) without forcing step-by-step page snapping.

#### Scenario: User scrolls horizontal list
- **WHEN** the user swipes horizontally on a lesson cards section or any `AppCarousel`
- **THEN** the list MUST scroll smoothly and continuously
- **AND** it MUST NOT snap forcefully to page boundaries
