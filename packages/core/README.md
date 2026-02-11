# Core Package

Platform-neutral design system and UI primitives for the Cortex SDK.

## Philosophy

### Neutral UI
No Material or Cupertino visual widgets. Flutter is used as a **rendering engine**, not a widget library. All primitives are built from first principles using `Container`, `GestureDetector`, and `CustomPaint`.

### Runtime Design Governance
The `DesignProvider` injects design tokens at runtime via `InheritedWidget`. All widgets read from `Design.of(context)` instead of static imports, enabling white-label branding and AI-adaptive UX without breaking SDK contracts.

### Accessibility-First
Every interactive widget uses semantic helpers (`AppSemantics.button`, `AppSemantics.header`, etc.). Motion respects `MediaQuery.disableAnimations`. WCAG 2.1 AA compliance is mandatory.

## Architecture

```
core/
├── design/              # Runtime design system
│   ├── design_config.dart
│   ├── design_context.dart
│   └── design_provider.dart
├── widgets/             # Neutral primitives
│   ├── app_text.dart
│   ├── app_button.dart
│   ├── app_card.dart
│   ├── app_header.dart
│   └── app_scroll.dart
├── accessibility/       # Semantic helpers
├── motion/              # Animation layer
├── navigation/          # Platform-neutral routing
└── shell/               # App container
```

## Design System

### DesignProvider
Wrap your app root with `DesignProvider` to inject design tokens:

```dart
DesignProvider(
  config: DesignConfig.defaults(),
  child: YourApp(),
)
```

### Design Tokens
All widgets source tokens from context:

```dart
final design = Design.of(context);

Container(
  color: design.colors.primary,
  padding: EdgeInsets.all(design.spacing.md),
  decoration: BoxDecoration(
    borderRadius: design.radius.card,
  ),
)
```

### Token Groups
- **Colors**: 22 semantic colors (primary, surface, success, error, text, etc.)
- **Spacing**: 11 values (xs → xxxl, semantic use cases)
- **Typography**: 9 text styles (display, headline, title, body, label, caption)
- **Motion**: 5 durations + 5 curves + accessibility flag
- **Radius**: 7 values + 4 semantic BorderRadius constants

## Primitives

### AppText
Semantic text widget with typography variants:

```dart
AppText.headline('Title')
AppText.body('Content')
AppText.caption('Metadata')
```

### AppButton
Platform-neutral button with primary/secondary variants:

```dart
AppButton.primary(
  label: 'Submit',
  onPressed: () {},
)
```

### AppCard
Consistent card container:

```dart
AppCard(
  child: Column(children: [...]),
)
```

## Accessibility

### Semantic Helpers
Mandatory for all interactive widgets:

```dart
AppSemantics.button(
  label: 'Submit',
  onTap: handleSubmit,
  child: buttonWidget,
)
```

### Motion Preferences
Respects user animation preferences:

```dart
if (MotionPreferences.shouldAnimate(context)) {
  // Animate
}
```

## SDK Contract

**Core acts as the design runtime for all SDK modules.**

- `courses` and `exams` import `package:core/core.dart`
- `testpress` re-exports public APIs
- `app` imports ONLY `package:testpress`

This ensures clean SDK boundaries and prevents internal leakage.

## Documentation

**Architecture decisions and AI context:** [`docs/`](docs/)

- [`architecture.md`](docs/architecture.md) - High-level system design
- [`ai_context.md`](docs/ai_context.md) - Rules for future Antigravity sessions
- [`decisions/`](docs/decisions/) - Architecture Decision Records (ADRs)
