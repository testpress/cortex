# Navigation Infrastructure

# Neutral Navigation Model
Cortex uses a platform-neutral navigation model that explicitly avoids Material (`MaterialPageRoute`) and Cupertino (`CupertinoPageRoute`) routing. We use a custom **AppRoute** implementation built on top of Flutter's `PageRouteBuilder`.

This ensures that page transitions are:
1. **Consistent**: Identical look and feel regardless of the underlying OS.
2. **Deterministic**: No "hidden" platform behaviors like swipe-to-back on iOS that we don't explicitly manage.
3. **Flexible**: Easy to integrate with custom motion and accessibility prefers.

# Motion Integration Rules
Navigation transitions are governed by the **Motion Accessibility Layer**. 
- **Durations**: Standard transitions default to `DesignMotion.normal` (250ms).
- **Curves**: Default easing uses `DesignMotion.easeOut` for enter transitions.
- **Accessibility**: Transitions automatically respect `MotionPreferences.shouldAnimate(context)`. If animations are disabled at the system level, transitions complete instantly to prevent vestibular discomfort.

# Accessibility Considerations
Screen reader users must be notified of route changes. Our navigation model ensures:
- **Focus Management**: Focus is automatically reset to the screen header or root landmark upon navigation.
- **Landmark Exposure**: Every screen pushed via `AppRoute` is expected to have an `AppHeader` to announce its title to assistive technologies.
- **Announcements**: Dynamic route changes are announced via system accessibility channels where appropriate.

# Future Deep-Link Support
The `AppRoute` is architected to support future **Deep-Linking** and **Declarative Routing** (Router API). By abstracting the `PageRoute` into our own infrastructure, we can easily swap the underlying routing engine while maintaining our visual and accessibility contracts.

# Anti-Patterns
- **No MaterialPageRoute**: Never use `MaterialPageRoute`. It introduces the platform-specific "zoom" or "slide" animations that violate our neutral UI contract.
- **No CupertinoPageRoute**: Never use `CupertinoPageRoute`. It introduces platform-specific swipe-back behaviors that may conflict with our focus management strategy.
- **No Hardcoded Durations**: Always source transition timings from the `DesignContext`.
