## Context

The cortex Flutter app relies on white-label branding, pulling configuration from a remote API. Previously, this only covered splash screens and basic assets. To fully skin the app, we need to inject the client's `primary_color` across the entire design system at runtime/build-time without modifying structural code or maintaining separate app forks.

## Goals / Non-Goals

**Goals:**
- Dynamically fetch the primary color from the client remote config during the build pipeline.
- Inject the color natively into the Flutter app via compiler flags (`--dart-define`).
- Ensure the injected color is used as the base `primary` color in both Light and Dark modes.
- Ensure all other bespoke semantic background and text colors (Zincs, Slates) remain exactly as defined by the original design system.

**Non-Goals:**
- Fetching design system configuration via API at *runtime* (it must happen at build time).
- Passing UI colors through `AppConfig` (violates separation of concerns between core design system and app configuration).

## Decisions

**1. Inject via `--dart-define`**
*Rationale*: Reading `--dart-define=PRIMARY_COLOR=<hex>` in `packages/core/lib/design/design_config.dart` keeps the git working tree clean, avoids hacky code generation scripts, and strictly maintains architectural boundaries (the `app` package doesn't modify the `core` package).
*Alternatives Considered*: Code generation (temporarily generating a `client_branding.dart` file during build). Rejected because it dirties the git tree and risks breaking hot-reload workflows.

**2. Bypass `DesignColors.smart()` inside factories**
*Rationale*: `DesignColors.smart()` defaults to a generic light-mode theme. While great for rapid prototyping, it overrides the highly specific Slate/Zinc semantic grays defined in `DesignColors.light()` and `DesignColors.dark()`. By computing just the primary, onPrimary, and primaryContainers dynamically using a safe `parseColor` helper and dropping them into the existing `DesignColors` constructor block, we preserve the exact design aesthetics while allowing dynamic primary injection.

## Risks / Trade-offs

- **[Risk] Unparseable Hex Code** → Mitigation: Implemented a robust `parseColor` helper that validates string length and strips `0x` prefixes. Added a fallback mechanism with a `debugPrint` warning so the app seamlessly reverts to its default Indigo color without crashing.
- **[Risk] Container Color Contrast** → Mitigation: `darken(primary, 0.6)` is used for dark mode containers. If a client injects an already extremely dark brand color, the container might become near-black. This is an acceptable visual fallback, as `_contrastingColor` guarantees the text on top of it will flip to white for readability.
