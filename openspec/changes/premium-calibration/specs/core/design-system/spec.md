## MODIFIED Requirements

### Requirement: WCAG AA Contrast Compliance
All color tokens must ensure sufficient contrast for accessibility, specifically targeting WCAG 2.1 AA standards, and satisfy the Premium Calibration luminance invariants.
- **textPrimary Bound**: Relative luminance of `textPrimary` MUST NOT exceed 0.15.
- **textSecondary Delta**: `textSecondary` MUST have a relative luminance at least 20% higher than `textPrimary`.
- **Pure Black Prohibition**: `Color(0xFF000000)` is PROHIBITED for typography.
- **Dynamic color calculation**: When a primary or background color is defined, the `DesignColors.smart()` factory must be used to calculate contrasting text/foreground colors, ensuring the resulting contrast ratio meet or exceed WCAG AA requirements.

#### Scenario: Dynamic color calculation
- **WHEN** a primary or background color is defined
- **THEN** the `DesignColors.smart()` factory must be used to calculate contrasting text/foreground colors
- **AND** the resulting contrast ratio must meet or exceed WCAG AA requirements

#### Scenario: textSecondary Luminance Check
- **WHEN** `textPrimary` luminance is 0.10
- **THEN** `textSecondary` luminance MUST be >= 0.12

### Requirement: Card surface color token
`DesignColors` SHALL expose `card` (card background) and `onCard` (content on card) color fields. `card` SHALL be visually distinct from `surface` to allow layering, governed by the Surface Contrast Contract.
- **Light mode**: `card` = 0xFFFFFFFF, `surface` = 0xFFF9FAFB.
- **Dark mode**: `card` = 0xFF1E293B (slate-800), `surface` = 0xFF0F172A (slate-900).
- **Radius**: `AppCard` MUST use `design.radius.card` (16.0).
- **Separation**: `AppCard` MUST use `design.shadows.surfaceSoft` AND MUST disable borders if high-elevation shadows are enabled.

#### Scenario: Light mode card is white on off-white surface
- **WHEN** `DesignColors.light().card` is read
- **THEN** it returns `Color(0xFFFFFFFF)`

#### Scenario: Singular Separation Enforcement
- **WHEN** `AppCard` has `showShadow: true`
- **THEN** the `border` property MUST resolve to `null`
- **AND** it MUST use `DesignRadius.card` (16.0)
