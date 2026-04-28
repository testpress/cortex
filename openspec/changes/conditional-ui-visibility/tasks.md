## 1. Infrastructure and Config

- [x] 1.1 Add visibility flags (`showTodaySchedule`, `showQuickAccess`, `showContextualHero`, `showStudyCategoryButtons`) to the `ClientConfig` model.
- [x] 1.2 Update the `clientConfigProvider` mock data to include these flags for testing the conditional logic.
- [x] 1.3 Add `instituteLogoUrl` and `isLocalLogo` to `ClientConfig`.

## 2. Institute Banner Implementation

- [x] 2.1 Create the `InstituteBanner` widget in `packages/core/lib/widgets/`.
- [x] 2.2 Implement the layout: Logo (Left), Name & Enrollment ID (Right, stacked).
- [x] 2.3 Apply styling to match design reference (adaptive dark mode colors, pure white light mode).
- [x] 2.4 Support both network and local asset images for institute logos.

## 3. Home Screen Customization

- [x] 3.1 Modify `PaidActiveHomeScreen` to read visibility flags from `clientConfigProvider`.
- [x] 3.2 Implement conditional section visibility (TodaySnapshot, QuickAccess, HeroCard).
- [x] 3.3 Implement custom section ordering for Brilliant Pala (Carousel -> Announcements -> Momentum -> Learners).
- [x] 3.4 Implement sticky banner behavior for Brilliant while keeping fixed header for other domains.

## 4. Study Screen Conditional Logic

- [x] 4.1 Modify `StudyCurriculumList` (or its header component) to read `showStudyCategoryButtons`.
- [x] 4.2 Conditionally render the category shortcut buttons below the search bar.

## 5. Header Integration and Polish

- [x] 5.1 Update `DashboardHeader` to support `customTopPadding` for domain-specific alignment.
- [x] 5.2 Decouple `DashboardHeader` from safe area logic when rendered below a sticky banner.
- [x] 5.3 Ensure vertical spacing is isolated between different subdomains.
32: 
33: ## 6. Lesson Sections Implementation
34: 
35: - [x] 6.1 Extend `ClientConfig` with lesson section flags (`showResumeSection`, `showWhatsNewSection`, `showRecentlyCompletedSection`).
36: - [x] 6.2 Create `LessonCardWidget` and `LessonCardsSectionWidget` with reusable carousel layout.
37: - [x] 6.3 Integrate lesson sections into `PaidActiveHomeScreen` with subdomain-specific reordering logic.
38: - [x] 6.4 Refine lesson card design (aspect ratio, padding, dark mode surface colors) to match React prototype.
