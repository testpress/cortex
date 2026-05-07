## 1. Package Refactoring
- [x] 1.1 Rename `packages/forum` to `packages/discussions` directory
- [x] 1.2 Update `pubspec.yaml` in `discussions` package (name: discussions)
- [x] 1.3 Update `discussions.dart` entry point and file exports
- [x] 1.4 Global search and replace `import 'package:forum/` with `import 'package:discussions/`
- [x] 1.5 Update dependencies in `app/pubspec.yaml`, `courses/pubspec.yaml`, and `testpress/pubspec.yaml`
- [x] 1.6 Run `flutter pub get` across all affected packages
