## Why
The current `lucide_icons` package used in the project is severely outdated (version 0.257.0, last updated in mid-2023) and misses many new icons from the official Lucide library. A better alternative is `lucide_icons_flutter`, which provides extra features like adjustable stroke thickness, RTL support, and stays up-to-date with newer Lucide releases.

## What Changes
- Replace the `lucide_icons` dependency with `lucide_icons_flutter` in `packages/core/pubspec.yaml` as the main icon provider.
- Retain the old `lucide_icons` dependency in `packages/core` strictly to preserve access to deprecated brand icons (like Chrome and YouTube).
- Create a `legacy_icons.dart` export file in `packages/core` to cleanly expose legacy icons without naming collisions or lint errors.
- Update all import paths across the monorepo from `package:lucide_icons/lucide_icons.dart` to `package:lucide_icons_flutter/lucide_icons.dart`, except for brand icon usages which will use the legacy export.

## Capabilities

### New Capabilities
- `lucide-icons-migration`: Migration of the core icon dependency from `lucide_icons` to `lucide_icons_flutter` to unlock newer icons, adjustable strokes, and RTL icon flipping.

### Modified Capabilities

## Impact
- Core package's `pubspec.yaml` dependencies.
- All Dart files across the monorepo (packages and app) that currently import the `lucide_icons` package will be affected and require import path updates.
