# Neutral App Shell

# Layout Root Philosophy
The **AppShell** is the architectural root of the layout tree. In a first-principles monorepo, we avoid the standard Flutter `Scaffold` because it is heavily biased toward Material Design (fixed-height app bars, bottom navigation bars with specific elevation/ripple behaviors).

The `AppShell` provides a clean, platform-neutral canvas that ensures:
1. **Background Consistency**: Surfaces read from `Design.of(context).colors.surface`.
2. **Platform Insets**: Proper handling of `SafeArea` and system-level padding without OS visual leakage.
3. **Hierarchy Clarity**: Acts as the semantic landmark for the screen content.

# Why Scaffold Is Avoided
- **Visual Coupling**: `Scaffold` includes built-in styling for drawers, snackbars, and floating action buttons that do not align with our Neutral UI visuals.
- **Elevation Bias**: Material's elevation system (shadows based on z-index) is tightly coupled to `Scaffold` internals. We use our own flat design system.
- **Rebuild Overhead**: `Scaffold` contains complex internal state for things we don't use (drawer animations, keyboard resizing logic).

# Layout Chrome Centralization
By using a custom `AppShell`, we centralize the "Chrome" of the application. This ensures that:
- Status bar transparency is managed identically on iOS and Android.
- Navigation landmarks (like the `AppHeader`) are integrated into the core layout lifecycle.
- Bottom safe areas are handled correctly even on devices with non-standard cutouts (pill bars, notches).

# Integration
Every significant screen in the system should start with an `AppShell`. This establishes the visual and semantic context required for all child primitives to function correctly.

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShell(
      child: AppScroll(
        children: [...],
      ),
    );
  }
}
```

# Anti-Patterns
- **No Scaffold**: Direct usage of `Scaffold` is an architectural violation.
- **No Raw SafeArea**: Avoid using raw `SafeArea` widgets inside feature screens. `AppShell` already handles the root insets.
- **No Hardcoded Backgrounds**: Always rely on `AppShell` to set the screen background color from design tokens.
