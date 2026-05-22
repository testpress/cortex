## Context

The Cortex monorepo relies on the `lucide_icons` package (v0.257.0) for standard iconography. This package hasn't been updated since mid-2023 and is missing many new icons from the official Lucide library. Furthermore, the existing package lacks support for advanced configurations like stroke thickness variations and Right-To-Left (RTL) directional flipping. 

`lucide_icons_flutter` is an actively maintained package that supports newer Lucide specs (e.g., v1.16.0+) and includes both thickness variants (e.g., `LucideIcons.activity100`) and RTL icons (e.g., `LucideIcons.aArrowDownDir`).

## Goals / Non-Goals

**Goals:**
- Seamlessly replace the `lucide_icons` dependency with `lucide_icons_flutter` across all `pubspec.yaml` files (primarily in `packages/core`) for standard UI icons.
- Retain access to specific brand icons (e.g., `chrome`, `youtube`) which were completely removed from the newer Lucide specifications.
- Perform a codebase-wide update of import statements to `package:lucide_icons_flutter/lucide_icons.dart`.
- Ensure the project builds successfully and fix any compile-time errors due to renamed or removed icons.

**Non-Goals:**
- Changing the actual UI icons or adjusting stroke thickness across the app right now. We aim for a drop-in 1:1 replacement.
- Modifying other icon libraries (like Remix icons).

## Decisions

- **Global Find-and-Replace**: Since `lucide_icons_flutter` uses the exact same `LucideIcons` class prefix, a global text replacement of the import string is the safest and most efficient way to migrate.
- **Handling Removed Brand Icons**: The official Lucide project removed all brand icons in newer versions. To preserve icons like `chrome` and `youtube`, we will retain the old `lucide_icons` package in `core` and expose it via a dedicated `packages/core/lib/legacy_icons.dart` file. This avoids naming collisions in `core.dart` and bypasses `depend_on_referenced_packages` lint errors in downstream packages.
- **Compile-Time Validation**: We will rely on the Dart compiler to catch any icon regressions.

## Risks / Trade-offs

- **Risk: Broken Icon References**: There's a high chance that a few icons have been renamed or removed in the newer Lucide specification.
  - *Mitigation*: Run `flutter analyze` or a full build after the find-and-replace. We will map undefined brand icons to the `legacy_icons.dart` export, and map renamed standard icons to their new equivalents.
