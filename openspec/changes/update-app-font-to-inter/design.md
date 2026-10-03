# Design

## Context

The product design specifications define **Inter** as the standard UI typography family across all application surfaces. The existing design token system in `packages/core/lib/design/design_config.dart` constructs the atomic typography scale via `DesignTypographyScale.defaults()` using `GoogleFonts.plusJakartaSans`, while `app/lib/main.dart` configures a fallback `ThemeData` specifying `GoogleFonts.notoSans().fontFamily`.

Both packages already include the `google_fonts: ^6.2.1` dependency, making Inter (`GoogleFonts.inter`) immediately accessible without updating dependency locks or adding external assets.

## Goals / Non-Goals

**Goals:**
- Align the codebase typography tokens with the Figma / product design specifications by switching the default typeface in `DesignTypographyScale.defaults()` to `GoogleFonts.inter`.
- Switch the global fallback theme in `app/lib/main.dart` to `GoogleFonts.inter().fontFamily`.
- Maintain identical font sizing, line height, letter spacing, font weight distributions, and semantic roles across the application.

**Non-Goals:**
- Altering typography scale values (`fontSize`, `lineHeight`, `letterSpacing`) or introducing new font weights.
- Adding custom offline `.ttf` asset bundles unless requested.

## Decisions

### Decision: Update `DesignTypographyScale.defaults()` to use `GoogleFonts.inter`
- **Rationale**: `DesignTypographyScale` acts as the single source of truth for all semantic text widgets (`AppText`, `DesignTypography`). Changing `final f = GoogleFonts.inter;` propagates Inter to every token in the system cleanly and automatically.
- **Alternatives Considered**: Modifying individual widget styles directly. Rejected because it violates design system centralized token governance.

### Decision: Align `ThemeData.fontFamily` in `app/lib/main.dart`
- **Rationale**: Keeps Material fallback components (e.g., standard Dialogs, Tooltips, SnackBars) visually coherent with the core design system.
- **Alternatives Considered**: Leaving `ThemeData.fontFamily` untouched. Rejected because it causes inconsistent typography between design tokens and standard Material widgets.

## Risks / Trade-offs

- **[Font Metrics Shift]** Inter has slightly different character widths and x-height compared to Plus Jakarta Sans. → Typography scale line heights and standard padding tokens are preserved; standard UI tests will verify that text layout does not overflow constrained boxes.
