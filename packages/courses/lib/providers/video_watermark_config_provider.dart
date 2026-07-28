import 'package:core/data/data.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class VideoWatermarkConfigFactory {
  static WatermarkConfig? create(
    VideoWatermarkType? type,
    VideoWatermarkPosition? position,
    String watermarkText,
    double fontSize,
  ) {
    return switch (type) {
      null => null,
      VideoWatermarkType.dynamic => WatermarkConfig(
          text: watermarkText,
          opacity: 0.5,
          textSize: fontSize,
          y: 50,
          animation: WatermarkAnimation(
            type: WatermarkAnimationType.pingPong,
          ),
        ),
      VideoWatermarkType.static => WatermarkConfig(
          text: watermarkText,
          opacity: 0.5,
          textSize: fontSize,
          x: _resolveCoordinates(position).x,
          y: _resolveCoordinates(position).y,
        ),
    };
  }

  static ({int x, int y}) _resolveCoordinates(
      VideoWatermarkPosition? position) {
    return switch (position) {
      VideoWatermarkPosition.topLeft => (x: 10, y: 10),
      VideoWatermarkPosition.topRight => (x: 90, y: 10),
      VideoWatermarkPosition.bottomLeft => (x: 10, y: 90),
      VideoWatermarkPosition.bottomRight => (x: 90, y: 90),
      VideoWatermarkPosition.middle || null => (x: 50, y: 50),
    };
  }
}

final videoWatermarkConfigProvider =
    Provider.family<WatermarkConfig?, double>((ref, fontSize) {
  final settings = ref.watch(instituteSettingsProvider);
  if (settings?.videoWatermarkType == null) {
    return null;
  }

  final userAsync = ref.watch(userProvider);
  if (userAsync.isLoading && !userAsync.hasValue) {
    return null;
  }

  final user = userAsync.value;
  String watermarkText = user?.username ?? '';
  if (watermarkText.trim().isEmpty) {
    watermarkText = 'user';
  }

  return VideoWatermarkConfigFactory.create(
    settings?.videoWatermarkType,
    settings?.videoWatermarkPosition,
    watermarkText,
    fontSize,
  );
});
