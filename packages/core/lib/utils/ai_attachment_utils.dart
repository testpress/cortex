import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

/// Helpers for AI chat image attachment format and size validation.
abstract final class AiAttachmentUtils {
  static const int maxAttachmentSizeBytes = 5 * 1024 * 1024;

  static const Map<String, String> supportedImageFormats = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
  };

  /// Extracts lowercased extension without the leading dot.
  static String extractExtension(String pathOrName) {
    final ext = p.extension(pathOrName);
    return ext.isEmpty ? '' : ext.substring(1).toLowerCase();
  }

  /// Derives the canonical MIME type for an image path or MIME type.
  static String? deriveMimeType({String? pathOrName, String? mimeType}) {
    final ext = pathOrName != null ? extractExtension(pathOrName) : '';
    final mimeFromExt = supportedImageFormats[ext];
    if (mimeFromExt != null) return mimeFromExt;
    if (mimeType != null && supportedImageFormats.containsValue(mimeType)) {
      return mimeType;
    }
    return null;
  }

  /// Checks whether a path, name, or MIME type is an allowed image attachment.
  static bool isSupportedFile({String? pathOrName, String? mimeType}) {
    return deriveMimeType(pathOrName: pathOrName, mimeType: mimeType) != null;
  }

  /// Checks whether an [XFile] is an allowed image attachment.
  static bool isSupported(XFile file) {
    final candidate = file.name.isNotEmpty ? file.name : file.path;
    return isSupportedFile(pathOrName: candidate, mimeType: file.mimeType);
  }
}
