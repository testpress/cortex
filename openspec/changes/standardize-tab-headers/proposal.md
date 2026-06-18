## Why
Currently, the headers in the Study, Exam, and Info screens are built directly inside their scrollable views. This causes the headers to bounce and stretch out of bounds when the user scrolls, leading to an awkward visual experience.

## What Changes
- **Extract Headers from Scroll Views**: Move the header content out of the scrollable areas and into a fixed, static `Column` structure for the Study, Exam, and Info tabs.
- **Normalize Scroll Physics**: Remove hardcoded `BouncingScrollPhysics` from these tabs to allow standard platform scrolling and prevent over-stretching the content below the static headers.
- **Pull to Refresh**: Implement Material's `RefreshIndicator` on the scrolling list content for all three tabs to allow users to refresh data.

## Capabilities

### New Capabilities

### Modified Capabilities
- `tab-layouts`: Updating the structural layout requirements for primary content tabs to ensure static headers.

## Impact
- **Affected code**: `study_screen.dart`, `exams_screen.dart`, and `info_page.dart`.
- **Impact**: Headers become completely static and will not bounce or stretch when users scroll the main content lists.
