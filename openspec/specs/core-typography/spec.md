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
| `xs` | 12px | 1.2 | Caption |
| `sm` | 14px | 1.4 | BodySmall |
| `base` | 16px | 1.5 (Role-based) | Body |
| `lg` | 18px | — | Subtitle |
| `xl` | 20px | — | Title |
| `xl2` | 24px | — | Headline |
| `xl3` | 30px | — | Display |
| `xl4` | 36px | — | — |
| `xl5` | 48px | — | — |

### Requirement: Integrated Typography Attributes
The system SHALL treat a "Typography Molecule" as a cohesive unit of at least five attributes: Size, Weight, Line Height, Letter Spacing, and **Semantic Color**.

#### Scenario: Display Molecule
- **WHEN** the `AppText.display()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 30px (`xl3` atom)
  - **Weight**: `FontWeight.w700`
  - **Height**: None (Default)
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

#### Scenario: Card Title Molecule
- **WHEN** the `AppText.cardTitle()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 14px (`sm` atom)
  - **Weight**: `FontWeight.w600`
  - **Height**: 1.2
  - **Color**: `design.colors.textPrimary`

#### Scenario: Card Subtitle Molecule
- **WHEN** the `AppText.cardSubtitle()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 12px (`xs` atom)
  - **Weight**: `FontWeight.w600`
  - **Height**: 1.2
  - **Color**: `design.colors.textSecondary`

#### Scenario: Card Caption Molecule
- **WHEN** the `AppText.cardCaption()` role is used
- **THEN** it SHALL resolve to:
  - **Size**: 12px (`xs` atom)
  - **Weight**: `FontWeight.w400`
  - **Height**: 1.0
  - **Color**: `design.colors.textSecondary`

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
- **THEN** they MUST use `AppText.cardTitle()` for primary headings
- **AND** they MUST use `AppText.cardSubtitle()` for secondary info (12px/w600)
- **AND** they MUST use `AppText.cardCaption()` for micro-metadata (12px/w400)
- **AND** they MUST NOT specify manual pixel sizes.

#### Scenario: Display-Level Greeting
- **WHEN** the primary user greeting is rendered
- **THEN** it MUST use a `Display` or `Headline` level semantic style to establish visual priority.

#### Scenario: Exceptional Scale Usage
- **WHEN** rendering non-standard typography (e.g., large numerical stats)
- **THEN** the system MAY use atomic scale tokens (e.g., `AppText.xl3()`)
- **AND** the rationale MUST be documented in the code.
