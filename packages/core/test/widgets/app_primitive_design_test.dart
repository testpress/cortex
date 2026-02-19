import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppButton Design Context', () {
    testWidgets('AppButton reads colors from Design context', (tester) async {
      final customConfig = DesignConfig(
        colors: const DesignColors(
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
        ),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: DesignMotion.defaults(),
        radius: DesignRadius.defaults(),
        subjectPalette: DesignSubjectPalette.light(),
        statusColors: DesignStatusColors.light(),
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
      // Since we added AppFocusable (which uses a Stack), we need to be more specific
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
      final customConfig = DesignConfig(
        colors: const DesignColors(
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
        ),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: DesignMotion.defaults(),
        radius: DesignRadius.defaults(),
        subjectPalette: DesignSubjectPalette.light(),
        statusColors: DesignStatusColors.light(),
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
      expect(text.style?.fontSize, 24); // headline size
    });
  });
}
