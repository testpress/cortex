# Testpress SDK Aggregator

Public entry point for the Cortex SDK.

## Purpose
The `testpress` package acts as the **public aggregator**. It re-exports APIs from internal modules (`core`, `courses`, `exams`) to provide a clean, unified interface for consumers.

## Architecture
- **No implementation logic**: This package should primarily contain exports.
- **API Stability**: Changes here affect all external consumers.
- **Entry Points**:
  - `package:testpress/course_list.dart` - Courses API

## Usage
Consumers should import ONLY this package:
```dart
import 'package:testpress/course_list.dart';
```
