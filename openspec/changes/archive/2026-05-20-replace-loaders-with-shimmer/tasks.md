## 1. Loading Strategy Foundation

- [x] 1.1 Confirm the loading scope is limited to the Study tab course list skeleton.
- [x] 1.2 Update the shared loading primitive usage guidance so other screens keep their existing loading style.

## 2. Core and Shared UI Updates

- [x] 2.1 Keep `AppButton`, `AppHtml`, and other shared primitives on their existing loading behavior.
- [x] 2.2 Ensure determinate progress flows such as download/attachment loading continue to use progress indicators instead of skeletons.

## 3. Content Screen Skeleton Migration

- [x] 3.1 Keep the Study tab course list skeletonized.
- [x] 3.2 Keep other screens on their existing loading presentation.
- [x] 3.3 Refactor StudyContentList to use the official Skeletonizer pattern wrapping the actual list widget with dynamic enabled binding.

## 4. Shells, Routes, and Verification

- [x] 4.1 Review route shells and global loading surfaces to ensure only the Study tab course list uses shimmer.
- [x] 4.2 Add or update widget tests for the Study course list skeleton height preservation.
- [x] 4.3 Run targeted package tests for the changed areas and fix any regressions.
