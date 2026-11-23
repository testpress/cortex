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

class _ThrowingImageCropper extends Fake implements ImageCropper {
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
    throw Exception('Platform error');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child) {
    return LocalizationProvider(
      child: Builder(
        builder: (context) {
          final locale = LocalizationProvider.of(context).locale;
          return WidgetsApp(
            color: const Color(0xFF000000),
            locale: locale,
            localizationsDelegates: LocalizationProvider.delegates,
            pageRouteBuilder:
                <T>(RouteSettings settings, WidgetBuilder builder) =>
                    PageRouteBuilder<T>(
                      settings: settings,
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          builder(context),
                    ),
            home: DesignProvider(config: DesignConfig.defaults(), child: child),
          );
        },
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

      final studioColors = DesignColors.dark();
      expect(androidSettings?.toolbarTitle, equals('Crop Image'));
      expect(androidSettings?.toolbarColor, equals(studioColors.surface));
      expect(
        androidSettings?.toolbarWidgetColor,
        equals(studioColors.textPrimary),
      );
      expect(androidSettings?.statusBarLight, isFalse);
      expect(androidSettings?.navBarLight, isFalse);
      expect(androidSettings?.backgroundColor, equals(studioColors.canvas));
      expect(androidSettings?.dimmedLayerColor, equals(studioColors.overlay));
      expect(iosSettings?.title, equals('Crop Image'));
    });

    testWidgets('captures exception and returns null on cropper error', (
      tester,
    ) async {
      final throwingCropper = _ThrowingImageCropper();
      final cropper = AppImageCropper(throwingCropper);

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

      final tempFile = File('${Directory.systemTemp.path}/test_error.jpg');
      tempFile.writeAsStringSync('dummy');
      addTearDown(() {
        if (tempFile.existsSync()) {
          tempFile.deleteSync();
        }
      });

      final result = await tester.runAsync(() async {
        return cropper.crop(capturedContext, imagePath: tempFile.path);
      });

      expect(result, isNull);
    });
  });
}
