# Cortex Setup Guide

This guide walks you through setting up your local development environment for the Cortex Flutter monorepo.

---

## 1. Prerequisites

Ensure you have the following installed on your machine:

- **Flutter SDK**: Recommended Flutter `3.44.x` (or newer stable Flutter 3). Check with `flutter --version`.
- **Java JDK**: Java `21`, declared in `.java-version`, for Android builds. A newer default system Java can coexist with it.
- **Dart SDK**: Included with your Flutter installation.
- **Git**: For version control.
- **Lefthook**: Fast git git hooks manager for formatting and lint checks.
- **Platform Toolchains**:
  - Android: Android Studio / Android SDK and command-line tools.
  - iOS (macOS only): Xcode and CocoaPods (`sudo gem install cocoapods` or `brew install cocoapods`).

---

### First-run Android setup

From the repository root on macOS/Linux:

```bash
bash tool/setup.sh
```

This finds an installed Java 21 JDK, configures Flutter to use it, and runs
`flutter pub get` in `app/`. It checks `JAVA_HOME`, macOS registered JDKs and
Homebrew locations, standard Linux JDK locations, and the Java on `PATH`.
For a custom installation, pass the JDK home (the directory containing `bin/java`
and `bin/javac`):

```bash
bash tool/setup.sh "/path/to/jdk-21"
```

If no Java 21 JDK is found, setup exits with installation instructions. On macOS:

```bash
brew install openjdk@21
bash tool/setup.sh
```

On Linux or Windows, install a Java 21 JDK such as
[Eclipse Temurin](https://adoptium.net/temurin/releases/?version=21).
On Windows, configure Flutter explicitly, then fetch dependencies:

```powershell
flutter config --jdk-dir="C:\path\to\jdk-21"
cd app
flutter pub get
```

**Flutter's JDK configuration is machine-wide**, including IDE launches and other
Flutter projects. Changing `java` on the shell PATH alone might not change the JDK
Flutter selects. To return to Flutter's automatic selection later:

```bash
flutter config --jdk-dir=""
```

If running `app/android/gradlew` directly, also set `JAVA_HOME` to the Java 21 JDK.
On macOS with a registered JDK:

```bash
export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
```

Both Gradle launchers validate their selected Java before starting Gradle. When
updating/regenerating wrappers, preserve the Cortex JDK validation blocks.
A custom `org.gradle.java.home` in project or user `gradle.properties`, a daemon
JVM criteria file, or a command-line JVM override can select a different daemon
JDK; remove such overrides or align them with Java 21.

Android Studio users should also set the project's **Gradle JDK** to Java 21 under
Settings → Build, Execution, Deployment → Build Tools → Gradle.

Install Android SDK Command-line Tools through Android Studio's SDK Manager, then
run `flutter doctor --android-licenses` and `flutter doctor -v`. Start an emulator
or connect a device before launching the app.

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

After completing the first-run setup above, navigate to `app/` and pass the required `--dart-define` flags:

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

### Android setup regression checks

```bash
python3 tool/test_android_environment.py
```

These checks use stub Java and Flutter executables to verify early version
rejection, argument forwarding, JDK discovery, and setup failures without changing
your Flutter configuration. Android build CI runs the same checks.
