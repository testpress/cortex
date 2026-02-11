# Neutral UI Primitives

# Purpose
These are the foundational building blocks of the Cortex SDK. By using a **Canvas-first** approach, we ensure that the application rendering is identical across every platform Flutter supports, without inheriting the visual baggage or technical constraints of Material or Cupertino libraries.

# Architectural Principles

### Canvas-First Rendering
We use low-level widgets (`Container`, `CustomPaint`, `Stack`, `Text`) instead of framework-specific themeable widgets. This ensures:
- **No Invisible State**: There are no platform-specific shadows, ripples, or elevation effects that we don't explicitly control.
- **Predictable Sizing**: All dimensions are deterministic and respect our `DesignSpacing` tokens exactly.

### Target Enforcement (48dp)
We implement a strict hit-target policy. Regardless of a primitive's visual size, all interactive elements are internally expanded using the `accessibility_guard` to ensure a minimum touch target of **48x48dp**. This is a non-negotiable architectural constraint for WCAG 2.5.5 compliance.

### Platform Neutrality
A primitive must never check `Platform.isIOS` or `Platform.isAndroid` to determine its appearance. Interaction patterns (like long-press vs swipe) are handled at the infra layer, but the visual manifestation remains uniquely "Cortex".

# Standard Primitives

- **AppText**: A semantic wrapper around Flutter's `Text`. It maps design tokens to typography roles and ensures font scaling and overflow behaviors are consistent.
- **AppButton**: A high-interaction primitive that supports focus states, active/inactive styling, and accessibility roles. It enforces the semantic contrast contract.
- **AppCard**: A structural container that enforces standard `radius` and `padding` tokens, used for grouping related content.
- **AppHeader**: An architectural landmark that replaces the standard `AppBar`. It handles status-bar transparency and semantic landmark exposure.
- **AppScroll**: A physics-governed container that standardizes `OverscrollIndicator` behavior and screen-edge padding.

# Accessibility Integration
Every primitive is architected with a "Semantics-First" mindset. Interactive primitives MUST be wrapped in the appropriate `AppSemantics` helper within their `build` method. Developers should never need to add raw `Semantics` tags when consuming these primitives.

# Core Constraint
These primitives are intended to be the **ONLY** UI building blocks used by domain modules (e.g., `packages/courses`). Direct usage of `Scaffold`, `ElevatedButton`, or `ListTile` in those modules is considered an architectural violation.
