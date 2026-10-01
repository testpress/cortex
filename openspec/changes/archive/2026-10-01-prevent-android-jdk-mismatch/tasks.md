# Tasks

## 1. Setup and validation
- [x] 1.1 Declare Java 21, add setup discovery and both launcher guards; verify supported, unsupported, missing and explicit-path cases with focused regression checks.
- [x] 1.2 Update root, app and setup documentation with first-run commands and global-setting/daemon-override limitations; verify commands against actual tooling.

## 2. CI alignment
- [x] 2.1 Configure all Android build jobs from the JDK declaration and explicitly configure Flutter; inspect workflows and run tooling checks locally and in CI configuration.

## 3. Integration
- [x] 3.1 Run setup on this machine and verify Gradle initializes with Java 21; report any independent Android SDK failures and Windows validation limits.
- [x] 3.2 Validate the completed OpenSpec change and archive with the new capability synced.

## Validation results
- Eight focused setup/Unix launcher regression checks pass.
- Shell syntax and Git whitespace checks pass.
- Setup selected the installed JBR 21.0.11 and fetched application dependencies.
- Gradle 8.14 reports Java 21 for launcher and daemon. A real Java 26 invocation is rejected with repair instructions.
- Full Flutter debug APK build succeeded with the API URL define.
- Windows launcher syntax was reviewed; native Windows execution is unverified on this macOS host.
