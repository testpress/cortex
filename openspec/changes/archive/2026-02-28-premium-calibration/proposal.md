## Why

The current UI design tokens and primitives lack formal mathematical constraints, leading to inconsistent visual hierarchy, inappropriate contrast, and sub-optimal spacing. Additionally, the dark mode palette is overly biased toward blue hues and lacks sufficient surface separation, rendering nested cards invisible. This change establishes a strict, enforceable design system framework (Premium Calibration) that replaces subjective aesthetic judgments with measurable invariants and neutralizes the chromatic bias of the dark mode palette.

## What Changes

Establish a constraint-driven design system with the following enforceable rules:
- **Surface Contrast Contract**: Mandatory luminance delta between stacking surfaces.
- **Shadow Governance**: Strict opacity (0.03–0.045) and vertical-only offset rules.
- **Radius Hierarchy**: Mathematical relationship between component radii (card > dialog > button).
- **Spacing Enforcement**: Strict alignment to an allowed atomic set (8pt grid).
- **Typography Contrast Model**: Mandatory luminance relationships between primary and secondary text.
- **Anti-Regression Rules**: Explicit prohibition of border + shadow stacking and non-token styling.

## Capabilities

### New Capabilities
- `premium-calibration`: The core specification for the unified visual constraint system, including surface contracts, shadow governance, and spacing invariants.

### Modified Capabilities
- `lms-design-tokens`: Update default token values in `design_config.dart` to satisfy the newly established Premium Calibration constraints.

## Impact

- **Core Package**: Refactor `design_config.dart` and `AppCard` primitive.
- **Tests**: Update all primitive design tests to validate against specific numeric constraints rather than presence of tokens.
