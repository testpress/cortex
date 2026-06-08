## 1. GitHub Actions Setup

- [x] 1.1 Create directory `.github/workflows` in the repository root.
- [x] 1.2 Create `test.yaml` workflow file that triggers on pull requests and pushes to `main`.
- [x] 1.3 Add parallel jobs (`format`, `analyze`, `test`, `build`) with `ubuntu-latest`.

## 2. CI Job Steps

- [x] 2.1 Add checkout and flutter-action setup to each job pinned exactly to Flutter `3.41.1`.
- [x] 2.2 Add bash loops to fetch dependencies (`flutter pub get`) across the monorepo in the necessary jobs.
- [x] 2.3 Add `dart format` to the format job.
- [x] 2.4 Add `flutter analyze` to the analyze job.
- [x] 2.5 Add a bash loop for `flutter test` across all packages in the test job.
- [x] 2.6 Add `flutter build apk --debug` in the app directory for the build job.
