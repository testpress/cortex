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

      // Small text carries explicit height for readability in dense rows.
      expect(scale.xs.height, 1.2);
      expect(scale.sm.height, 1.4);
      // base atom is height-neutral (body semantic role sets 1.5 explicitly).
      expect(scale.base.height, isNull);
      // Heading atoms carry no height — rhythm comes from layout spacing.
      expect(scale.lg.height, isNull);
      expect(scale.xl.height, isNull);
      expect(scale.xl2.height, isNull);
      expect(scale.xl3.height, isNull);
      expect(scale.xl4.height, isNull);
      expect(scale.xl5.height, isNull);
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

      // Display uses xl3 (30px) at w700 — top of weight hierarchy.
      expect(typography.display.fontSize, scale.xl3.fontSize);
      expect(typography.display.fontWeight, FontWeight.w700);
      expect(typography.display.color, colors.textPrimary);

      // Body uses base (16px) with explicit 1.5 line height.
      expect(typography.body.fontSize, scale.base.fontSize);
      expect(typography.body.height, 1.5);
      expect(typography.body.color, colors.textPrimary);

      // Headline uses xl (20px) at w600.
      expect(typography.headline.fontSize, scale.xl.fontSize);
      expect(typography.headline.fontWeight, FontWeight.w600);

      // Title uses lg (18px) at w600.
      expect(typography.title.fontSize, scale.lg.fontSize);
      expect(typography.title.fontWeight, FontWeight.w600);

      // Subtitle uses sm (14px) at w400 — NOT a heading role.
      expect(typography.subtitle.fontSize, scale.sm.fontSize);
      expect(typography.subtitle.fontWeight, FontWeight.w400);
      expect(typography.subtitle.height, 1.4);

      // labelSmall: w600 ensures legibility at 12px.
      expect(typography.labelSmall.fontWeight, FontWeight.w600);
      expect(typography.labelSmall.height, 1.1);

      // Caption uses xs (12px) with positive tracking for legibility.
      expect(typography.caption.fontSize, scale.xs.fontSize);
      expect(typography.caption.color, colors.textSecondary);
      expect(typography.caption.height, 1.2);
    });

    test('optical tracking is applied correctly', () {
      final typography = DesignTypography.defaults();

      // display (30px) — tight tracking valid at this size.
      expect(typography.display.letterSpacing, -0.5);
      // headline (20px) — mild tracking, halved from the old -0.5.
      expect(typography.headline.letterSpacing, -0.25);
      // title (18px) — no tracking; 18px is too small for negative values.
      expect(typography.title.letterSpacing, isNull);
      // subtitle (14px) — no tracking; compression at this size is harmful.
      expect(typography.subtitle.letterSpacing, isNull);
      // body — no tracking.
      expect(typography.body.letterSpacing, isNull);
      // caption — slight positive tracking aids legibility at 12px.
      expect(typography.caption.letterSpacing, 0.4);
    });
  });
}
