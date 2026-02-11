# Cortex

A Flutter monorepo designed from first principles as a platform-neutral SDK with a reference implementation app.

## Architecture

```
cortex/
├── app/                    # Reference implementation (Cortex app)
└── packages/
    ├── core/              # Design system primitives
    ├── courses/           # Courses SDK module
    ├── exams/             # Exams SDK module
    └── testpress/         # PUBLIC SDK aggregator
```

## Philosophy

- **Canvas-first rendering**: Flutter as a rendering engine, not a widget library
- **Platform neutrality**: Identical behavior on iOS and Android
- **SDK-first design**: Clean public API via `package:testpress`
- **White-label ready**: No platform-specific visual bias

## Public API

```dart
import 'package:testpress/course_list.dart';
```

Internal packages (`core`, `courses`, `exams`) are never exposed to consumers.

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run reference app
cd app
flutter run
```
