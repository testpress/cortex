import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:core/core.dart';
import 'package:core/data/data.dart';
import 'package:discussions/screens/ask_doubt_form_screen.dart';
import 'package:discussions/widgets/forum_composer.dart';

class _FakeDoubtRepository implements DoubtRepository {
  DoubtQueryType? lastCreatedQueryType;

  @override
  Future<String> createDoubt({
    required String title,
    required String description,
    int? topicId,
    int? chapterContentId,
    int? questionId,
    DoubtQueryType? queryType,
  }) async {
    lastCreatedQueryType = queryType;
    return 'doubt_1';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeAppImageCropper extends Fake implements AppImageCropper {
  FutureOr<String?> Function(String path)? onCrop;
  int cropCallCount = 0;
  final List<String> croppedPaths = [];

  @override
  Future<String?> crop(
    BuildContext context, {
    required String imagePath,
  }) async {
    cropCallCount++;
    croppedPaths.add(imagePath);
    if (onCrop != null) {
      return await onCrop!(imagePath);
    }
    return '${imagePath}_cropped';
  }
}

class _FakeImagePicker extends Fake implements ImagePicker {
  List<XFile> multiImages = [];
  XFile? cameraImage;

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    return multiImages;
  }

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return cameraImage;
  }
}

void main() {
  late _FakeDoubtRepository fakeRepo;

  setUp(() {
    fakeRepo = _FakeDoubtRepository();
  });

  tearDown(() {
    AppConfig.enableAiDoubtOverride = null;
  });

  Widget buildScreen({
    bool isAskAi = false,
    _FakeImagePicker? picker,
    _FakeAppImageCropper? cropper,
  }) {
    return ProviderScope(
      overrides: [
        doubtRepositoryProvider.overrideWith((ref) async => fakeRepo),
        doubtSubtopicsProvider(null).overrideWith(
          (ref) => Stream.value([
            const DoubtTopicDto(id: 1, title: 'General', hasChildren: false),
          ]),
        ),
        if (picker != null) imagePickerProvider.overrideWithValue(picker),
        if (cropper != null) imageCropperProvider.overrideWithValue(cropper),
      ],
      child: DesignProvider(
        config: DesignConfig.defaults(),
        child: LocalizationProvider(
          child: MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: LocalizationProvider.delegates,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AskDoubtFormScreen(isAskAi: isAskAi),
                      ),
                    ),
                    child: const Text('Open Form'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('AskDoubtFormScreen submission routing', () {
    testWidgets('opens submit options sheet when enableAiDoubt is true', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AppConfig.enableAiDoubtOverride = true;

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // Enter title
      await tester.enterText(find.byType(AppTextField), 'Sample Doubt Title');
      await tester.pumpAndSettle();

      // Enter quill description
      final editorField = tester.widget<ForumEditorField>(
        find.byType(ForumEditorField),
      );
      editorField.controller.document.insert(0, 'Detailed question text');
      await tester.pumpAndSettle();

      // Select topic
      final topicChip = find.text('General');
      expect(topicChip, findsOneWidget);
      await tester.tap(topicChip);
      await tester.pumpAndSettle();

      // Tap Next button
      final nextButton = find.widgetWithText(AppButton, 'Next');
      expect(nextButton, findsOneWidget);
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // When enableAiDoubt is true, sheet should open with AI and Mentor options
      expect(find.text('How would you like to ask?'), findsOneWidget);
      expect(find.text('Ask AI'), findsOneWidget);
      expect(find.text('Ask Mentor'), findsOneWidget);
    });

    testWidgets('submits directly to mentor when enableAiDoubt is false', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      AppConfig.enableAiDoubtOverride = false;

      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      // Open screen
      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      // Enter title
      await tester.enterText(find.byType(AppTextField), 'Direct Mentor Doubt');
      await tester.pumpAndSettle();

      // Enter quill description
      final editorField = tester.widget<ForumEditorField>(
        find.byType(ForumEditorField),
      );
      editorField.controller.document.insert(0, 'Detailed question text');
      await tester.pumpAndSettle();

      // Select topic
      final topicChip = find.text('General');
      expect(topicChip, findsOneWidget);
      await tester.tap(topicChip);
      await tester.pumpAndSettle();

      // Tap Next button
      final nextButton = find.widgetWithText(AppButton, 'Next');
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Options sheet should NOT be shown
      expect(find.text('How would you like to ask?'), findsNothing);
      expect(find.text('Ask AI'), findsNothing);

      // Verify direct submission to mentor
      expect(fakeRepo.lastCreatedQueryType, DoubtQueryType.mentor);

      // Flush toast timer
      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets(
      'submits directly to mentor even if isAskAi is true when enableAiDoubt is false',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        AppConfig.enableAiDoubtOverride = false;

        await tester.pumpWidget(buildScreen(isAskAi: true));
        await tester.pumpAndSettle();

        // Open screen
        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        // Enter title
        await tester.enterText(
          find.byType(AppTextField),
          'Direct Mentor Doubt With isAskAi',
        );
        await tester.pumpAndSettle();

        // Enter quill description
        final editorField = tester.widget<ForumEditorField>(
          find.byType(ForumEditorField),
        );
        editorField.controller.document.insert(0, 'Detailed question text');
        await tester.pumpAndSettle();

        // Select topic
        final topicChip = find.text('General');
        expect(topicChip, findsOneWidget);
        await tester.tap(topicChip);
        await tester.pumpAndSettle();

        // Tap Next button
        final nextButton = find.widgetWithText(AppButton, 'Next');
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Options sheet should NOT be shown
        expect(find.text('How would you like to ask?'), findsNothing);
        expect(find.text('Ask AI'), findsNothing);

        // Verify direct submission to mentor
        expect(fakeRepo.lastCreatedQueryType, DoubtQueryType.mentor);

        // Flush toast timer
        await tester.pump(const Duration(seconds: 3));
      },
    );
  });

  group('AskDoubtFormScreen image picking and cropping', () {
    testWidgets(
      'picks images from gallery, crops each, and attaches cropped files',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeImagePicker();
        final fakeCropper = _FakeAppImageCropper();
        fakePicker.multiImages = [XFile('img1.png'), XFile('img2.png')];

        await tester.pumpWidget(
          buildScreen(picker: fakePicker, cropper: fakeCropper),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        final galleryButton = find.byIcon(LucideIcons.image);
        expect(galleryButton, findsOneWidget);
        await tester.tap(galleryButton);
        await tester.pumpAndSettle();

        expect(fakeCropper.cropCallCount, 2);
        expect(fakeCropper.croppedPaths, ['img1.png', 'img2.png']);

        final preview = tester.widget<ForumAttachmentPreview>(
          find.byType(ForumAttachmentPreview),
        );
        expect(preview.imageUrls, ['img1.png_cropped', 'img2.png_cropped']);
      },
    );

    testWidgets(
      'picks image from camera, crops it, and attaches cropped file',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeImagePicker();
        final fakeCropper = _FakeAppImageCropper();
        fakePicker.cameraImage = XFile('camera.png');

        await tester.pumpWidget(
          buildScreen(picker: fakePicker, cropper: fakeCropper),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        final cameraButton = find.byIcon(LucideIcons.camera);
        expect(cameraButton, findsOneWidget);
        await tester.tap(cameraButton);
        await tester.pumpAndSettle();

        expect(fakeCropper.cropCallCount, 1);
        expect(fakeCropper.croppedPaths, ['camera.png']);

        final preview = tester.widget<ForumAttachmentPreview>(
          find.byType(ForumAttachmentPreview),
        );
        expect(preview.imageUrls, ['camera.png_cropped']);
      },
    );

    testWidgets('does not attach image if cropping is cancelled', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final fakePicker = _FakeImagePicker();
      final fakeCropper = _FakeAppImageCropper();
      fakePicker.cameraImage = XFile('camera.png');
      fakeCropper.onCrop = (_) => null; // cancelled

      await tester.pumpWidget(
        buildScreen(picker: fakePicker, cropper: fakeCropper),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Form'));
      await tester.pumpAndSettle();

      final cameraButton = find.byIcon(LucideIcons.camera);
      await tester.tap(cameraButton);
      await tester.pumpAndSettle();

      expect(fakeCropper.cropCallCount, 1);
      expect(find.byType(ForumAttachmentPreview), findsNothing);
    });

    testWidgets(
      'displays loading overlay while image cropping is in progress',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeImagePicker();
        final fakeCropper = _FakeAppImageCropper();
        fakePicker.cameraImage = XFile('camera.png');

        final completer = Completer<String?>();
        fakeCropper.onCrop = (_) => completer.future;

        await tester.pumpWidget(
          buildScreen(picker: fakePicker, cropper: fakeCropper),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        final cameraButton = find.byIcon(LucideIcons.camera);
        await tester.tap(cameraButton);
        await tester.pump(); // Start async cropping

        // Overlay should be visible
        expect(find.byType(AppLoadingIndicator), findsOneWidget);

        completer.complete('cropped.png');
        await tester.pumpAndSettle();

        // Overlay dismissed and image attached
        expect(find.byType(AppLoadingIndicator), findsNothing);
        expect(find.byType(ForumAttachmentPreview), findsOneWidget);
      },
    );

    testWidgets(
      'caps attachments at 3 when multi-image selection exceeds limit',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeImagePicker();
        final fakeCropper = _FakeAppImageCropper();
        fakePicker.multiImages = [
          XFile('1.png'),
          XFile('2.png'),
          XFile('3.png'),
          XFile('4.png'),
        ];

        await tester.pumpWidget(
          buildScreen(picker: fakePicker, cropper: fakeCropper),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        final galleryButton = find.byIcon(LucideIcons.image);
        await tester.tap(galleryButton);
        await tester.pumpAndSettle();

        // Should only process up to 3 attachments
        expect(fakeCropper.cropCallCount, 3);
        final preview = tester.widget<ForumAttachmentPreview>(
          find.byType(ForumAttachmentPreview),
        );
        expect(preview.imageUrls.length, 3);
      },
    );

    testWidgets(
      'aborts subsequent crops in batch if user cancels cropping an image',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final fakePicker = _FakeImagePicker();
        final fakeCropper = _FakeAppImageCropper();
        fakePicker.multiImages = [
          XFile('1.png'),
          XFile('2.png'),
          XFile('3.png'),
        ];

        // First image cropped, second image cancelled
        fakeCropper.onCrop = (path) {
          if (path.contains('1.png')) return '${path}_cropped';
          return null;
        };

        await tester.pumpWidget(
          buildScreen(picker: fakePicker, cropper: fakeCropper),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open Form'));
        await tester.pumpAndSettle();

        final galleryButton = find.byIcon(LucideIcons.image);
        await tester.tap(galleryButton);
        await tester.pumpAndSettle();

        // Stopped after canceling the 2nd image; 3rd image is never launched
        expect(fakeCropper.cropCallCount, 2);
        expect(fakeCropper.croppedPaths, ['1.png', '2.png']);

        final preview = tester.widget<ForumAttachmentPreview>(
          find.byType(ForumAttachmentPreview),
        );
        expect(preview.imageUrls, ['1.png_cropped']);
      },
    );
  });
}
