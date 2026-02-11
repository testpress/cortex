# ADR 0004: Runtime DesignProvider

# Context
Static token imports (`AppColors.primary`) prevent runtime customization. This makes it impossible to implement white-label branding, dark mode transitions, or AI-adaptive UI without a full application rebuild or complex global state management.

# Decision
We replaced static token imports with a runtime `DesignProvider` using Flutter's `InheritedWidget`. Widgets now source their styling from `Design.of(context)`, making the design system dynamic and context-aware.

# Consequences
- **Requirement**: A `DesignProvider` must exist at the root of the widget tree.
- **Benefit**: Enables theme switching and branding updates without app restarts.
- **Benefit**: Centralized design governance via `DesignConfig`.
- **Tradeoff**: Removes `const` optimization for some widgets that now depend on context.
