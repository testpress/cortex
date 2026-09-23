## Context

See proposal.md for motivation. `LessonDto` in `packages/core` represents parsed lesson items from Testpress APIs. In V2.5/V3, assignments appear in curriculum listings, but filtered or detail calls omit `content_url` and return empty/null metadata blocks (`name: null`). In production multi-tenant environments, each institute runs on a custom `domainUrl` from `InstituteSettings`. Navigating directly to web assignment pages requires Django session authentication via presigned SSO tokens, matching the pattern in `MyReportScreen`.

## Goals / Non-Goals

**Goals:**
- Add `LessonType.assignment` to core models.
- Support parsing assignments from API JSON payloads in `LessonDto.fromJson`.
- Implement safe merge in `LessonDto.mergeWith` (preserving assignment type, title, and existing `contentUrl` when detail responses lack them).
- Implement dynamic domain resolution using `InstituteSettings.domainUrl` (fallback to API host).
- Construct target web path using canonical format: `/chapters/<chapter_slug>/<content_id>/`.
- Generate presigned SSO URL via `UserRepository.getPresignedSsoUrl()` with destination `next=/chapters/<chapter_slug>/<content_id>/`.
- Provide an `AssignmentLessonViewer` that loads the SSO URL and enforces strict navigation protection (`NavigationDecision.prevent` for out-of-bounds URLs).
- Support local database roundtrips via `LessonsTable` and `CourseRepository`.

**Non-Goals:**
- Creating a curriculum filter chip badge for assignment (explicitly excluded).
- Building custom native submission form fields (Django web app handles the form inside the WebView).

## Decisions

1. **Domain URL Dynamic Resolution**: Instead of hardcoding `AppConfig.apiBaseUrl`, resolve the domain dynamically from `InstituteSettings.domainUrl` (via `instituteSettingsProvider` / `InstituteSettingsLocalDataSource`), exactly as implemented in `MyReportScreen`.
2. **SSO Entry Point**: Request a presigned SSO URL (`userRepo.getPresignedSsoUrl()`) and append `next=/chapters/<chapterSlug>/<contentId>/` to seamlessly establish the student's Django session cookie.
3. **Safe Merge Strategy**: When merging with partial detail responses that return null title or unknown type, retain existing assignment attributes.
4. **Navigation Shield**: In `onNavigationRequest`, only allow URLs on the institute domain matching `/sso/` or `/chapters/<chapterSlug>/<contentId>/` (and submission endpoints). Prevent navigations to other portal routes (e.g. `/courses/`, `/profile/`, navbar links).

## Risks / Trade-offs

- [Slow SSO token fetch] → Show loading indicator / skeleton while `getPresignedSsoUrl()` is requested.
- [External links in instructions] → Restrict navigation to keep user in context; open true external links with system launcher if necessary.
