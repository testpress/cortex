# AI Context — Rules for Future Antigravity Sessions

## Critical Constraints

### 1. Neutral UI Only
- ❌ **NEVER** use Material widgets: `Scaffold`, `AppBar`, `ElevatedButton`, `Card`, `ListTile`
- ❌ **NEVER** use Cupertino widgets: `CupertinoNavigationBar`, `CupertinoButton`
- ✅ **ALWAYS** use core primitives: `AppText`, `AppButton`, `AppCard`, `AppHeader`, `AppScroll`

### 2. Design Tokens from Context
- ❌ **NEVER** import static tokens: `import '../tokens/colors.dart'`
- ✅ **ALWAYS** use Design context: `Design.of(context).colors.primary`

### 3. Accessibility Mandatory
- ✅ **ALWAYS** wrap interactive widgets with `AppSemantics.button`, `AppSemantics.header`, etc.
- ✅ **ALWAYS** use `MotionPreferences.shouldAnimate(context)` before animating
- ✅ **ALWAYS** ensure 48dp minimum touch targets (WCAG 2.5.5)

### 4. SDK Boundaries
- ❌ **NEVER** let `app/` import `package:core` or `package:courses` directly
- ✅ **ALWAYS** ensure `app/` imports ONLY `package:testpress`
- ✅ Internal packages (`core`, `courses`, `exams`) can import `package:core/core.dart`

### 5. No Platform-Specific Visuals
- ❌ **NEVER** add platform checks for visual behavior: `if (Platform.isIOS)`
- ✅ **ALWAYS** ensure identical rendering on iOS and Android
- ✅ Use `MediaQuery` only for accessibility (font scaling, animations)

## Design System Rules

### DesignProvider
Wrap app root with `DesignProvider`:

```dart
DesignProvider(
  config: DesignConfig.defaults(),
  child: YourApp(),
)
```

### Token Access
Read tokens from context:

```dart
final design = Design.of(context);

// Colors
design.colors.primary
design.colors.textPrimary

// Spacing
design.spacing.md
design.spacing.screenPadding

// Typography
design.typography.headline
design.typography.body

// Motion
design.motion.easeOut
design.motion.shouldAnimate

// Radius
design.radius.card
design.radius.button
```

### Smart Colors
For hot reload testing, use `DesignColors.smart()`:

```dart
DesignColors.smart(
  primary: Color(0xFF00FF00), // Auto-calculates contrasting text
)
```

## Widget Patterns

### Text
```dart
AppText.headline('Title')
AppText.body('Content')
AppText.caption('Metadata', color: design.colors.textSecondary)
```

### Buttons
```dart
AppButton.primary(
  label: 'Submit',
  onPressed: handleSubmit,
)

AppButton.secondary(
  label: 'Cancel',
  onPressed: handleCancel,
)
```

### Cards
```dart
AppCard(
  child: Column(children: [...]),
)
```

### Headers
```dart
AppHeader(
  title: 'Screen Title',
  subtitle: 'Optional subtitle',
  actions: [IconButton(...)],
)
```

### Scrollable Content
```dart
AppScroll(
  children: [
    AppText.headline('Section'),
    AppCard(...),
  ],
)
```

## Accessibility Patterns

### Interactive Widgets
```dart
AppSemantics.button(
  label: 'Submit form',
  onTap: handleSubmit,
  enabled: !isLoading,
  child: buttonWidget,
)
```

### Headers
```dart
AppSemantics.header(
  label: 'Course List',
  child: AppText.headline('Courses'),
)
```

### Progress Indicators
```dart
AppSemantics.progressValue(
  value: 0.75,
  label: 'Course progress',
  child: progressBar,
)
```

## Motion Rules

### Check Before Animating
```dart
if (MotionPreferences.shouldAnimate(context)) {
  // Animate
} else {
  // Skip animation
}
```

### Use Design Context Curves
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: design.motion.easeOut,
  // ...
)
```

## Navigation

### Platform-Neutral Routing
```dart
Navigator.of(context).push(
  AppRoute(page: DetailsScreen()),
)
```

## Testing Requirements

### Widget Tests
Always wrap test widgets with `DesignProvider`:

```dart
await tester.pumpWidget(
  DesignProvider(
    config: DesignConfig.defaults(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: YourWidget(),
    ),
  ),
);
```

### Custom Config Testing
```dart
final customConfig = DesignConfig(
  colors: DesignColors.smart(primary: Color(0xFF00FF00)),
  spacing: DesignSpacing.defaults(),
  typography: DesignTypography.defaults(),
  motion: DesignMotion.defaults(),
  radius: DesignRadius.defaults(),
);

await tester.pumpWidget(
  DesignProvider(
    config: customConfig,
    child: YourWidget(),
  ),
);
```

## Commit Rules

Follow conventional commits:

```
feat(core): add new primitive widget
refactor(courses): migrate to Design context
test(core): add regression tests for DesignProvider
docs(repo): update architecture decisions
```

Commit body MUST explain WHY, not just WHAT.

## Architecture Decision Records

When making significant architectural changes, create an ADR in `docs/decisions/`:

```
NNNN-short-title.md

# Context
Why the problem existed.

# Decision
What architectural choice was made.

# Consequences
Tradeoffs and future implications.
```

## Key Reminders

1. **Flutter is a rendering engine, not a widget library**
2. **Design tokens come from runtime context, not static imports**
3. **Accessibility is mandatory, not optional**
4. **SDK boundaries are enforced via import rules**
5. **Platform neutrality is non-negotiable**
