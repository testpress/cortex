/// Test type.
enum TestType { mock, chapter, practice }

/// Test DTO — a scheduled examination.
class TestDto {
  final String id;
  final String title;
  final String time;
  final String duration;
  final TestType type;
  final bool isImportant;

  const TestDto({
    required this.id,
    required this.title,
    required this.time,
    required this.duration,
    required this.type,
    this.isImportant = false,
  });
}
