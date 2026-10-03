# Design

## Context

The product design specifications define **Inter** as the standard UI typography family across all application surfaces. The existing design token system in `packages/core/lib/design/design_config.dart` constructs the atomic typography scale via `DesignTypographyScale.defaults()` using `GoogleFonts.plusJakartaSans`, while `app/lib/main.dart` configures a fallback `ThemeData` specifying `GoogleFonts.notoSans().fontFamily`.

Both `packages/core` and the app shell work seamlessly together: `core` manages the `google_fonts: ^6.2.1` dependency, making Inter (`GoogleFonts.inter`) accessible via design tokens without requiring `app` to manage direct font dependencies.

## Goals / Non-Goals

**Goals:**
- Align the codebase typography tokens with the Figma / product design specifications by switching the default typeface in `DesignTypographyScale.defaults()` to `GoogleFonts.inter`.
- Switch the global fallback theme in `app/lib/main.dart` to derive its font family from `design.typographyScale.base.fontFamily`.
- Maintain identical font sizing, line height, letter spacing, font weight distributions, and semantic roles across the application.

**Non-Goals:**
- Altering typography scale values (`fontSize`, `lineHeight`, `letterSpacing`) or introducing new font weights.
- Adding custom offline `.ttf` asset bundles unless requested.

## Decisions

### Decision: Update `DesignTypographyScale.defaults()` to use `GoogleFonts.inter`
- **Rationale**: `DesignTypographyScale` acts as the single source of truth for all semantic text widgets (`AppText`, `DesignTypography`). Changing `final f = GoogleFonts.inter;` propagates Inter to every token in the system cleanly and automatically.
- **Alternatives Considered**: Modifying individual widget styles directly. Rejected because it violates design system centralized token governance.

### Decision: Align `ThemeData.fontFamily` in `app/lib/main.dart` from design tokens
- **Rationale**: Keeps Material fallback components (e.g., standard Dialogs, Tooltips, SnackBars) visually coherent with the core design system by reading `design.typographyScale.base.fontFamily`, maintaining a single source of truth in `core` and removing font duplication in the app shell.
- **Alternatives Considered**: Hardcoding `GoogleFonts.inter().fontFamily` directly in `app/lib/main.dart`. Rejected because it duplicates the font choice and creates dual maintenance.

## Risks / Trade-offs

- **[Font Metrics Shift]** Inter has slightly different character widths and x-height compared to Plus Jakarta Sans. → Typography scale line heights and standard padding tokens are preserved; standard UI tests will verify that text layout does not overflow constrained boxes.
