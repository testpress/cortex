class AttachmentUtils {
  AttachmentUtils._();

  static const List<String> imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  static bool isImageFile(String path) {
    final lower = path.toLowerCase();
    return imageExtensions.any((ext) => lower.endsWith('.$ext'));
  }
}
