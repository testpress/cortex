# Capability: Accessibility Contract

## ADDED Requirements

### Requirement: Mandatory Semantics

All interactive or informational components must explicitly define their semantic role and labels using `AppSemantics`.

#### Scenario: Making a widget accessible

- **WHEN** a widget is interactive (onTap, etc.)
- **THEN** it must be wrapped in `AppSemantics.button()` or equivalent helper
- **AND** it must provide a clear, descriptive label for screen readers

### Requirement: Motion Governance

Animations and transitions must respect the user's system-level motion preferences.

#### Scenario: Triggering an animation

- **WHEN** a widget is about to perform an animation or transition
- **THEN** it must check `MotionPreferences.shouldAnimate(context)`
- **AND** if the result is false, the animation must be skipped or significantly reduced
