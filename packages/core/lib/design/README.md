# Design Governance Foundation

# Purpose
The Cortex Design System is a runtime-first architecture. Unlike traditional Flutter apps that often rely on static token sets, Cortex utilizes a **DesignProvider** to inject design decisions at the root of the widget tree. This enables the platform to scale from a single SDK to a multi-tenant, white-labeled solution.

# Runtime Design Philosophy
Traditional static tokens (`AppColors.primary`) create a rigid binary. To change a color, you must change the source code. In our architecture, tokens are treated as **runtime configurations**. This allows for:
- **Tenant Specific Branding**: Injecting different `DesignConfig` objects per application.
- **Dynamic Theming**: Switching between light, dark, or high-contrast modes without app restarts.
- **AI-Adaptive UI**: Real-time adjustment of spacing, radius, or typography based on user proficiency or physical constraints.

# Token Injection Model
We use a lightweight **DesignContext** (`InheritedWidget`) to propagate tokens. Access is provided via the `Design.of(context)` convenience accessor. This ensures:
- **O(1) Lookup**: Standard Flutter inherited widget performance.
- **Rebuild Control**: Only widgets that depend on the design context rebuild when tokens change.
- **Assertion Policing**: The system automatically asserts if a widget tries to access design tokens outside of a `DesignProvider` tree, preventing "gray-screen" runtime errors in production.

# AI-First Adaptability Goals
The `DesignProvider` architecture is specifically designed to support future **AI-adaptive UX**. By moving design decisions out of static code and into a runtime context, we enable:
- **Contextual Token Modulation**: Machine learning models can adjust spacing or colors based on user intent, focus, or physical environment.
- **Predictive Theming**: Dynamically switching design configurations to match the user's current cognitive load or task complexity.
- **Accessibility Auto-Tuning**: AI can automatically select higher-contrast tokens or larger targets if it detects a user is struggling with the interface.

# Architectural Standards

### The Smart Factory
We use `DesignColors.smart()` to handle WCAG contrast ratios automatically. By providing only the primary brand color, the system calculates relative luminance and assigns appropriate text colors (`onPrimary`, etc.), ensuring accessibility by construction.

### Immutability
`DesignConfig` and its child token groups (Colors, Spacing, etc.) are deeply immutable. Any changes must be made via `copyWith` and injected through a new `DesignProvider` instance, ensuring predictable state propagation.

# Anti-Patterns

- **No Direct Token Imports**: Never import `packages/core/lib/tokens/colors.dart` directly in UI code. Always read from context.
- **No Global Static State**: Avoid global singleton theme managers. Use the widget-tree as the source of truth.
- **No Manual Contrast Overrides**: Do not manually set text colors that bypass the smart contrast calculations unless there is a documented design exception.

# Integration for Consumer Modules
External modules (e.g., `package:courses`) must depend on this design runtime. They inherit branding from whichever `DesignProvider` is at the root of the consumer's application (e.g., `app/`).
