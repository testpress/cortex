## MODIFIED Requirements

### Requirement: Domain-Specific Layout Behavior
The system SHALL use a single, unified widget order for the dashboard scroll body, regardless of whether a banner logo is configured.

#### Scenario: Sticky branding for specialized institutes
- **GIVEN** a client configuration with an active institute banner (e.g., Brilliant)
- **WHEN** the user scrolls the home screen
- **THEN** the `InstituteBanner` MUST remain fixed (sticky) at the top
- **AND** the `DashboardHeader` MUST scroll with the content
- **BUT** for standard clients without a banner, the `DashboardHeader` MUST remain fixed at the top

#### Scenario: Unified widget order for all clients
- **WHEN** the dashboard scroll body is rendered for any client
- **THEN** the widget order MUST follow this fixed sequence:
  1. Contextual Hero Card (if `showContextualHero` is `true`)
  2. Today's Schedule (if `showTodaySchedule` is `true`)
  3. Lesson Cards Section
  4. Updates & Announcements
  5. Study Momentum
  6. Top Learners
  7. Quick Access Grid (if `showQuickAccess` is `true`)
- **AND** this order MUST NOT be forked or altered based on the presence of a banner logo or any client URL string

#### Scenario: Study Momentum shown for all clients
- **WHEN** the dashboard scroll body is rendered
- **THEN** the `StudyMomentumGrid` MUST be included in the widget list for all clients
- **AND** if the server returns no momentum data, the widget MUST self-hide (return `SizedBox.shrink()`)
- **AND** the `isBrilliantPala` URL string check MUST NOT be used to conditionally hide this section

## ADDED Requirements

### Requirement: Dynamic Header Title
The system SHALL display the actual institute name as the dashboard header title when no banner logo is configured.

#### Scenario: Institute name available
- **WHEN** `isBannerPresent` is `false`
- **AND** `InstituteSettings.current?.name` is non-empty
- **THEN** the `DashboardHeader` title MUST display the institute name from `InstituteSettings`

#### Scenario: Institute name unavailable
- **WHEN** `isBannerPresent` is `false`
- **AND** `InstituteSettings.current` is `null` or `name` is empty
- **THEN** the `DashboardHeader` title MUST fall back to the localized `homeHeaderTitle` string
