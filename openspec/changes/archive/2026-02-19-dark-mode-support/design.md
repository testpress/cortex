# Design: Dark Mode Support

## Context

The current `DesignProvider` is a static wrapper that takes a single `DesignConfig`. To support dark mode automatically, it must become stateful (or respond to context changes) and manage two configurations: light and dark.

## Goals

- Automatic platform-brightness detection at the root.
- Explicit developer override via `DesignMode` enum.
- Zero-cost for developers: new screens "just work" in both modes.

## Decisions

### Decision 1: DesignMode Enum
We'll introduce an enum to govern the theme mode:
```dart
enum DesignMode { system, light, dark }
```

### Decision 2: DesignColors Dark Factory
We will add `DesignColors.dark()` as a curated palette. It will follow the same 22-token structure but with values optimized for dark surfaces.
- Surface: `0xFF111827` (Dark Gray)
- Primary: same brand blue or adjusted for dark contrast.
- Smart contrast: `DesignColors.smart()` will be used to ensure AA compliance.

### Decision 3: DesignProvider Logic
`DesignProvider` will use `PlatformDispatcher` to detect brightness at the root (before `MediaQuery` is available) or use `MediaQuery` if we wrap it.
Actually, `MaterialApp` already uses `MediaQuery`. Since our `DesignProvider` is *above* `MaterialApp` in `main.dart`, we should use `View.of(context).platformDispatcher.platformBrightness` to be safe and reactive.

### Decision 4: API Signature
```dart
class DesignProvider extends StatefulWidget {
  final DesignConfig config;
  final DesignConfig? darkConfig;
  final DesignMode mode;
}
```
If `darkConfig` is null, it falls back to `config` (light mode only).
