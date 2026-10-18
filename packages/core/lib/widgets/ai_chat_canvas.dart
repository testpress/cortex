import 'package:flutter/widgets.dart';

import '../design/design_config.dart';

/// Canvas color behind the AI chat.
///
/// Sits between the card and page surface tokens so the white assistant card
/// and the tinted user bubble both stay distinguishable on it.
Color aiChatCanvasColor(DesignConfig design) {
  return Color.lerp(design.colors.card, design.colors.surface, 0.3)!;
}
