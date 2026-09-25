# Cortex Setup Guide

This guide walks you through setting up your local development environment for the Cortex Flutter monorepo.

---

## 1. Prerequisites

Ensure you have the following installed on your machine:

- **Flutter SDK**: Recommended Flutter `3.44.x` (or newer stable Flutter 3). Check with `flutter --version`.
- **Dart SDK**: Included with your Flutter installation.
- **Git**: For version control.
- **Lefthook**: Fast git git hooks manager for formatting and lint checks.
- **Platform Toolchains**:
  - Android: Android Studio / Android SDK and command-line tools.
  - iOS (macOS only): Xcode and CocoaPods (`sudo gem install cocoapods` or `brew install cocoapods`).

---

## 2. Monorepo Dependency Installation

Cortex is architected as an SDK-first monorepo composed of the reference application (`app/`) and isolated domain/foundation packages (`packages/*`). There is no single `pubspec.yaml` at the root.

### Install All Dependencies Across the Monorepo

Run the following command from the root of the repository to fetch dependencies for `app` and every package in `packages/`:

```bash
for dir in app packages/*; do
  if [ -d "$dir" ] && [ -f "$dir/pubspec.yaml" ]; then
    echo "Fetching dependencies in $dir..."
    (cd "$dir" && flutter pub get)
  fi
done
```

### Install Dependencies for a Specific Package

If you are only working on a specific package or the reference app, navigate to that directory and run:

```bash
# Reference application
cd app && flutter pub get

# Core platform SDK
cd packages/core && flutter pub get

# Domain SDKs
cd packages/courses && flutter pub get
cd packages/exams && flutter pub get
cd packages/discussions && flutter pub get
cd packages/profile && flutter pub get
cd packages/zoom && flutter pub get

# Public SDK aggregator
cd packages/testpress && flutter pub get
```

---

## 3. Pre-Commit Hooks (Lefthook)

Lefthook runs fast parallel checks (formatting and static analysis) before code is committed.

### Install Lefthook

- **macOS (Homebrew):**
  ```bash
  brew install lefthook
  ```
- **Ubuntu / Linux:**
  ```bash
  curl -1sLf 'https://dl.cloudsmith.io/public/evilmartians/lefthook/setup.deb.sh' | sudo -E bash
  sudo apt install lefthook
  ```
- **Via npm (alternative):**
  ```bash
  npm install -g @evilmartians/lefthook
  ```

### Activate Hooks

From the repository root, install the hooks:

```bash
lefthook install
```

---

## 4. Code Generation (build_runner)

Several packages (`core`, `courses`, `exams`, etc.) use code generation for Drift (SQLite database), Riverpod providers, and JSON serialization.

If you modify database tables or generated providers, run code generation within that package:

```bash
cd packages/<package_name>
dart run build_runner build --delete-conflicting-outputs
```

Or watch for changes during development:

```bash
cd packages/<package_name>
dart run build_runner watch --delete-conflicting-outputs
```

---

## 5. Running the Application

### Configuration & Compile-Time Defines

`AppConfig.validate()` runs on application startup and requires a valid `API_BASE_URL`.

To run the reference app, navigate to `app/` and pass the required `--dart-define` flags:

```bash
cd app
flutter run --dart-define=API_BASE_URL=https://your-instance.testpress.in/
```

#### Running with Mock Data

To use local mock fixtures instead of remote network requests:

```bash
cd app
flutter run --dart-define=API_BASE_URL=https://dummy.testpress.in/ --dart-define=USE_MOCK=true
```

---

## 6. Verification & Quality Checks

Run the same checks locally that are executed in CI:

### Code Formatting

Check formatting across all files:

```bash
dart format --output=none --set-exit-if-changed .
```

To automatically format all Dart files:

```bash
dart format .
```

### Static Analysis

```bash
flutter analyze
```

### Running Tests Across All Packages

```bash
for dir in app packages/*; do
  if [ -d "$dir/test" ]; then
    echo "Testing $dir..."
    (cd "$dir" && flutter test)
  fi
done
```
