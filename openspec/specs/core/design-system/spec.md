# Capability: Runtime Design System

## ADDED Requirements

### Requirement: DesignProvider Injection

The application must use a `DesignProvider` at the root to inject design tokens into the widget tree.

#### Scenario: Accessing design tokens

- **WHEN** a widget needs to determine its color, spacing, or typography
- **THEN** it must use `Design.of(context)`
- **AND** it must NOT import static tokens from a constants file

### Requirement: WCAG AA Contrast Compliance

All color tokens must ensure sufficient contrast for accessibility, specifically targeting WCAG 2.1 AA standards.

#### Scenario: Dynamic color calculation

- **WHEN** a primary or background color is defined
- **THEN** the `DesignColors.smart()` factory must be used to calculate contrasting text/foreground colors
- **AND** the resulting contrast ratio must meet or exceed WCAG AA requirements

### Requirement: Reactive Multi-theme Support

The `DesignProvider` MUST support both light and dark configurations and allow switching between them at runtime.

#### Scenario: Automatic system brightness detection

- **WHEN** the system brightness changes
- **AND** the provider is in `DesignMode.system`
- **THEN** the widget tree MUST rebuild with the corresponding configuration
- **AND** the change MUST be reflected immediately in child widgets

## ADDED Requirements from lms-design-tokens

### Requirement: Indexed subject color palette
`DesignConfig` SHALL expose a `subjectPalette` field of type `DesignSubjectPalette`.
`DesignSubjectPalette` SHALL contain an ordered list of at least 8 `SubjectColors`
entries. Each `SubjectColors` SHALL have three `Color` fields: `background`,
`foreground` (WCAG AA contrast on background), and `accent` (border or icon color).
`DesignSubjectPalette` SHALL expose an `atIndex(int i)` method that returns
`SubjectColors` at position `i % palette.length`, so it never throws for any
non-negative integer.
Subject names SHALL NOT appear in the token system. The API provides a `colorIndex`
per subject; widgets call `subjectPalette.atIndex(colorIndex)`.

#### Scenario: Widget resolves subject color from API-provided index
- **WHEN** a widget receives `colorIndex: 2` from a `CourseDto`
- **THEN** calling `Design.of(context).subjectPalette.atIndex(2)` returns a
  non-null `SubjectColors` with non-null `background`, `foreground`, `accent`

#### Scenario: atIndex wraps around modularly
- **WHEN** `atIndex(8)` is called on a palette with 8 slots
- **THEN** it returns the same `SubjectColors` as `atIndex(0)`

#### Scenario: Different indices return visually distinct colors
- **WHEN** `atIndex(0)` and `atIndex(1)` are compared
- **THEN** their `background` colors MUST differ

#### Scenario: Dark mode palette differs from light
- **WHEN** `DesignSubjectPalette.dark().atIndex(0)` is compared to `DesignSubjectPalette.light().atIndex(0)`
- **THEN** the `background` colors MUST differ

#### Scenario: Override via copyWith
- **WHEN** `DesignConfig.copyWith(subjectPalette: custom)` is called
- **THEN** `Design.of(context).subjectPalette.atIndex(0)` returns from the custom palette

---

### Requirement: Status/badge color tokens
`DesignConfig` SHALL expose a `statusColors` field of type `DesignStatusColors`
containing color palettes for four content states: `live`, `completed`, `locked`,
`upcoming`. Each state SHALL have `background` and `foreground` fields.
`foreground` on `background` MUST meet WCAG AA contrast (≥ 4.5:1).
`DesignStatusColors` SHALL have `light()` and `dark()` factory constructors.

#### Scenario: Live status is visually attention-drawing
- **WHEN** `Design.of(context).statusColors.live.background` is read
- **THEN** it returns a vivid red-family color

#### Scenario: Locked status is visually subdued
- **WHEN** `Design.of(context).statusColors.locked.background` is read
- **THEN** it returns a neutral grey-family color

#### Scenario: Dark mode status colors differ from light
- **WHEN** `DesignStatusColors.dark().live.background` is compared to `DesignStatusColors.light().live.background`
- **THEN** the colors MUST differ

---

### Requirement: Card surface color token
`DesignColors` SHALL expose `card` (card background) and `onCard` (content on card)
color fields. `card` SHALL be visually distinct from `surface` to allow layering.
Light mode: `card` = 0xFFFFFFFF, `surface` = 0xFFF9FAFB (surfaceVariant-level).
Dark mode: `card` = 0xFF1E293B (slate-800), `surface` = 0xFF0F172A (slate-900).
`AppCard` SHALL use `design.colors.card` for its background.

#### Scenario: Light mode card is white on off-white surface
- **WHEN** `DesignColors.light().card` is read
- **THEN** it returns `Color(0xFFFFFFFF)`

#### Scenario: Dark mode card is slate-800
- **WHEN** `DesignColors.dark().card` is read
- **THEN** it returns `Color(0xFF1E293B)`

---

### Requirement: CourseDto uses colorIndex
`CourseDto` SHALL replace the `subjectColor: String` field with `colorIndex: int`.
`colorIndex` represents a 0-based index into `DesignSubjectPalette`.
`MockDataSource` SHALL assign `colorIndex` values 0–7 across mock courses to
demonstrate palette variety. No `subjectColor` string field SHALL remain in `CourseDto`.

#### Scenario: CourseCard renders subject color by index
- **WHEN** a `CourseDto` with `colorIndex: 3` is displayed in a `CourseCard`
- **THEN** the card badge or accent uses `design.subjectPalette.atIndex(3).background`
