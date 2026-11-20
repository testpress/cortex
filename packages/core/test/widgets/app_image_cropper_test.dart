import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';
import 'package:image_cropper/image_cropper.dart';

class _FakeImageCropper extends Fake implements ImageCropper {
  final CroppedFile? resultToReturn;
  List<PlatformUiSettings>? lastUiSettings;
  _FakeImageCropper(this.resultToReturn);

  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    CropStyle? cropStyle,
    ImageCompressFormat? compressFormat,
    int? compressQuality,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    lastUiSettings = uiSettings;
    return resultToReturn;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child) {
    return DesignProvider(
      config: DesignConfig.defaults(),
      child: LocalizationProvider(
        child: Directionality(textDirection: TextDirection.ltr, child: child),
      ),
    );
  }

  group('AppImageCropper', () {
    testWidgets('returns null when image file does not exist', (tester) async {
      late BuildContext capturedContext;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final cropper = AppImageCropper();
      final result = await tester.runAsync(() async {
        return cropper.crop(
          capturedContext,
          imagePath: '/non/existent/path/image.jpg',
        );
      });

      expect(result, isNull);
    });

    testWidgets('delegates to ImageCropper when file exists', (tester) async {
      final fakeCropper = _FakeImageCropper(CroppedFile('/tmp/cropped.jpg'));
      final cropper = AppImageCropper(fakeCropper);

      late BuildContext capturedContext;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final tempFile = File('${Directory.systemTemp.path}/test_source.jpg');
      tempFile.writeAsStringSync('dummy');
      addTearDown(() {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      });

      final result = await tester.runAsync(() async {
        return cropper.crop(capturedContext, imagePath: tempFile.path);
      });

      expect(result, equals('/tmp/cropped.jpg'));
    });

    testWidgets('uses localized crop title', (tester) async {
      final fakeCropper = _FakeImageCropper(CroppedFile('/tmp/cropped.jpg'));
      final cropper = AppImageCropper(fakeCropper);

      late BuildContext capturedContext;
      await tester.pumpWidget(
        wrap(
          Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      final tempFile = File('${Directory.systemTemp.path}/test_localized.jpg');
      tempFile.writeAsStringSync('dummy');
      addTearDown(() {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      });

      await tester.runAsync(() async {
        await cropper.crop(capturedContext, imagePath: tempFile.path);
      });

      final androidSettings = fakeCropper.lastUiSettings
          ?.whereType<AndroidUiSettings>()
          .firstOrNull;
      final iosSettings = fakeCropper.lastUiSettings
          ?.whereType<IOSUiSettings>()
          .firstOrNull;

      expect(androidSettings?.toolbarTitle, equals('Crop Image'));
      expect(iosSettings?.title, equals('Crop Image'));
    });
  });
}
