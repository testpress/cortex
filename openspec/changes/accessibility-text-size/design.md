## Context

The application has a text size selection settings option (Small, Medium, Large) managed in the settings screen. While database storage and state providers for this preference exist, the UI does not dynamically reflect these changes.

## Goals / Non-Goals

**Goals:**
- Dynamically scale all text in the app according to the user's selected text size preference.
- Respect and compose with the device's system font size preference (WCAG compliance).
- Maintain clean package encapsulation by preventing domain settings parsing logic from leaking into the `app` consumer shell.

**Non-Goals:**
- Adding settings to other packages besides `profile`.
- Modifying individual text components (all scaling must happen at the root).

## Decisions

### Decision 1: Expose scale factor as a Provider in the `profile` package
- **Option A**: Parse settings raw database data in the `app` package.
  - *Pros*: Avoids adding a new provider.
  - *Cons*: Leaks database models and parsing logic into the app shell.
- **Option B**: Create `appTextScaleMultiplierProvider` as a clean proxy double provider in `packages/profile/lib/providers/settings_providers.dart`.
  - *Pros*: Completely encapsulates parsing of text scale size into a simple double multiplier value (`0.85`, `1.0`, or `1.15`), keeping the app package clean.
  - *Cons*: None.
- **Decision**: Option B.

### Decision 2: Combine custom scale with system text scale
- **Option A**: Completely override the system text scaler with `TextScaler.linear(scaleFactor)`.
  - *Pros*: Simple to implement.
  - *Cons*: Overwrites and ignores OS-level accessibility features, violating accessibility principles.
- **Option B**: Compose with the system text scaler using `originalData.textScaler.scale(scaleFactor)`.
  - *Pros*: Maintains full compatibility with both OS-level font sizing and app-level custom sizing.
  - *Cons*: None.
- **Decision**: Option B.

## Risks / Trade-offs

- **[Risk] Layout Overflow** → Larger text scaling (1.15x combined with system scaling) might cause clipping or overflow on screens with fixed layouts.
- **[Mitigation]** The codebase uses standard layout elements (like `AppScroll` or flexible layouts) and enforces WCAG line height dynamics through `AppText`.
