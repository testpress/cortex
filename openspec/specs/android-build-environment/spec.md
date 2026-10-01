# android-build-environment Specification

## Purpose
Make Android development reproducible by declaring the supported build JDK, providing setup, and reporting incompatible environments before Gradle starts.

## Requirements

### Requirement: Supported Android build JDK
The repository SHALL declare Java 21 as the Android build JDK and use that declaration for Android build CI.

#### Scenario: CI environment
- **WHEN** an Android build job starts
- **THEN** it installs the declared JDK and configures Flutter to use it

### Requirement: Local environment setup
A documented macOS/Linux setup command SHALL locate an installed Java 21 JDK, configure Flutter to use it, and fetch application dependencies. It MUST report installation instructions without configuring Flutter when a matching JDK is unavailable. An explicit JDK path MUST be validated before configuration. It MUST disclose that Flutter's JDK setting affects other Flutter projects.

#### Scenario: Supported JDK available
- **WHEN** setup finds Java 21 even though the default Java is newer
- **THEN** it configures Flutter with the Java 21 path and fetches dependencies

#### Scenario: Supported JDK missing
- **WHEN** setup cannot find Java 21
- **THEN** it exits unsuccessfully with installation and retry instructions
- **AND** it does not change Flutter configuration

#### Scenario: Explicit unsupported JDK
- **WHEN** a developer supplies a JDK path with an unsupported version
- **THEN** setup rejects it and does not change Flutter configuration

### Requirement: Early actionable build validation
The Unix and Windows Gradle launchers SHALL validate the selected launcher Java against the declared major version before starting Gradle. Unsupported or unreadable versions MUST exit unsuccessfully and show the expected version, selected Java path, and repair instructions. This check covers launcher Java; documentation MUST warn that daemon JVM overrides also need to match.

#### Scenario: Unsupported Java selected by Flutter
- **WHEN** Flutter launches the wrapper with Java 25 or 26
- **THEN** it reports the declared Java version and setup instructions before running Gradle

#### Scenario: Supported Java selected
- **WHEN** the launcher uses Java 21
- **THEN** it forwards the original arguments to Gradle

### Requirement: First-run instructions
Root and app documentation SHALL show dependency commands in the correct package directory, the JDK setup step, and the required API URL define. Windows setup SHALL include an explicit Flutter JDK configuration command.

#### Scenario: Fresh checkout
- **WHEN** a developer follows the documented quick start
- **THEN** they configure the supported JDK before launching the reference app
