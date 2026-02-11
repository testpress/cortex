# Motion Accessibility Layer

# Purpose
In a first-principles UI, animations are a core part of the user experience. However, motion can cause significant issues for users with vestibular disorders. This layer ensures that all animations in the Cortex SDK are governed by user accessibility preferences and architectural constraints.

# Why Motion Is Separate From Design Tokens
Design tokens in `DesignConfig` represent the "What" (durations, curves). The **Motion** layer represents the "Whether" and "How". By separating them, we allow the system to dynamically override animation behavior based on system settings (`Reduce Motion`) or AI-adaptive UX requirements without modifying the static design configuration.

# Architectural Decisions

### MotionPreferences Governance
Instead of directly querying `MediaQuery.of(context).disableAnimations`, all widgets MUST use the `MotionPreferences` API. This centralizes the decision-making logic:
- Returns `Duration.zero` if animations are disabled.
- Returns `Curves.linear` (or instant jump) if motion is reduced.
- Provides a hook for future AI-adaptive UX to slow down animations for onboarding or speed them up for power users.

### Reduce Motion Support
The platform respects the system-level `Reduce Motion` setting. When enabled:
- Parallax effects are disabled.
- Scaling transitions are replaced by simple fades.
- Spring-based physics are dampened to prevent excessive bounce.

# Navigation Integration Rules
Standard page transitions in `AppRoute` automatically inherit motion preferences. When implementing custom shared-element transitions or overlay animations:
1. Always query `MotionPreferences.shouldAnimate(context)`.
2. Use durations from the current `DesignContext`.
3. Provide an instant-completion fallback for users with reduced motion preferences.

# Future AI-Adaptive UX
This layer is designed to be the insertion point for machine-learning driven UX adjustments. The architecture supports:
- **Dynamic Pacing**: Adjusting animation speeds based on user cognitive load.
- **Predictive Pre-fetching**: Starting animations before a user completes a gesture.
- **Motion Profiles**: Selecting different easing curves based on user proficiency.
