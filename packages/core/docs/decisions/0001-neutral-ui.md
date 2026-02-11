# ADR 0001: Neutral UI Philosophy

# Context
Flutter's default widgets (Material and Cupertino) are tightly coupled to specific platform design languages. For a first-principles SDK intended for white-labeling and cross-platform consistency, using these visual systems introduces unnecessary bias and technical debt when trying to achieve a truly unique, neutral brand identity.

# Decision
We avoid all Material and Cupertino visual widgets. Flutter is utilized strictly as a rendering engine. All UI primitives (AppText, AppButton, AppCard, etc.) are built from low-level widgets like `Container`, `GestureDetector`, and `CustomPaint`. 

# Consequences
- **Tradeoff**: Increased initial development effort to build primitives from scratch.
- **Benefit**: Total control over the visual stack. 
- **Benefit**: Identical rendering across iOS, Android, and Web without platform-specific overrides.
- **Future**: Simplified white-labeling and theme adaptive UI.
