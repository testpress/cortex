# premium-calibration Specification

## Purpose
TBD - created by archiving change premium-calibration. Update Purpose after archive.
## Requirements
### Requirement: Surface Contrast Contract
The system MUST enforce measurable luminance relationships between stacking surfaces.
- **Luminance Delta**: The relative luminance delta between `background` (L1) and `surface` (L2) MUST be between 0.02 and 0.08.
- **Contrast Ratio**: The contrast ratio between `card` (L3) and `background` (L1) MUST be >= 1.05:1 but <= 1.15:1 (refined for Slate-150 midpoint).
- **Chromatic Invariant (Dark Mode)**: The `surface`, `card`, and `canvas` tokens in dark mode MUST follow a neutral gray/black scale (Zinc/Neutral). Blue component saturation MUST NOT exceed 2% delta from red/green components.
- **Stacking Invariant**: Pure white surfaces (`#FFFFFF`) MUST NOT be stacked directly on top of each other without a singular separation layer.
- **Separation Decision Logic**: Surface separation MUST use exactly one of the following methods, prioritized:
  1. `DesignShadows.surfaceSoft` (elevation)
  2. `DesignColors.surfaceVariant` (color delta)
  3. `DesignColors.border` (edge contrast)

#### Scenario: Singular Separation Enforcement
- **WHEN** `BoxShadow` is present on a surface
- **THEN** the `border` property MUST resolve to `null`
- **AND** the `color` property MUST NOT be modified to create additional contrast

### Requirement: Shadow Governance
The system MUST constrain all elevation shadows to specific mathematical ranges.
- **Opacity Range**: `BoxShadow.color.opacity` MUST be >= 0.03 and <= 0.045.
- **Minimum Blur**: `BoxShadow.blurRadius` MUST be >= 40.0.
- **Offset Symmetry**: `BoxShadow.offset.dx` MUST be 0.0. `BoxShadow.offset.dy` MUST be >= 4.0 and <= 12.0.
- **Layer Limit**: Each surface MUST NOT have more than one `BoxShadow` entry.

#### Scenario: shadow-surfaceSoft Validation
- **WHEN** `DesignShadows.surfaceSoft` is invoked
- **THEN** it returns a shadow with `opacity: 0.04`, `blurRadius: 40.0`, and `offset: Offset(0, 8)`

### Requirement: Radius Hierarchy Contract
The system MUST enforce a descending radius hierarchy based on a `baseRadius` (8.0).
- **Invariants**:
  - `Radius.card` = `baseRadius * 2` (16.0)
  - `Radius.dialog` = `baseRadius * 1.5` (12.0)
  - `Radius.button` = `baseRadius * 1.5` (12.0)
  - `Radius.compact` = `baseRadius * 0.5` (4.0)
- **Arbitrary Radius Restriction**: Hardcoded `BorderRadius` values are PROHIBITED.

#### Scenario: radius-card Precision
- **WHEN** the system renders a `card`
- **THEN** it MUST use `DesignRadius.card` which evaluates to exactly 16.0

### Requirement: Spacing Enforcement
The system MUST restrict all layout gaps and padding to a predefined atomic set.
- **Allowed Spacing Set**: `{4, 8, 12, 16, 24, 32, 40, 48, 64}`.
- **Violation Condition**: Any spacing value `S` where `S` is not in the Allowed Spacing Set is a violation.

#### Scenario: Spacing Violation
- **WHEN** a container uses `padding: 18`
- **THEN** the system flags a token violation during validation

### Requirement: Typography Contrast Model
The system MUST regulate text colors through luminance bounds and relative contrast deltas.
- **textPrimary Bound**: Relative luminance of `textPrimary` MUST NOT exceed 0.15.
- **textSecondary Delta**: `textSecondary` MUST have a relative luminance at least 20% higher than `textPrimary`.
- **Pure Black Prohibition**: `Color(0xFF000000)` is PROHIBITED for typography.

#### Scenario: textSecondary Luminance Check
- **WHEN** `textPrimary` luminance is 0.10
- **THEN** `textSecondary` luminance MUST be >= 0.12

### Requirement: Anti-Regression Rules
The system MUST programmatically enforce token-only styling.
- **Elevation Ban**: Material `elevation` properties ARE PROHIBITED.
- **Border/Shadow Conflict**: Combining `showBorder: true` and `showShadow: true` on the same widget is a violation.
- **Inline Styling Ban**: Hardcoded color or radius values in widget builds ARE PROHIBITED.

#### Scenario: Token-Only Enforcement
- **WHEN** a widget build uses `color: Color(0xFFFFFFFF)` directly
- **THEN** the system MUST flag a design-system violation

