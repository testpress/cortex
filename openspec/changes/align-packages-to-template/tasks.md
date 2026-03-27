## 1. Isolation & Setup

- [x] 1.1 Create temporary isolation directory at `packages/temp/`.
- [x] 1.2 Move existing `packages/profile` package to `packages/temp/profile`.
- [x] 1.3 Move existing `packages/explore` package to `packages/temp/explore`.

## 2. Bootstrapping New Package Shells

- [x] 2.1 Run `flutter create --template=package profile` inside `packages/` to generate a compliant shell.
- [x] 2.2 Run `flutter create --template=package explore` inside `packages/` to generate a compliant shell.

## 3. Grafting Content (Profile)

- [x] 3.1 Restore existing library code: Replace `packages/profile/lib/` with `packages/temp/profile/lib/`.
- [x] 3.2 Restore existing test suite: Move `packages/temp/profile/test/` content to `packages/profile/test/`.
- [x] 3.3 Merge pubspec metadata: Port dependencies and environment from `packages/temp/profile/pubspec.yaml` to the new `packages/profile/pubspec.yaml`.

## 4. Grafting Content (Explore)

- [x] 4.1 Restore existing library code: Replace `packages/explore/lib/` with `packages/temp/explore/lib/`.
- [x] 4.2 Initialize standard layers: Create `lib/data/`, `lib/models/`, and `lib/repositories/` stubs in `packages/explore/`.
- [x] 4.3 Merge pubspec metadata: Port dependencies and environment from `packages/temp/explore/pubspec.yaml` to the new `packages/explore/pubspec.yaml`.

## 5. Metadata Finalization & Cleanup

- [x] 5.1 Run `flutter pub get` in both migrated packages to resolve dependencies.
- [x] 5.2 Verify standardized files: Confirm `analysis_options.yaml`, `README.md`, `LICENSE`, and `CHANGELOG.md` are present.
- [x] 5.3 Final Cleanup: Remove the `packages/temp/` isolation directory.
- [x] 5.4 Check build state: Run `build_runner` if any generated files need updating.
