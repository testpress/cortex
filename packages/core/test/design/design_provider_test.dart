import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('DesignProvider', () {
    testWidgets('Design.of(context) returns injected config', (tester) async {
      // Create custom config with distinct values
      final customConfig = DesignConfig(
        colors: const DesignColors(
          primary: Color(0xFFFF0000), // Red instead of indigo
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE0E7FF),
          onPrimaryContainer: Color(0xFF1E1B4B),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1F2937),
          surfaceVariant: Color(0xFFF9FAFB),
          onSurfaceVariant: Color(0xFF6B7280),
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
        ),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: DesignMotion.defaults(),
        radius: DesignRadius.defaults(),
      );

      late DesignConfig capturedConfig;

      await tester.pumpWidget(
        DesignProvider(
          config: customConfig,
          child: Builder(
            builder: (context) {
              capturedConfig = Design.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedConfig.colors.primary, const Color(0xFFFF0000));
      expect(capturedConfig.spacing.md, 16.0);
      expect(capturedConfig.typography.body.fontSize, 16);
    });

    testWidgets('Design.of(context) asserts when provider missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(() => Design.of(context), throwsA(isA<AssertionError>()));
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('DesignProvider updates trigger rebuilds', (tester) async {
      final config1 = DesignConfig.defaults();
      final config2 = DesignConfig(
        colors: const DesignColors(
          primary: Color(0xFF00FF00), // Green
          onPrimary: Color(0xFFFFFFFF),
          primaryContainer: Color(0xFFE0E7FF),
          onPrimaryContainer: Color(0xFF1E1B4B),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1F2937),
          surfaceVariant: Color(0xFFF9FAFB),
          onSurfaceVariant: Color(0xFF6B7280),
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
        ),
        spacing: DesignSpacing.defaults(),
        typography: DesignTypography.defaults(),
        motion: DesignMotion.defaults(),
        radius: DesignRadius.defaults(),
      );

      late DesignConfig capturedConfig;

      await tester.pumpWidget(
        DesignProvider(
          config: config1,
          child: Builder(
            builder: (context) {
              capturedConfig = Design.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedConfig.colors.primary, const Color(0xFF6366F1)); // Indigo

      // Update config
      await tester.pumpWidget(
        DesignProvider(
          config: config2,
          child: Builder(
            builder: (context) {
              capturedConfig = Design.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(capturedConfig.colors.primary, const Color(0xFF00FF00)); // Green
    });
  });
}
