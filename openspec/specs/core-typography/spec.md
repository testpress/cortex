# Purpose
The `core-typography` capability provides a standardized, scale-based typography system that replaces arbitrary font sizes with a consistent, accessible, and high-fidelity text rendering framework. It simplifies the developer experience by mapping semantic UI roles (H1-H4, body, etc.) to a foundational scale, ensuring design consistency and eliminating "magic numbers" in feature code.

# Requirements

## ADDED Requirements

### Requirement: Foundational Typography Scale
The system SHALL provide a standardized, scale-based typography system to replace arbitrary font sizes.

#### Scenario: Predefined Scale Access
- **WHEN** a developer accesses typography tokens in `DesignConfig`
- **THEN** they SHALL have access to a scale containing:

| Token | Font Size (px) | Default Line Height | Weight Mapping |
| --- | --- | --- | --- |
| `xs` | 12px | 1.3 | Caption |
| `sm` | 14px | 1.5 | BodySmall |
| `base` | 16px | 1.5 | Body |
| `lg` | 18px | 1.4 | Subtitle |
| `xl` | 20px | 1.4 | Title |
| `xl2` | 24px | 1.3 | Headline |
| `xl3` | 30px | 1.2 | Display |
| `xl4` | 36px | 1.1 | — |
| `xl5` | 48px | 1.0 | — |

### Requirement: Integrated Typography Attributes
The system SHALL treat a "Typography Molecule" as a cohesive unit of at least five attributes: Size, Weight, Line Height, Letter Spacing, and **Semantic Color**.

#### Scenario: Display Molecule
- **WHEN** the `AppText.display()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 30px (`xl3` atom)
  - **Weight**: `FontWeight.w700`
  - **Height**: 1.2
  - **Letter Spacing**: -0.5
  - **Color**: `design.colors.textPrimary`

#### Scenario: Caption Molecule
- **WHEN** the `AppText.caption()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 12px (`xs` atom)
  - **Weight**: `FontWeight.w400`
  - **Height**: 1.3
  - **Letter Spacing**: 0.2
  - **Color**: `design.colors.textSecondary` (Defaulting to muted for captions)

### Requirement: Optical Tracking Logic
The system SHALL provide "Optical Tracking" where letter spacing is automatically tightened as the scale increases, ensuring visual tension in headings and clarity in body text.

### Requirement: Scale-Based Widget Constructors
The `AppText` widget SHALL provide direct access to the foundational scale via named constructors.

#### Scenario: Direct Scale Usage
- **WHEN** a developer uses `AppText.lg("Hello")`
- **THEN** the text SHALL render using the `lg` (18px) scale style, even if no semantic role exists for that size.


### Requirement: Accessibility-Aware Scaling
All typography scales SHALL respect the user's system font size preferences.

#### Scenario: Respecting Text Scaler
- **WHEN** the user increases text size in their system settings
- **THEN** `AppText` components using any scale SHALL scale proportionally.

---

## ADDED Requirements from refactor-hardcoded-typography

### Requirement: Semantic Typography Resolution
The system SHALL resolve widget text styles primarily through semantic `AppText` constructors that reflect the content's functional role, rather than atomic measurements.

#### Scenario: Dashboard Section Headers
- **WHEN** a dashboard section title (e.g., "Today's Schedule") is rendered
- **THEN** it MUST use the `AppText.title()` constructor (or equivalent internal semantic role)
- **AND** it MUST NOT use a hardcoded `fontSize`.

#### Scenario: Card-Level Hierarchy
- **WHEN** card-based components (Snapshot Cards, Course Cards) are rendered
- **THEN** they MUST use `AppText.subtitle()` for secondary titles and `AppText.bodySmall()` for metadata
- **AND** they MUST NOT specify manual pixel sizes.

#### Scenario: Display-Level Greeting
- **WHEN** the primary user greeting is rendered
- **THEN** it MUST use a `Display` or `Headline` level semantic style to establish visual priority.

#### Scenario: Exceptional Scale Usage
- **WHEN** rendering non-standard typography (e.g., large numerical stats)
- **THEN** the system MAY use atomic scale tokens (e.g., `AppText.xl3()`)
- **AND** the rationale MUST be documented in the code.
