# Profile & Account Management

The `profile` module manages user identity, account preferences, and authentication views.

## Purpose
This module handles user authentication flows, profile management, and notification settings for the Cortex LMS.

## Standards
- Depends on `package:core/core.dart` for all UI primitives.
- Must follow the **Neutral UI** and **Accessibility** contracts defined in `core`.
- No direct dependencies on standard Material/Cupertino widgets.

# Accessibility Integration

### Semantic Compositions
The profile module inherits its accessibility foundation from `core`. Components must compose these foundations into domain-specific semantics:
- **Authentication Forms**: Input fields use `AppSemantics.textField` to ensure proper labeling and error announcements.
- **Account Actions**: Buttons like "Logout" or "Update Profile" use `AppSemantics.button` with clear, descriptive labels for screen readers.
- **Information Landmarks**: User metadata and statistics sections use semantic headers for quick navigation.
