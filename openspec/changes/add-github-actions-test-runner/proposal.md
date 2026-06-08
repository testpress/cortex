## Why

The Cortex project is a modular Flutter monorepo containing multiple feature packages and an application shell. To ensure high code quality and prevent regressions, we need an automated CI pipeline. We aim for a simple, parallelized CI pipeline using native bash scripts. This will validate formatting, analysis, tests, and build stability simultaneously for developers without creating a CI maintenance burden or requiring external monorepo tools.

## What Changes

- Create a GitHub Actions workflow (`.github/workflows/test.yaml`) that triggers on pull requests and pushes to `main`.
- Pin the CI to use a specific Flutter environment: Flutter `3.41.1`.
- The CI pipeline will execute four parallel jobs:
  1. `format`: Checks code formatting across all files.
  2. `analyze`: Runs static analysis across the monorepo using a bash loop.
  3. `test`: Runs unit tests across all packages using a bash loop.
  4. `build`: Builds a debug APK from the `app` package.

## Capabilities

### New Capabilities
- `github-actions-ci`: Configuration for automated parallel testing and code validation via GitHub Actions.

### Modified Capabilities

## Impact

- Adds new configuration files to the root of the repository (`melos.yaml`, `.github/workflows/ci.yml`).
- Impacts developer workflow: Pull requests will now have automated checks that must pass (format, analyze, test, and build).
- No direct impact on production app code.
