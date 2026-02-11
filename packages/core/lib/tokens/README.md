# Design Token Architecture

# Token Philosophy
In the Cortex monorepo, design tokens (colors, spacing, typography, motion, radius) are **not static globals**. We have explicitly rejected the pattern of using `static const` variables at the global level because they prevent runtime adaptability and tenant-specific overrides.

Instead, tokens are treated as **runtime configurations** that describe the visual intent of the system without being tied to a specific hardcoded value.

# Runtime Injection Model
Tokens are injected into the widget tree via the `DesignProvider`. This architecture allows us to:
- **Swap Themes**: Change the entire visual identity by providing a new `DesignConfig`.
- **Personalize UI**: Adjust tokens based on user preferences or cognitive load.
- **Support White-Labeling**: Allow different consumer applications to inject their own branding into identical SDK modules.

Access to tokens is strictly enforced through `Design.of(context)`. This ensures that every widget in the system is dynamic and reactive to design changes.

# Why Platform Themes Were Rejected
We do not use Flutter's `ThemeData` (Material) or `CupertinoThemeData`. These systems are:
1. **Polluted**: Packed with hundreds of properties specific to Material/Cupertino visuals.
2. **Restrictive**: They enforce specific interaction patterns (like ripples or shadows) that violate our Neutral UI philosophy.
3. **Complex**: The internal logic for how colors are derived (e.g. `ColorScheme.onPrimary`) is often opaque and difficult to override for custom branding.

Our token system is **First-Principles Neutral**. We define only what we need, ensuring complete control over the visual stack.

# Anti-Patterns
- **No Static Access**: Do not use `AppColors.primary` in widget builds. It will break when we introduce multi-tenant runtime switching.
- **No Hardcoded Values**: Do not use `Color(0xFF...)` or `16.0` directly in layouts. Map them to the appropriate token in `DesignConfig`.
- **No Theme Overrides**: Do not use `Theme.of(context)`. Our source of truth is `Design.of(context)`.

# Future Adaptability
The token system is designed to be the foundation for **AI-adaptive UX**. Future iterations will allow machine learning models to adjust spacing for motor-impaired users or optimize typography for different screen distributions, all without changing a single line of feature code.
