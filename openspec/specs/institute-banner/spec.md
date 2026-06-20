# Capability: Institute Banner

## Purpose
The Institute Banner provides a client-specific branding surface at the top of the dashboard to display the institute's logo and the user's identification details.
## Requirements
### Requirement: Institute Branding Banner
The system SHALL provide a rebranding banner (`InstituteBanner`) for the top app bar to display institute-specific information, with the user's identification details conditionally shown based on the Profile tab configuration.

#### Scenario: Rendering the banner
- **GIVEN** a client configuration with a valid `instituteLogoUrl`
- **WHEN** the `InstituteBanner` is rendered
- **THEN** it MUST display the institute logo on the left
- **AND** it MUST support both network URLs and local asset paths (via `isLocalLogo` flag)

#### Scenario: User info visible when Profile tab is disabled
- **GIVEN** `AppConfig.showProfileTab` is `false`
- **WHEN** the `InstituteBanner` is rendered
- **THEN** the user's name and enrollment ID MUST be visible in the top-right of the banner
- **AND** text MUST be aligned to the right, stacked vertically

#### Scenario: User info hidden when Profile tab is enabled
- **GIVEN** `AppConfig.showProfileTab` is `true`
- **WHEN** the `InstituteBanner` is rendered
- **THEN** the user's name and enrollment ID block MUST NOT be rendered

#### Scenario: Layout and Theming
- **WHEN** the `InstituteBanner` is rendered
- **THEN** it MUST have a specific height (e.g., 64px)
- **AND** it MUST use `design.colors.canvas` as the background color (theme-aware, no hardcoded color)
- **AND** it MUST use design system tokens for text colors (`textPrimary`, `textSecondary`) to ensure visibility in both modes

