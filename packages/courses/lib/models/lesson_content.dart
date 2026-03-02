import 'package:data/data.dart' show LessonContentItemDto;

/// Represents a single atom of content within a text-based lesson.
sealed class LessonContentItem {
  const LessonContentItem();

  /// Maps a DTO item to its corresponding domain model.
  static LessonContentItem fromDto(LessonContentItemDto dto) {
    switch (dto.type) {
      case 'heading':
        return HeadingContent(
          text: dto.content as String,
          level: dto.level ?? 2,
        );
      case 'paragraph':
        return ParagraphContent(text: dto.content as String);
      case 'image':
        return ImageContent(imageUrl: dto.content as String, altText: dto.alt);
      case 'list':
        return ListContent(items: List<String>.from(dto.content as List));
      case 'callout':
        return CalloutContent(
          text: dto.content as String,
          type: CalloutType.values.firstWhere(
            (e) => e.name == dto.calloutType,
            orElse: () => CalloutType.note,
          ),
        );
      default:
        return ParagraphContent(text: dto.content.toString());
    }
  }
}

/// A structured heading within a lesson.
class HeadingContent extends LessonContentItem {
  const HeadingContent({required this.text, this.level = 2});

  /// The text content of the heading.
  final String text;

  /// The hierarchy level (1-3, where 1 is largest).
  final int level;
}

/// A block of text within a lesson.
class ParagraphContent extends LessonContentItem {
  const ParagraphContent({required this.text});

  /// The raw text of the paragraph.
  final String text;
}

/// An illustrative image within a lesson.
class ImageContent extends LessonContentItem {
  const ImageContent({required this.imageUrl, this.altText});

  /// The remote URL of the image.
  final String imageUrl;

  /// Accessibility alternative text.
  final String? altText;
}

/// A bulleted list of items.
class ListContent extends LessonContentItem {
  const ListContent({required this.items});

  /// The individual bullet point strings.
  final List<String> items;
}

/// Types of contextual callout boxes.
enum CalloutType { note, tip, warning, example }

/// A highlighted informational box.
class CalloutContent extends LessonContentItem {
  const CalloutContent({required this.text, required this.type});

  /// The content within the callout.
  final String text;

  /// The semantic type of warning/info.
  final CalloutType type;
}
