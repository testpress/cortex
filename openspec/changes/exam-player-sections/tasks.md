## 1. Repository and State
- [x] 1.1 Refactor `ExamRepository` to manage section states and heartbeat countdown timers
- [x] 1.2 Implement state rollback in `submitAnswer` for network failures and introduce robust logging

## 2. UI Player Overhaul
- [x] 2.1 Overhaul `TestDetailScreen` to consume `examAttemptProvider` stream
- [x] 2.2 Migrate player widgets (`test_question_card.dart`, `test_header.dart`) to Core DTO models
- [x] 2.3 Localize hardcoded strings in `TestDetailScreen` ('Exam Instructions', 'Start Exam', 'Next Subject', 'Next Section')
