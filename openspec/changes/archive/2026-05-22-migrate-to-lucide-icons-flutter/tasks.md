## 1. Setup & Dependencies

- [x] 1.1 Update `packages/core/pubspec.yaml` to replace `lucide_icons` with `lucide_icons_flutter: ^3.1.14+1` (or latest).
- [x] 1.2 Check all other `pubspec.yaml` files in the monorepo and update them if they depend on `lucide_icons` directly.
- [x] 1.3 Run `flutter pub get` in the affected packages to download the new dependency.

## 2. Refactoring Imports

- [x] 2.1 Perform a workspace-wide search and replace for `import 'package:lucide_icons/lucide_icons.dart';` and replace it with `import 'package:lucide_icons_flutter/lucide_icons.dart';`.

## 3. Verification & Fixes

- [x] 3.1 Run `flutter analyze` across the monorepo to identify any undefined icon names resulting from renamed or removed icons between versions.
- [x] 3.2 Fix any undefined icon errors by mapping deprecated icon names to their new equivalents in `lucide_icons_flutter`.
- [x] 3.3 Ensure the application builds successfully without icon-related compile errors.
