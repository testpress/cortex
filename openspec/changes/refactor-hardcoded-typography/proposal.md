## Why

The current implementation of the `courses` package widgets contains over 50 instances of hardcoded `TextStyle` properties (fontSize, fontWeight, letterSpacing). This bypasses the `DesignTypography` system, leading to visual inconsistency, making global typography updates difficult, and violating the design-to-code contract.

## What Changes

- Refactor all widgets in `packages/courses/lib/widgets/` to remove hardcoded `TextStyle` in favor of semantic `AppText` constructors.
- Align widget typography with the newly introduced `DesignTypographyScale` tokens.
- Standardize complex text components (like stat grids and headers) to use theme-compliant roles.

## Capabilities

### New Capabilities
- `refactor-typography`: Establish a standardized way to map dense dashboard layouts to the typography scale without using magic numbers.

### Modified Capabilities
- `core-typography`: Enhance the primitive text components if any recurring hardcoded patterns (like 15px/w500) suggest a missing semantic role.

## Impact

- `packages/courses`: Significant refactoring of all UI widgets.
- `packages/core`: Potential minor updates to `AppText` or `DesignTypographyScale`.
