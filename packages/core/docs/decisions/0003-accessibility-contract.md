# ADR 0003: Accessibility Contract

# Context
Accessibility is often an afterthought in mobile development. For a neutral UI system built from scratch, we lose the built-in semantics provided by Material/Cupertino widgets. Without a strict contract, the SDK would become inaccessible to users relying on assistive technologies.

# Decision
We implemented a mandatory accessibility layer. All interactive components must be wrapped in `AppSemantics` helpers. Motion must respect system-level animation preferences via `MotionPreferences`. Regression tests must validate the semantic tree.

# Consequences
- **Requirement**: Developers must consider semantics for every new UI primitive.
- **Benefit**: WCAG 2.1 AA compliance is built-in by default.
- **Benefit**: Improved testability through semantic labels.
- **Requirement**: CI/CD must run accessibility-specific regression tests.
