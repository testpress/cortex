# Courses Module Regression Testing

# Purpose
These tests validate the **composition** of core architectural primitives into domain-specific LMS features. While `core/test` verifies the building blocks, this folder ensures the final "Course" experience is stable, responsive, and accessible.

# What These Tests Guarantee

### 1. SDK Accessibility Composition
We verify that the `CourseCard` correctly maps LMS data (like progress percentage) into the semantic infrastructure provided by `core`. These tests ensure that screen readers announce the *intent* of the data (e.g., Progress) rather than just its visual manifestation (e.g., a green bar).

### 2. Functional Consistency
The `CourseListScreen` is tested to ensure it correctly renders mock data using only neutral primitives. We verify that scrolling behavior, empty states, and error states all maintain a consistent architectural footprint.

### 3. Contract Inheritence
Testing verifies that any branding injected via a `DesignProvider` at the app level correctly bubbles up through the course widgets, confirming that the module remains platform-neutral and white-label ready.

# Best Practices
- **Compose over Rebuild**: Do not re-test core primitive logic. Focus on how those primitives are grouped and what information they convey as a unit.
- **Semantic Assertions**: Use `SemanticsFinder` to verify that the high-level LMS features (Course titles, progress, CTA accessibility) are correctly exposed.
