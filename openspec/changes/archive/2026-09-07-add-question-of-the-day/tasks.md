## 1. Data Model & Architecture
- [x] 1.1 Update `InstituteSettings` model to include `final bool qotdEnabled;`
- [x] 1.2 Update `fromJson` and `toJson` serialization logic for `qotd_enabled`
- [x] 1.3 Create `QotdDto`, `QotdOptionDto`, `QotdSubmitResponseDto`, and `QotdSummaryDto`
- [x] 1.4 Implement dynamic `extractSubject` parser in `QotdDto` to handle polymorphic API shapes without hardcoding
- [x] 1.5 Implement `QotdRepository` and `qotdQuizControllerProvider` (Riverpod)

## 2. Screens & UI Flow
- [x] 2.1 Implement `QotdOverviewScreen` with statistics gauge, completion summary, and date tracking
- [x] 2.2 Implement interactive `QotdQuizScreen` with multi-question stepper and solution view
- [x] 2.3 Configure `/qotd` and quiz routes in `AppRouter`
- [x] 2.4 Add "Daily Questions" item with calendar icon to `DashboardDrawer` (guarded by `qotdEnabled`)

## 3. Visual Polish & Design System Governance
- [x] 3.1 Single unified metadata pill (`Subject • Difficulty • Type`) using design tokens and `#0F172A` text
- [x] 3.2 Streamlined `AppHeader` with top-aligned back button and progress indicator
- [x] 3.3 Remove redundant question labels and sub-prompts
- [x] 3.4 Support custom MathJax SVG rendering in `AppHtmlV2`


