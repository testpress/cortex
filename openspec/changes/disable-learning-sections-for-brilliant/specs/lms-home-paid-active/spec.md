## MODIFIED Requirements

### Requirement: Domain-Specific Layout Behavior
The system SHALL support specialized layout rules and section ordering based on client configuration.

#### Scenario: Sticky branding for specialized institutes
- **GIVEN** a client configuration with an active institute banner (e.g., Brilliant)
- **WHEN** the user scrolls the home screen
- **THEN** the `InstituteBanner` MUST remain fixed (sticky) at the top
- **AND** the `DashboardHeader` MUST scroll with the content
- **BUT** for standard clients without a banner, the `DashboardHeader` MUST remain fixed at the top

#### Scenario: Custom section prioritization
- **GIVEN** the "Brilliant" institute configuration
- **WHEN** the dashboard sections are rendered
- **THEN** they MUST follow the specific sequence: Top Carousel -> Updates & Announcements -> Top Learners
- **AND** the Learning Performance section (StudyMomentumGrid) MUST NOT be rendered
- **AND** this sequence MUST NOT affect the default ordering of other subdomains
