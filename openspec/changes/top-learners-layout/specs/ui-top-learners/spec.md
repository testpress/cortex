## ADDED Requirements

### Requirement: Top Learners Card Layout
The dashboard SHALL display learner cards with the points and trophies directly underneath the learner's name, minimizing horizontal width.

#### Scenario: View learner card on dashboard
- **WHEN** the dashboard renders the `TopLearnersSection` carousel
- **THEN** each learner card displays the points (trophies and count) below the learner's name instead of the top-right corner
- **THEN** the card width is constrained to prevent unnecessary whitespace
