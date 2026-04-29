## MODIFIED Requirements

### Requirement: Today's Schedule Smart Grouping
#### Scenario: Gated accessibility
- **GIVEN** the client configuration has `showTodaySchedule` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `TodaySnapshot` section MUST be hidden from the UI
- **AND** any associated data fetching for this section SHOULD be bypassed

### Requirement: Fast-tracked Actions
#### Scenario: Gated Quick Access
- **GIVEN** the client configuration has `showQuickAccess` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `QuickAccessGrid` MUST NOT be visible

#### Scenario: Gated Contextual Hero
- **GIVEN** the client configuration has `showContextualHero` set to `false`
- **WHEN** the `PaidActiveHomeScreen` is rendered
- **THEN** the `ContextualHeroCard` MUST NOT be displayed

### Requirement: Domain-Specific Layout Behavior
#### Scenario: Sticky branding for specialized institutes
- **GIVEN** a client configuration with an active institute banner (e.g., Brilliant)
- **WHEN** the user scrolls the home screen
- **THEN** the `InstituteBanner` MUST remain fixed (sticky) at the top
- **AND** the `DashboardHeader` MUST scroll with the content
- **BUT** for standard clients without a banner, the `DashboardHeader` MUST remain fixed at the top

#### Scenario: Custom section prioritization
- **GIVEN** the "Brilliant" institute configuration
- **WHEN** the dashboard sections are rendered
- **THEN** they MUST follow the specific sequence: Top Carousel -> Updates & Announcements -> Learning Performance -> Top Learners
- **AND** this sequence MUST NOT affect the default ordering of other subdomains
