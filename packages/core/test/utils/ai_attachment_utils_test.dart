import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('AiAttachmentUtils', () {
    test(
      'extractExtension extracts lowercased extension without leading dot',
      () {
        expect(AiAttachmentUtils.extractExtension('image.jpg'), 'jpg');
        expect(AiAttachmentUtils.extractExtension('path/to/IMAGE.PNG'), 'png');
        expect(
          AiAttachmentUtils.extractExtension('/folder.with.dot/photo.WEBP'),
          'webp',
        );
        expect(AiAttachmentUtils.extractExtension('photo.JPEG'), 'jpeg');
        expect(AiAttachmentUtils.extractExtension('animation.gif'), 'gif');
        expect(AiAttachmentUtils.extractExtension('camera.heic'), 'heic');
        expect(AiAttachmentUtils.extractExtension('no_extension'), '');
      },
    );

    test('deriveMimeType resolves supported image MIME types', () {
      expect(
        AiAttachmentUtils.deriveMimeType(pathOrName: 'image.jpg'),
        'image/jpeg',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(pathOrName: 'image.jpeg'),
        'image/jpeg',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(pathOrName: 'image.png'),
        'image/png',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(pathOrName: 'image.webp'),
        'image/webp',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(mimeType: 'image/jpeg'),
        'image/jpeg',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(mimeType: 'image/png'),
        'image/png',
      );
      expect(
        AiAttachmentUtils.deriveMimeType(mimeType: 'image/webp'),
        'image/webp',
      );
      expect(AiAttachmentUtils.deriveMimeType(pathOrName: 'image.gif'), isNull);
      expect(AiAttachmentUtils.deriveMimeType(mimeType: 'image/gif'), isNull);
    });

    test('isSupported validates XFile instances', () {
      expect(AiAttachmentUtils.isSupported(XFile('test.jpg')), isTrue);
      expect(AiAttachmentUtils.isSupported(XFile('test.PNG')), isTrue);
      expect(AiAttachmentUtils.isSupported(XFile('test.webp')), isTrue);
      expect(AiAttachmentUtils.isSupported(XFile('test.gif')), isFalse);
      expect(AiAttachmentUtils.isSupported(XFile('test.heic')), isFalse);
      expect(AiAttachmentUtils.isSupported(XFile('test.bmp')), isFalse);
    });

    test('AiScreen forwards correctly to AiAttachmentUtils', () {
      expect(AiScreen.maxAttachmentSizeBytes, 5 * 1024 * 1024);
      expect(AiScreen.supportedImageFormats, {
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'png': 'image/png',
        'webp': 'image/webp',
      });
      expect(AiScreen.extractExtension('test.PNG'), 'png');
      expect(AiScreen.isSupportedImageFile(pathOrName: 'test.jpg'), isTrue);
      expect(AiScreen.isSupportedImageFile(pathOrName: 'test.gif'), isFalse);
    });
  });
}
