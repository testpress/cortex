## Context

When learners browse courses in the store, instructor credentials and teaching experience directly influence purchase confidence. The web portal features an instructor showcase with credentials and introductory videos. This change implements native faculty discovery on `ProductDetailScreen` in Cortex without disrupting existing pricing or purchase flows.

## Goals / Non-Goals

**Goals:**
- Display a compact instructor summary row with avatars on the product overview.
- Render a "Meet your faculty" section with instructor cards below the curriculum.
- Provide a dedicated `FacultyProfileScreen` displaying the instructor's introduction video, bio, highlights, qualifications, and course switcher.
- Ensure identical rendering and responsive layout across phones and tablets.
- Ensure full accessibility semantics with minimum 48dp touch targets.
- Localize all user-facing strings across English, Arabic, Malayalam, and Tamil.

**Non-Goals:**
- Modifying backend Django endpoints or database schemas (faculty payload already exists in `/api/v3/products/{slug}/`).
- Modifying existing product pricing, coupons, installments, or payment processing workflows.

## Decisions

### D1: Two-Tier Faculty Presentation on Product Detail
Faculty presentation is split into two placements on `ProductDetailScreen`:
1. **Summary Row (`ProductFacultySummary`)**: Positioned above the Description/Curriculum tabs to provide immediate visual attribution via overlapping circular avatars (capped at 4) and a summary string (e.g. "Taught by Dr. Rao and 2 more"). Tapping scrolls the view smoothly down to the "Meet your faculty" section so learners can browse all instructors.
2. **Faculty Cards Section (`ProductFacultySection`)**: Positioned below curriculum content, rendering vertical cards with instructor photo, intro video badge, name, subjects, experience, and bio snippet. If a product has more than 4 instructors, only the first 4 are shown initially with a "Show all {count} faculty" expand toggle.

*Rationale*: High-level attribution is immediately visible on first glance, while deeper instructor bios are placed alongside curriculum details without pushing key purchase actions out of view.

### D2: Dedicated Full-Page Faculty Profile Screen
Tapping any instructor card pushes `FacultyProfileScreen` via `AppRoute`.
- **Top Bar**: Platform-neutral `AppHeader` with `AppBackButton` enforcing a 48×48dp touch target with optical alignment and localized title.
- **Video Section**: 16:9 aspect ratio container embedding a dedicated `WebViewController`/`WebViewWidget` with an inline HTML wrapper, JavaScript channel communication (`VideoChannel`) for ready state detection, and a clean loading overlay (`AppLoadingIndicator`) that conceals the unscaled web view during initial load until ready or `onPageFinished`. Omitted if the instructor has no video URL.
- **Credentials & Bio**: Instructor avatar, full name, subjects, teaching experience badge, highlights with award icons, qualifications with graduation cap icons, and biographical summary.
- **Course Video Switcher**: When an instructor teaches multiple courses in the bundle with separate intro videos, an interactive course list lets the learner switch the active stream with a "Now showing" indicator.
- **Responsive Layout**: Body content is centered within a maximum width container (`maxWidth: 720`), ensuring comfortable reading widths and balanced media sizing across both phones and tablets.

*Rationale*: Dedicated screen navigation integrates with standard platform back gestures, isolates media playback from parent scroll controllers, and scales consistently across form factors.

### D3: Typed Data Contract
Extend `ProductDto` with `List<ProductFacultyDto> faculty` and nested `FacultyTeachingDto` matching the `/api/v3/products/{slug}/` payload.
- `ProductFacultyDto` captures `id`, `name`, `initials`, `photo`, `shortDescription`, `designation`, `yearsOfExperience`, `highlights`, `qualifications`, `bio`, `subjects`, `courses`, `videoUrl`, and `teaches`.
- `FacultyTeachingDto` maps individual course teaching assignments (`id`, `course`, `subject`, `videoUrl`).
- Model parsing defensively defaults empty lists and null strings, ensuring backward compatibility when products have no faculty attached.

### D4: Design Tokens & Accessibility Compliance
All components use Cortex neutral design primitives without Material or Cupertino dependencies:
- Contextual tokens: colors, spacing, radius, and typography read from `Design.of(context)`.
- Semantic accessibility: interactive cards, summary row, back button, and course items wrapped in `AppSemantics.button`; section titles wrapped in `AppSemantics.header`.
- Touch targets: back button, expand toggle, summary row, and course switcher items all enforce a minimum 48×48dp hit area per WCAG 2.5.5.
- Iconography: exclusively uses `LucideIcons` (`award`, `graduationCap`, `briefcase`, `playCircle`, `play`, `arrowLeft`, `chevronDown`, `chevronUp`, `chevronRight`).

## Risks / Trade-offs

- **[Risk] Products without assigned faculty** → *Mitigation*: Both `ProductFacultySummary` and `ProductFacultySection` conditionally evaluate `product.faculty.isNotEmpty` and return `SizedBox.shrink()` when empty, consuming zero layout height.
- **[Risk] Faculty without introduction video** → *Mitigation*: The 16:9 video container is conditionally rendered only when `hasIntroVideo` is true, falling back to credentials and bio directly below the header.
- **[Risk] Missing or failing instructor photo URLs** → *Mitigation*: `CachedNetworkImage` specifies an error widget and placeholder that fallback to a monogram avatar (`_buildInitials`) derived from instructor initials.
