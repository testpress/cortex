import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../design/design_provider.dart';
import '../../localization/l10n_helper.dart';

/// Service to invoke image cropping via [ImageCropper].
class AppImageCropper {
  final ImageCropper _cropper;

  /// Creates an [AppImageCropper] with an optional [cropper] for testing.
  AppImageCropper([ImageCropper? cropper])
    : _cropper = cropper ?? ImageCropper();

  /// Crops the image at [imagePath] using [ImageCropper].
  ///
  /// Returns the path to the cropped file, or `null` if the user cancels or the file is missing.
  Future<String?> crop(
    BuildContext context, {
    required String imagePath,
  }) async {
    final design = Design.of(context);
    final l10n = L10n.of(context);
    final file = File(imagePath);
    final exists = await file.exists();

    if (!exists) {
      return null;
    }

    try {
      final croppedFile = await _cropper.cropImage(
        sourcePath: imagePath,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: l10n.cropImage,
            toolbarColor: design.colors.surface,
            toolbarWidgetColor: design.colors.textPrimary,
            activeControlsWidgetColor: design.colors.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: l10n.cropImage),
        ],
      );

      return croppedFile?.path;
    } catch (_) {
      return null;
    }
  }
}
