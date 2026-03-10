import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppButton Design Context', () {
    testWidgets('AppButton reads colors from Design context', (tester) async {
      const colors = DesignColors(
        primary: Color(0xFF00FF00), // Green instead of indigo
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFE0E7FF),
        onPrimaryContainer: Color(0xFF1E1B4B),
        surface: Color(0xFFF9FAFB),
        onSurface: Color(0xFF1F2937),
        surfaceVariant: Color(0xFFF3F4F6),
        onSurfaceVariant: Color(0xFF6B7280),
        card: Color(0xFFFFFFFF),
        onCard: Color(0xFF111827),
        border: Color(0xFFE5E7EB),
        divider: Color(0xFFF3F4F6),
        success: Color(0xFF10B981),
        onSuccess: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
        onError: Color(0xFFFFFFFF),
        warning: Color(0xFFF59E0B),
        onWarning: Color(0xFFFFFFFF),
        textPrimary: Color(0xFF111827),
        textSecondary: Color(0xFF6B7280),
        textTertiary: Color(0xFF9CA3AF),
        textInverse: Color(0xFFFFFFFF),
        progressBackground: Color(0xFFE5E7EB),
        progressForeground: Color(0xFF6366F1),
        focus: Color(0x666366F1),
        canvas: Color(0xFFF9FAFB),
        accent1: Color(0xFF9333EA),
        accent2: Color(0xFF2563EB),
        accent3: Color(0xFFF59E0B),
        accent4: Color(0xFF10B981),
        accent5: Color(0xFFEF4444),
        accent6: Color(0xFF06B6D4),
        rank1: Color(0xFFFBBF24),
        rank2: Color(0xFFCBD5E1),
        rank3: Color(0xFFFB923C),
        rankDefault: Color(0xFF94A3B8),
        overlay: Color(0x8A000000),
        shadow: Color(0x33000000),
      );

      final customConfig = DesignConfig.light().copyWith(
        colors: colors,
        typography: DesignTypography.defaults(colors: colors),
      );

      await tester.pumpWidget(
        DesignProvider(
          config: customConfig,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppButton.primary(label: 'Test', onPressed: () {}),
          ),
        ),
      );

      // Find the Container that has the background color
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is Container &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color ==
                    const Color(0xFF00FF00),
          ),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF00FF00)); // Custom green
    });
  });

  group('AppText Design Context', () {
    testWidgets('AppText reads colors from Design context', (tester) async {
      const colors = DesignColors(
        primary: Color(0xFF6366F1),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFE0E7FF),
        onPrimaryContainer: Color(0xFF1E1B4B),
        surface: Color(0xFFF9FAFB),
        onSurface: Color(0xFF1F2937),
        surfaceVariant: Color(0xFFF3F4F6),
        onSurfaceVariant: Color(0xFF6B7280),
        card: Color(0xFFFFFFFF),
        onCard: Color(0xFF111827),
        border: Color(0xFFE5E7EB),
        divider: Color(0xFFF3F4F6),
        success: Color(0xFF10B981),
        onSuccess: Color(0xFFFFFFFF),
        error: Color(0xFFEF4444),
        onError: Color(0xFFFFFFFF),
        warning: Color(0xFFF59E0B),
        onWarning: Color(0xFFFFFFFF),
        textPrimary: Color(0xFFFF0000), // Red instead of default
        textSecondary: Color(0xFF6B7280),
        textTertiary: Color(0xFF9CA3AF),
        textInverse: Color(0xFFFFFFFF),
        progressBackground: Color(0xFFE5E7EB),
        progressForeground: Color(0xFF6366F1),
        focus: Color(0x666366F1),
        canvas: Color(0xFFF9FAFB),
        accent1: Color(0xFF9333EA),
        accent2: Color(0xFF2563EB),
        accent3: Color(0xFFF59E0B),
        accent4: Color(0xFF10B981),
        accent5: Color(0xFFEF4444),
        accent6: Color(0xFF06B6D4),
        rank1: Color(0xFFFBBF24),
        rank2: Color(0xFFCBD5E1),
        rank3: Color(0xFFFB923C),
        rankDefault: Color(0xFF94A3B8),
        overlay: Color(0x8A000000),
        shadow: Color(0x33000000),
      );

      final customConfig = DesignConfig.light().copyWith(
        colors: colors,
        typography: DesignTypography.defaults(colors: colors),
      );

      await tester.pumpWidget(
        DesignProvider(
          config: customConfig,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: AppText.headline('Test'),
          ),
        ),
      );

      final text = tester.widget<Text>(find.byType(Text));
      expect(text.style?.color, const Color(0xFFFF0000)); // Custom red
      expect(text.style?.fontSize, 20); // headline uses xl (20)
    });
  });

  group('Design Token Constraints', () {
    test('textPrimary luminance is <= 0.15', () {
      final design = DesignConfig.light();
      expect(
        design.colors.textPrimary.computeLuminance(),
        lessThanOrEqualTo(0.15),
      );
    });

    test(
      'textSecondary is at least 20% closer to surface than textPrimary',
      () {
        final design = DesignConfig.light();
        final pLum = design.colors.textPrimary.computeLuminance();
        final sLum = design.colors.textSecondary.computeLuminance();
        final surfLum = design.colors.surface.computeLuminance();

        final pDist = (surfLum - pLum).abs();
        final sDist = (surfLum - sLum).abs();

        // Secondary must be at least 20% closer: sDist <= pDist * 0.8
        expect(sDist, lessThanOrEqualTo(pDist * 0.8));
      },
    );

    test('card radius is exactly 2x baseRadius (8.0)', () {
      final design = DesignConfig.light();
      // Radius.card is a BorderRadius, we need to check the corner radius
      final radius = design.radius.card.topLeft.x;
      expect(radius, 16.0);
    });

    test('spacing tokens belong to the allowed atomic set', () {
      final design = DesignConfig.light();
      final allowedSet = {4.0, 8.0, 12.0, 16.0, 24.0, 32.0, 40.0, 48.0, 64.0};

      expect(allowedSet.contains(design.spacing.xs), isTrue);
      expect(allowedSet.contains(design.spacing.sm), isTrue);
      expect(allowedSet.contains(design.spacing.md), isTrue);
      expect(allowedSet.contains(design.spacing.lg), isTrue);
      expect(allowedSet.contains(design.spacing.xl), isTrue);
      expect(allowedSet.contains(design.spacing.cardPadding), isTrue);
      expect(allowedSet.contains(design.spacing.sectionGap), isTrue);
    });
  });
}
