## Context

The UI on the content detail and lesson detail pages needs minor adjustments to align better with other areas of the application (e.g., exams UI). The next/previous buttons are too prominent and have an unneeded footer, and the back button padding on the lesson detail page header is misaligned.

## Goals / Non-Goals

**Goals:**
- Shrink the next and previous buttons on the content detail page and remove the surrounding footer block.
- Adjust the left padding of the back button in the lesson detail page header.

**Non-Goals:**
- A full redesign of the content detail or lesson detail page.
- Changing the functionality or logic of the next/previous buttons.

## Decisions

- **UI Tweak Strategy:** We will modify the existing widgets directly. For the next/previous buttons, we will replace the large block/footer with smaller, inline buttons that match the exam UI style. For the back button, we will locate the `AppHeader` or `AppBar` equivalent in the lesson detail page and adjust its `leading` padding or remove any unwanted spacing.

## Risks / Trade-offs

- **Risk:** Modifying the next/previous buttons might affect layout on different screen sizes.
  - **Mitigation:** Use standard responsive padding and layout widgets.
