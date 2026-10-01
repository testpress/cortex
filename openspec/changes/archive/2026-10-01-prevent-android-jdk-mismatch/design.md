# Design

## Context
See proposal.md for motivation. Flutter chooses Java independently of the shell PATH and passes JAVA_HOME to Gradle. Existing Android CI uses Java 17; Gradle 8.14 can run on Java 21. The existing wrappers execute Java before any Kotlin build script can validate its version.

## Goals / Non-Goals
**Goals:** Use one major-version declaration across setup, launchers, and Android CI; fail before Gradle initializes; preserve IDE launches after setup.
**Non-Goals:** Upgrade Gradle/AGP, change Android bytecode targets, install system packages automatically, or change SDK/application behavior.

## Decisions
- Store `21` in `.java-version`. This interoperates with Java version managers and setup-java's java-version-file. Pin the major version rather than a vendor patch so security updates remain available.
- Add `tool/setup.sh` with an optional explicit JDK home. Search JAVA_HOME, macOS java_home, standard Linux JDK locations, then PATH; validate both java and javac before configuring Flutter. Missing Java prints vendor-neutral instructions and a macOS Homebrew option. Do not install packages silently.
- Configure `flutter config --jdk-dir` during setup. JAVA_HOME alone does not reliably override Flutter's Android Studio choice. Disclose the machine-wide setting. Avoid checking machine-specific paths into Gradle properties.
- Track both launchers by removing their Android Git ignore entries; Flutter fills in the missing wrapper JAR without overwriting existing launchers. Add small checks in both Gradle launchers, after Java resolution and before the wrapper main class. Kotlin settings validation is too late for the observed version parser failure. Preserve argument handling and Windows line endings. Existing daemon Java overrides remain a documented limitation.
- Android CI reads `.java-version` and explicitly sets Flutter's JDK path. Run focused Unix launcher/setup regression checks in CI with stub executables; native Windows execution remains unavailable locally.

## Risks / Trade-offs
- Flutter configuration is global → disclose it in setup output and docs, and give a reset command.
- Wrapper regeneration removes custom checks → document preserving checks during wrapper updates.
- Windows launcher cannot be exercised on this macOS host → review batch syntax and report the validation limit.
- Existing daemon JVM overrides can bypass launcher choice → document removing or aligning user/project overrides.

## Migration Plan
Run setup once after checkout, then use ordinary Flutter or IDE commands. Align Android CI at the same time. Roll back by reverting tooling/configuration changes and resetting Flutter's JDK setting.
