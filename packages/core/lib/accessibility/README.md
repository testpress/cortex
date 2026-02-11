# Accessibility Infrastructure

# Purpose
Cortex is built on a **Neutral UI** philosophy, which removes default Material and Cupertino widgets. Consequently, we lose the built-in accessibility semantics provided by those frameworks. This infrastructure serves as the mandatory bridge to ensure the platform is fully navigable by screen readers and other assistive technologies.

# Architectural Decisions

### Centralized Role Exposure
Instead of using raw `Semantics` widgets throughout the codebase, we use **AppSemantics** helpers. This centralizes the contract for what constitutes a "button", "header", or "landmark" in our system, preventing fragmented implementations.

### Focus Management
The **AppFocusable** foundation manages the keyboard and switch-control navigation tree. It ensures that focus follows logical reading order and provides high-visibility focus indicators across all platforms.

### Target Enforcement
The **accessibility_guard** is an architectural interceptor that enforces WCAG 2.5.5 requirements. It ensures that every interactive element has a minimum hit target of **48x48dp**, regardless of its visual size.

# Accessibility Contracts

1. **Role Clarity**: Every interactive element MUST have an explicit semantic role.
2. **Text Equivalency**: Non-text elements (icons, graphics) must provide meaningful labels or be marked as decorative.
3. **Hierarchy Landmarks**: Screen headers and major sections must be marked as headers to allow screen reader users to jump between landmarks.
4. **State Transparency**: Buttons and toggles must expose their state (enabled/disabled, active/inactive) to the accessibility tree.

# What Future Contributors Must NOT Do

- **Never wrap primitives with raw Semantics**: Always use the provided `AppSemantics` helpers to maintain role consistency.
- **Never ignore the 48dp rule**: Do not bypass the `accessibility_guard` or manually override hit targets to be smaller than the WCAG minimum.
- **Never assume platform defaults**: Since we are platform-neutral, we cannot rely on iOS or Android to "guess" our intent. We must be explicit.

# WCAG 2.1 AA Checklist Integration

- [x] **1.1.1 Non-text Content**: Controlled via AppSemantics labels.
- [x] **2.1.1 Keyboard**: Handled via AppFocusable.
- [x] **2.4.3 Focus Order**: Managed by structural focus tree.
- [x] **2.5.5 Target Size**: Enforced by accessibility_guard.
- [x] **4.1.2 Name, Role, Value**: Guaranteed by semantic helpers.
