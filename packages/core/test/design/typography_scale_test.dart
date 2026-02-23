import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('DesignTypographyScale', () {
    test('defaults() returns standardized Tailwind-like scale', () {
      final scale = DesignTypographyScale.defaults();

      expect(scale.xs.fontSize, 12);
      expect(scale.sm.fontSize, 14);
      expect(scale.base.fontSize, 16);
      expect(scale.lg.fontSize, 18);
      expect(scale.xl.fontSize, 20);
      expect(scale.xl, isNotNull);
      expect(scale.xl2.fontSize, 24);
      expect(scale.xl3.fontSize, 30);
      expect(scale.xl4.fontSize, 36);
      expect(scale.xl5.fontSize, 48);
    });

    test('line heights match the scale specification', () {
      final scale = DesignTypographyScale.defaults();

      expect(scale.xs.height, 1.3);
      expect(scale.base.height, 1.5);
      expect(scale.xl5.height, 1.0);
    });
  });

  group('DesignTypography Composition', () {
    test('semantic roles are composed from scale tokens', () {
      final colors = DesignColors.light();
      final scale = DesignTypographyScale.defaults();
      final typography = DesignTypography.defaults(
        scale: scale,
        colors: colors,
      );

      // Body uses base
      expect(typography.body.fontSize, scale.base.fontSize);
      expect(typography.body.color, colors.textPrimary);

      // Headline uses xl2
      expect(typography.headline.fontSize, scale.xl2.fontSize);
      expect(typography.headline.fontWeight, FontWeight.w600);

      // Title uses xl
      expect(typography.title.fontSize, scale.xl.fontSize);
      expect(typography.title.fontWeight, FontWeight.w600);

      // Subtitle uses lg
      expect(typography.subtitle.fontSize, scale.lg.fontSize);
      expect(typography.subtitle.fontWeight, FontWeight.w500);

      // Caption uses xs
      expect(typography.caption.fontSize, scale.xs.fontSize);
      expect(typography.caption.color, colors.textSecondary);
    });

    test('optical tracking is applied correctly', () {
      final typography = DesignTypography.defaults();

      // Larger text (display) should have tighter tracking
      expect(typography.display.letterSpacing, -0.5);
      expect(typography.headline.letterSpacing, -0.25);

      // Normal text (body) should have null/default tracking
      expect(typography.body.letterSpacing, isNull);
    });
  });
}
