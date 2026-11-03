## Why

Learners evaluating courses on the store product detail page need visibility into instructor credibility and teaching style. While the web platform provides a dedicated faculty showcase with credentials and introductory videos, mobile currently lacks native presentation of course instructors.

## What Changes

- Add a "Taught by" instructor overview row with overlapping avatars on the product overview when faculty data is present.
- Introduce a native "Meet your faculty" section below course description and curriculum, displaying instructor cards with experience, subjects, and video badges.
- Add a dedicated full-page `FacultyProfileScreen` displaying the instructor's introduction video, bio, highlights, qualifications, and course switcher.
- Extend `ProductDto` with typed `ProductFacultyDto` and `FacultyTeachingDto` models parsing live API payloads.
- Add multi-language localizations across English, Arabic, Malayalam, and Tamil.

## Capabilities

### New Capabilities
- `store-faculty-introduction`: Native faculty showcase on the store product detail page, including instructor summary row, instructor cards, and dedicated profile screen with video playback.

### Modified Capabilities
- `store-discovery`: Store product detail screen displays instructor credibility information while preserving all existing pricing, coupon, installment, and checkout actions.

## Impact

- `packages/core/lib/data/models/store_models.dart`: Adds `ProductFacultyDto` and `FacultyTeachingDto`, integrates into `ProductDto`.
- `packages/core/lib/l10n/`: Adds faculty localization strings across 4 supported languages.
- `packages/courses/lib/widgets/store/product_faculty_summary.dart`: Instructor summary row with overlapping avatars.
- `packages/courses/lib/widgets/store/product_faculty_section.dart`: "Meet your faculty" section with instructor cards.
- `packages/courses/lib/screens/store/faculty_profile_screen.dart`: Dedicated instructor profile screen with video player.
- `packages/courses/lib/screens/store/product_detail_screen.dart`: Integrates faculty components into product detail view.
- Unit and widget tests in `packages/courses/test/`.
