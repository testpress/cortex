## ADDED Requirements

### Requirement: Persistent Reply Composer
The system SHALL display a persistent reply input field at the bottom of the `DoubtDetailScreen`.

#### Scenario: Accessing reply composer
- **WHEN** the student scrolls through the doubt thread
- **THEN** the reply input field remains anchored at the bottom of the screen.

### Requirement: Rich-Text Support in Replies
The system SHALL allow students to use rich-text formatting (bold, italic, lists) within their follow-up replies.

#### Scenario: Composing a formatted reply
- **WHEN** the student uses the toolbar to bold text in the composer
- **THEN** the text in the input field displays the bold formatting.

### Requirement: Multi-Format Attachments in Replies
The system SHALL allow students to attach up to 5 files (Images/PDFs) to a follow-up reply.

#### Scenario: Attaching a PDF to a reply
- **WHEN** the student selects a PDF file using the attachment button
- **THEN** the PDF is added to the preview strip with a file icon.

### Requirement: Reply Submission and Feedback
The system SHALL allow the student to post their reply and provide immediate feedback (loading state on button) during the submission.

#### Scenario: Posting a reply successfully
- **WHEN** the student taps "Post Reply" after entering text
- **THEN** the button shows a loading indicator and the reply appears in the thread after a short delay.
