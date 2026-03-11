/// Assignment status.
enum AssignmentStatus { pending, submitted, overdue }

/// Assignment DTO — a task with a deadline.
class AssignmentDto {
  final String id;
  final String title;
  final String subject;
  final String dueTime;
  final AssignmentStatus status;
  final int progress; // 0–100
  final String? description;

  const AssignmentDto({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueTime,
    required this.status,
    required this.progress,
    this.description,
  });
}
