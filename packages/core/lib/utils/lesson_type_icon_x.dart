import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:core/data/data.dart' show LessonType;

extension LessonTypeIconX on LessonType {
  IconData get icon {
    return switch (this) {
      LessonType.video => LucideIcons.playCircle,
      LessonType.pdf || LessonType.attachment => LucideIcons.paperclip,
      LessonType.notes || LessonType.embedContent => LucideIcons.penSquare,
      LessonType.liveStream => LucideIcons.video,
      _ => LucideIcons.bookOpen,
    };
  }
}
