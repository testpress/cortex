## ADDED Requirements

### Requirement: Centralized Client Automation Utilities
The system SHALL provide a centralized Dart library (`client_utils.dart`) that handles API requests, JSON parsing, file downloading, and Git restoration.

#### Scenario: Fetching remote client configuration
- **WHEN** the automation script executes
- **THEN** it fetches the remote config from the specified API_BASE_URL and parses the `InstituteSettings`

#### Scenario: Restoring workspace state
- **WHEN** the script completes or encounters an error
- **THEN** it executes `git checkout .` to discard native target modifications

### Requirement: Interactive Client Runner
The system SHALL provide an interactive `run_client.dart` wrapper script to execute `flutter run` with injected client assets.

#### Scenario: Running the app
- **WHEN** a developer executes `dart app/scripts/run_client.dart --url=<base_url>`
- **THEN** the script downloads the remote logo, injects it into local assets, and launches the app using `flutter run`

### Requirement: Client APK Generator
The system SHALL provide a `generate_client_app.dart` script to automate production APK builds.

#### Scenario: Building the APK
- **WHEN** a developer executes `dart app/scripts/generate_client_app.dart --url=<base_url>`
- **THEN** the script performs asset injection, renames the Android package, and invokes `flutter build apk`
