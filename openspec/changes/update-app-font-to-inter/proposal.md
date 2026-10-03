# Proposal

## Why

The product design system and Figma UI designs specify the **Inter** typeface family for all application interfaces. Currently, the codebase defaults to Plus Jakarta Sans for its typography scale and Noto Sans for its MaterialApp fallback. Switching the primary typeface to Inter aligns the codebase with the official design system specifications while ensuring consistent typography, neutral readability, and cross-platform UI clarity across all mobile and web LMS experiences.

## What Changes

- Update `DesignTypographyScale.defaults()` in `packages/core` to construct all typography scale atoms using `GoogleFonts.inter`.
- Update the global fallback `MaterialApp` theme in `app/lib/main.dart` to use `GoogleFonts.inter().fontFamily`.
- Preserve all existing atomic scale sizes (`xxs` through `xl5`), font weights, line heights, and semantic `AppText` roles.

## Capabilities

### New Capabilities
None.

### Modified Capabilities
- `core-typography`: Updates the foundational typography scale to construct font tokens using `GoogleFonts.inter`.

## Impact

- `packages/core`: `DesignTypographyScale.defaults()` in `design_config.dart`.
- `app`: Global `ThemeData` in `main.dart`.
- Visual rendering of all UI text rendered via `AppText` and design typography tokens.
