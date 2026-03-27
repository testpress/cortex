# Problem

The `profile` and `explore` packages in the monorepo were not initialized using the standard Flutter package template used by `exams`, `courses`, and `core`. This has led to architectural debt and inconsistency, including:
- Missing mandatory root-level files (`README.md`, `LICENSE`, `analysis_options.yaml`, `CHANGELOG.md`).
- Missing standard boilerplate comments and formatting in `pubspec.yaml`, which are present in the other domain packages.
- Inconsistent layer structure in `explore` (missing `data/`, `models/`, and `repositories/` directories).

# What Changes

1.  **Boilerplate Alignment**: Inject the standard Flutter package boilerplate into `profile` and `explore` to bring them into absolute parity with the other packages in the monorepo.
2.  **Structural Standardization**: Ensure both packages contain the standard project folder structure. For `explore`, this means adding the missing `data/`, `models/`, and `repositories/` layer directories.
3.  **Metadata Consistency**: Add all required root-level configuration and documentation files using the standard project templates.

## Capabilities

### New Capabilities
- `package-standardization`: Full structural and boilerplate alignment for all domain packages.
- `package-metadata-bootstrap`: Requirement for all packages to include universal `README`, `LICENSE`, and `analysis_options`.

### Modified Capabilities
- `lms-profile`: Minor refinement of root metadata.
- `lms-explore-dashboard`: Structural update to include standard domain layers.

# Impact

- Root-level configuration of `packages/profile` and `packages/explore`.
- Folder structure of `packages/explore/lib/`.
- No functional changes will be made to screens, providers, or existing UI logic.

# Review Scope

- ALL files in `packages/profile` and `packages/explore` will be reviewed.
- `packages/core` (for Neutral primitives).
- Root configuration files for consistency.
