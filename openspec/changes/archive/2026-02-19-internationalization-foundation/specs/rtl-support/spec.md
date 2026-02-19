# Capability: RTL Support

## ADDED Requirements

### Requirement: Logical Geometry Enforcement

All layout-defining components in the SDK MUST use logical (directional) units instead of physical units.

#### Scenario: Automatic layout flipping

- **WHEN** the active locale is for an RTL language (e.g., Arabic)
- **THEN** widgets using `EdgeInsetsDirectional.only(start: 16)` MUST render the padding on the right side
- **AND** `AlignmentDirectional.centerStart` MUST resolve to center-right

### Requirement: Directionality Awareness

The SDK primitives MUST explicitly respect the `Directionality` provided by the context.

#### Scenario: Respecting inheritance

- **WHEN** a widget is built within a `Directionality(textDirection: TextDirection.rtl)` tree
- **THEN** its `AppSemantics` and visual structure MUST default to RTL behavior
