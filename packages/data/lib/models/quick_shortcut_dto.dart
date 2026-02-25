enum ShortcutIconType {
  video,
  practice,
  tests,
  notes,
  doubts,
  schedule,
}

class QuickShortcutDto {
  final String id;
  final String label;
  final ShortcutIconType iconType;
  final String? route;

  const QuickShortcutDto({
    required this.id,
    required this.label,
    required this.iconType,
    this.route,
  });
}
