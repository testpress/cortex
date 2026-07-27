/// Shared visual parameters for the watermark.
///
/// Used by both the in-app [WatermarkOverlay] widget and the
/// [PdfDownloadService] stamping pipeline to keep both renderings
/// visually consistent.
abstract final class WatermarkParams {
  /// Clockwise rotation angle in degrees applied to the watermark text.
  static const double angleDeg = -60.0;

  /// Font size used for the watermark text (Flutter logical pixels for the
  /// overlay; PDF points for the stamped download — same value, same intent).
  static const double fontSize = 70.0;

  /// Opacity of the watermark text (0.0 = invisible, 1.0 = fully opaque).
  static const double opacity = 0.15;
}
