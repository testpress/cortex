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
