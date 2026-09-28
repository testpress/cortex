# Cortex

A Flutter monorepo designed from first principles as a platform-neutral SDK with a reference implementation app.

## Architecture

```
cortex/
├── app/                    # Reference implementation (Cortex app)
└── packages/
    ├── ai_assistant/      # AI-powered learning companion
    ├── core/              # Design system primitives & cross-cutting configs
    ├── courses/           # Courses SDK module (includes Explore & Info)
    ├── exams/             # Exams SDK module
    ├── discussions/             # Community & discussion module
    ├── profile/           # User profile & identity module
    └── testpress/         # PUBLIC SDK aggregator
```

## Philosophy

- **Canvas-first rendering**: Flutter as a rendering engine, not a widget library
- **Platform neutrality**: Identical behavior on iOS and Android
- **SDK-first design**: Clean public API via `package:testpress`
- **White-label ready**: No platform-specific visual bias

## Documentation

- **[Architecture & Developer Guide](docs/architecture-overview.md)**: System design, monorepo package boundaries, offline-first Drift/Dio pattern, Riverpod state management, GoRouter, and UI guidelines.
- **[Data Flow & Runtime Concepts](docs/data-flow-and-concepts.md)**: Deep dive into Riverpod dependency injection, memoization, scoped singletons, Drift reactive streams, and the API-to-UI data pipeline.
- **[Setup Guide](docs/setup.md)**: Local environment setup, dependency installation, and build runner commands.
- **Architecture Decisions & AI Context**: Deep ADRs and LLM behavioral rules live in [`packages/core/docs/`](packages/core/docs/).

## Public API

```dart
import 'package:testpress/testpress.dart';
```

Internal packages (`core`, `courses`, `exams`) are never exposed to consumers.

## Getting Started

For a comprehensive walkthrough on prerequisites, code generation, and configuration, see the **[Setup Guide](docs/setup.md)**.

### Quick Start

```bash
# Install dependencies
flutter pub get

# Install pre-commit hooks
# Mac:
brew install lefthook

# Ubuntu:
curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | sudo -E bash
sudo apt install lefthook

lefthook install

# Run reference app (requires API_BASE_URL)
cd app
flutter run --dart-define=API_BASE_URL=https://lmsdemo.testpress.in/
```
