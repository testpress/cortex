# Architecture Overview

## System Design

Cortex is a **Flutter monorepo** architected as a platform-neutral SDK with a reference implementation app.

### Core Principles

1. **Flutter as Rendering Engine**  
   Flutter is used for canvas rendering, not as a widget library. No Material or Cupertino visual widgets are used.

2. **First-Principles UI**  
   All primitives are built from `Container`, `GestureDetector`, `CustomPaint`, and `Text`. This ensures identical behavior across iOS and Android without platform-specific visual bias.

3. **Runtime Design Governance**  
   `DesignProvider` injects design tokens via `InheritedWidget`. Widgets read from `Design.of(context)` instead of static imports, enabling white-label branding and AI-adaptive UX.

4. **SDK-First Monorepo**  
   The app is a reference implementation only. Public API is exposed via `package:testpress`, which re-exports from internal modules (`core`, `courses`, `exams`).

## Package Structure

```
packages/
├── core/              # Design system runtime
│   ├── design/        # DesignProvider, DesignConfig, DesignContext
│   ├── widgets/       # Neutral primitives (AppText, AppButton, etc.)
│   ├── accessibility/ # Semantic helpers (AppSemantics)
│   ├── motion/        # Animation layer (MotionPreferences)
│   ├── navigation/    # Platform-neutral routing (AppRoute)
│   └── shell/         # App container (AppShell)
│
├── courses/           # LMS course module SDK
│   ├── models/        # Course data models
│   └── widgets/       # Course-specific widgets (CourseCard)
│
├── exams/             # Exam engine SDK module (placeholder)
│
└── testpress/         # PUBLIC SDK aggregator
    └── course_list.dart  # Re-exports public APIs
```

## Design System

### Token Groups

| Group | Count | Examples |
|-------|-------|----------|
| Colors | 22 | primary, surface, success, error, textPrimary |
| Spacing | 11 | xs (4), md (16), xl (32), screenPadding (24) |
| Typography | 9 | display, headline, title, body, label, caption |
| Motion | 10 | fast (150ms), normal (250ms), easeOut, spring |
| Radius | 11 | sm (4), md (8), card, button, pill |

### Runtime Injection

```dart
// App root
DesignProvider(
  config: DesignConfig.defaults(),
  child: CortexApp(),
)

// Widget usage
final design = Design.of(context);
Container(
  color: design.colors.primary,
  padding: EdgeInsets.all(design.spacing.md),
)
```

### Smart Colors

`DesignColors.smart()` automatically calculates WCAG AA-compliant text colors based on background luminance:

```dart
DesignColors.smart(
  primary: Color(0xFF00FF00), // Green
  // onPrimary is auto-calculated as dark gray for contrast
)
```

## Accessibility

### Mandatory Semantic Helpers

All interactive widgets MUST use `AppSemantics`:

```dart
AppSemantics.button(
  label: 'Submit',
  onTap: handleSubmit,
  enabled: true,
  child: buttonWidget,
)
```

### Motion Preferences

Respects `MediaQuery.disableAnimations`:

```dart
MotionPreferences.shouldAnimate(context)  // false if animations disabled
MotionPreferences.duration(context, d)     // Duration.zero if disabled
MotionPreferences.curve(context, c)        // Curves.linear if disabled
```

## SDK Boundaries

### Import Rules

| Package | Can Import |
|---------|-----------|
| `core` | Flutter SDK only |
| `courses` | `package:core/core.dart` |
| `exams` | `package:core/core.dart` |
| `testpress` | `core`, `courses`, `exams` |
| `app` | `package:testpress` ONLY |

### Public API

Only `package:testpress` is exposed to consumers:

```dart
// ✅ Correct
import 'package:testpress/course_list.dart';

// ❌ Never expose internal packages
import 'package:core/core.dart';      // Internal only
import 'package:courses/courses.dart'; // Internal only
```

## Navigation

### AppRoute

Platform-neutral page route with consistent transitions:

```dart
Navigator.of(context).push(
  AppRoute(page: DetailsScreen()),
)
```

Transition duration: 250ms (hardcoded to match `AppMotion.normal` default)  
Transition curve: `design.motion.easeOut`

## Testing Strategy

### Unit Tests
- Token sourcing from Design context
- Semantic helper behavior
- Motion preference overrides

### Widget Tests
- Primitive rendering with custom DesignConfig
- Accessibility tree validation
- Hot reload behavior

### Regression Tests
- DesignProvider injection
- Missing provider assertion
- Config update propagation

## Future Work

1. **Deprecate static tokens** - Add `@Deprecated` to `AppColors`, `AppSpacing`, etc.
2. **Dynamic theming** - Runtime theme switching via `Builder` widget
3. **White-label branding** - Custom `DesignConfig` per tenant
4. **AI-adaptive UX** - Adjust design tokens based on user context
5. **Design token validation** - Runtime WCAG contrast checks
