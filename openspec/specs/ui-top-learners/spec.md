# ui-top-learners Specification

## Purpose
TBD - created by archiving change add-top-learners-screen. Update Purpose after archive.
## Requirements
### Requirement: Top Learners Screen
The system SHALL provide a full-page screen displaying the complete leaderboard of top learners.

#### Scenario: View complete leaderboard
- **WHEN** the user navigates to the Top Learners screen
- **THEN** the system displays a scrollable list of learners sorted by their rank
- **THEN** each learner entry displays their avatar, name, rank, courses completed, and streak days

### Requirement: Dashboard Navigation
The dashboard SHALL provide a mechanism to access the full Top Learners screen.

#### Scenario: Navigate from dashboard
- **WHEN** the user taps the "View All" button on the `TopLearnersSection` of the dashboard
- **THEN** the system navigates the user to the Top Learners screen using platform-neutral routing

### Requirement: Top Learners Card Layout
The dashboard SHALL display learner cards with the points and trophies directly underneath the learner's name, minimizing horizontal width.

#### Scenario: View learner card on dashboard
- **WHEN** the dashboard renders the `TopLearnersSection` carousel
- **THEN** each learner card displays the points (trophies and count) below the learner's name instead of the top-right corner
- **THEN** the card width is constrained to prevent unnecessary whitespace
- **THEN** the card features centered typography, a standalone top-left rank badge, a decorative background shape behind the avatar, and a crown overlay on the avatar.

