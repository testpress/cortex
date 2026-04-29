# Capability: Institute Banner

## Purpose
The Institute Banner provides a client-specific branding surface at the top of the dashboard to display the institute's logo and the user's identification details.

## Requirements

### Requirement: Institute Branding Banner
The system SHALL provide a rebranding banner (`InstituteBanner`) for the top app bar to display institute-specific information.

#### Scenario: Rendering the banner
- **GIVEN** a client configuration with a valid `instituteLogoUrl`
- **WHEN** the `DashboardHeader` is rendered
- **THEN** it MUST display the `InstituteBanner` at the top
- **AND** the banner MUST include the institute logo on the left
- **AND** the banner MUST include the user's name and enrollment ID on the right
- **AND** the banner MUST support both network URLs and local asset paths (via `isLocalLogo` flag)

#### Scenario: Layout and Theming
- **WHEN** the `InstituteBanner` is rendered
- **THEN** it MUST have a specific height (e.g., 64px)
- **AND** it MUST use a pure white background in light mode (`Colors.white`)
- **AND** it MUST use theme-aware surface tokens in dark mode (`design.colors.surface`)
- **AND** it MUST use design system tokens for text colors (`textPrimary`, `textSecondary`) to ensure visibility in both modes
- **AND** text for Name and ID MUST be aligned to the right, stacked vertically
