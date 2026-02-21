## 1. DesignColors — card token

- [ ] 1.1 Add `card` and `onCard` fields to `DesignColors` constructor (named required params)
- [ ] 1.2 Set `card: Color(0xFFFFFFFF)`, `onCard: Color(0xFF111827)` in `DesignColors.light()`
- [ ] 1.3 Set `card: Color(0xFF1E293B)`, `onCard: Color(0xFFF8FAFC)` in `DesignColors.dark()`
- [ ] 1.4 Add `card` to `DesignColors.smart()` defaulting to `surface`
- [ ] 1.5 Update `DesignColors ==` and `hashCode` to include `card` and `onCard`
- [ ] 1.6 Update `AppCard` widget to use `design.colors.card` instead of `design.colors.surface`

## 2. DesignSubjectPalette — indexed color palette

- [ ] 2.1 Create `SubjectColors` immutable class with `background`, `foreground`, `accent` color fields and `==` / `hashCode`
- [ ] 2.2 Create `DesignSubjectPalette` immutable class wrapping a `List<SubjectColors>` (min 8 entries)
- [ ] 2.3 Implement `DesignSubjectPalette.atIndex(int i)` returning `palettes[i % palettes.length]` — no subject names, no bounds errors
- [ ] 2.4 Implement `DesignSubjectPalette.light()` with 8 visually distinct palette slots:
  - 0: indigo (bg `#EEF2FF`, fg `#3730A3`, accent `#6366F1`)
  - 1: orange (bg `#FFF7ED`, fg `#9A3412`, accent `#F97316`)
  - 2: emerald (bg `#F0FDF4`, fg `#166534`, accent `#22C55E`)
  - 3: purple (bg `#F5F3FF`, fg `#5B21B6`, accent `#7C3AED`)
  - 4: rose (bg `#FFF1F2`, fg `#9F1239`, accent `#F43F5E`)
  - 5: sky (bg `#F0F9FF`, fg `#0369A1`, accent `#0EA5E9`)
  - 6: amber (bg `#FFFBEB`, fg `#92400E`, accent `#F59E0B`)
  - 7: teal (bg `#F0FDFA`, fg `#134E4A`, accent `#14B8A6`)
- [ ] 2.5 Implement `DesignSubjectPalette.dark()` with darker/muted equivalents for all 8 slots
- [ ] 2.6 Implement `DesignSubjectPalette ==` and `hashCode`
- [ ] 2.7 Add `subjectPalette` field to `DesignConfig`; include in `copyWith`, `==`, `hashCode`
- [ ] 2.8 Wire `DesignSubjectPalette.light()` in `DesignConfig.light()`, `.dark()` in `DesignConfig.dark()`

## 3. DesignStatusColors — status/badge token group

- [ ] 3.1 Create `StatusColors` immutable class with `background` and `foreground` fields and `==` / `hashCode`
- [ ] 3.2 Create `DesignStatusColors` immutable class with four `StatusColors` fields: `live`, `completed`, `locked`, `upcoming`
- [ ] 3.3 Implement `DesignStatusColors.light()`:
  - live: bg `#FEE2E2`, fg `#991B1B`
  - completed: bg `#D1FAE5`, fg `#065F46`
  - locked: bg `#F3F4F6`, fg `#6B7280`
  - upcoming: bg `#DBEAFE`, fg `#1E40AF`
- [ ] 3.4 Implement `DesignStatusColors.dark()` with dark-adjusted equivalents
- [ ] 3.5 Implement `DesignStatusColors ==` and `hashCode`
- [ ] 3.6 Add `statusColors` field to `DesignConfig`; include in `copyWith`, `==`, `hashCode`
- [ ] 3.7 Wire `DesignStatusColors.light()` / `.dark()` into `DesignConfig.light()` / `.dark()`

## 4. CourseDto — replace subjectColor with colorIndex

- [ ] 4.1 Rename `subjectColor: String` to `colorIndex: int` in `CourseDto`
- [ ] 4.2 Update `MockDataSource.getCourses()` to assign `colorIndex` values 0–7 across mock courses
- [ ] 4.3 Update `CourseCard` widget to call `design.subjectPalette.atIndex(course.colorIndex)` for subject accent rendering
- [ ] 4.4 Update `course_card_test.dart` to pass `colorIndex` instead of `subjectColor`

## 5. Verification

- [ ] 5.1 Run `flutter analyze` in `packages/core`, `packages/data`, `packages/courses` — zero errors
- [ ] 5.2 Run `flutter test` in `packages/core` and `packages/courses` — all tests pass
- [ ] 5.3 Verify `Design.of(context).subjectPalette.atIndex(99)` does not throw (modular wrap)
- [ ] 5.4 Verify `Design.of(context).statusColors.live.background` returns a Color
- [ ] 5.5 Hot-reload app — existing screens show no visual regressions
- [ ] 5.6 Verify `DesignConfig.copyWith(subjectPalette: custom)` propagates through `Design.of(context)`
