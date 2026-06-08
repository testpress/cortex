## Context

The cortex repository is a Flutter monorepo containing an application shell and multiple independent feature packages. Currently, we lack an automated CI test runner. We need to introduce one to maintain code quality and prevent regressions, but want to keep it simple and avoid premature optimizations like matrix testing.

## Goals / Non-Goals

**Goals:**
- Provide a reliable CI check for every pull request and push to the main branch.
- Ensure all packages in the monorepo are correctly formatted, analyzed, and tested.
- Verify that the app builds a debug APK successfully.
- Pin the Flutter version exactly to `3.41.1` to avoid environmental inconsistencies.
- Use native bash loops to fetch dependencies and run tests across the monorepo instead of external tools.

**Non-Goals:**
- Explicitly NOT configuring matrix execution across OSes at this stage.
- Not adding coverage reporting, golden tests, or architecture enforcement yet.

## Decisions

**Decision 1: Native Bash Loops over Melos**
- *Rationale*: While Melos is powerful, its strict native Dart workspace requirements introduced unnecessary friction. Using a simple `for` loop to iterate over `app` and `packages/*` is fully native, requires zero configuration files, and gets the job done cleanly.

**Decision 2: Parallel GitHub Actions Jobs**
- *Rationale*: We split the pipeline into four independent jobs: `format`, `analyze`, `test`, and `build`. This provides excellent Developer Experience (DX) because a failure in `format` does not mask failures in `test`. While it uses slightly more CI compute minutes to setup Flutter multiple times, the clear visibility of failures is worth the trade-off.

## Risks / Trade-offs

- **Risk**: Test runtime may increase significantly as the project grows.
  - *Mitigation*: We monitor CI duration. If it becomes a bottleneck for developer wait times, we will migrate to a matrix testing approach.
- **Risk**: Pinning exact framework and engine hashes.
  - *Mitigation*: This guarantees stability now but means future Flutter version updates will require explicit bumps in the CI configuration file.
