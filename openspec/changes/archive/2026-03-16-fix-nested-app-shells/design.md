# Design: Nested Content Layout

## Architectural Decision: Content Delegation
Sub-pages (leaves of the navigation tree) MUST NOT initialize their own `AppShell`. 

### Layout Pattern
Instead of:
```dart
AppShell(
  child: Content(),
)
```

Use:
```dart
Container(
  color: design.colors.canvas,
  child: Content(),
)
```

### Rationale
1. **Single Source of Truth**: The global shell manages deep-linking, safe areas, and background navigation state.
2. **Padding Consistency**: Prevents additive padding when a sub-page with a `SafeArea` is placed inside a shell that already provides a `SafeArea`.
3. **Performance**: Reduces widget depth and redundant layout passes.
