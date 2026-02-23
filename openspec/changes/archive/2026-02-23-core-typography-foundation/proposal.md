## Why

The current typography system relies on a sparse set of semantic roles that do not cover the visual density required by complex enterprise UIs (like the LMS dashboards). This forces developers to use "magic numbers" (e.g., `fontSize: 18`) in feature code, leading to design inconsistency and maintenance debt.

## What Changes

- **Foundation Scale**: A set of 9 standardized font sizes (`xs`, `sm`, `base`, `lg`, `xl`, `xl2`, `xl3`, `xl4`, `xl5`) that map to specific use cases.
- **Hybrid Support**: Update `AppText` to support both the foundational scale (for precise custom layouts) and semantic roles (for standard UI).
- **Consistent Tokens**: Standardize line-heights and letter-spacings for each scale to ensure professional rhythm across all text.

## Capabilities

### New Capabilities
- `core-typography`: A standardized system for text rendering that provides a foundational scale mapped to semantic roles, ensuring design consistency and eliminating hardcoded values.

### Modified Capabilities
<!-- No requirement changes to existing capabilities -->

## Impact

- **`packages/core`**: Major updates to `DesignConfig` (tokens) and `AppText` (widget constructors).
- **`packages/courses`**: Future cleanup of LMS widgets to use the new scale.
- **Design Process**: Provides a shared language between design and engineering for all text elements.
