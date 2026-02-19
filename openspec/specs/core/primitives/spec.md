# Capability: Neutral UI & Primitives

## ADDED Requirements

### Requirement: Canvas-First Rendering

The SDK must avoid all platform-specific visual libraries (Material, Cupertino). All UI components must be built from low-level Flutter primitives.

#### Scenario: Building a new button

- **WHEN** a developer creates a new UI component
- **THEN** it must NOT use `ElevatedButton`, `TextButton`, or `CupertinoButton`
- **AND** it must be built using `Container`, `GestureDetector`, `Text`, or `CustomPaint`

### Requirement: Hit Target Enforcement

All interactive components must adhere to minimum accessibility sizing standards to ensure usability across touch devices.

#### Scenario: Interactive widget sizing

- **WHEN** an interactive widget (e.g., button, link) is rendered
- **THEN** its touch target must be at least 48x48 logical pixels
- **AND** this must be enforced even if the visual representation is smaller

### Requirement: SDK-Internal Neutrality

Modules within the Core and SDK domain folders must not leak platform-specific visual dependencies.

#### Scenario: Importing Material in Core

- **WHEN** a developer works in `packages/core` or `packages/courses`
- **THEN** they must NOT import `package:flutter/material.dart` or `package:flutter/cupertino.dart`
- **AND** only `package:flutter/widgets.dart` or other neutral packages should be used
