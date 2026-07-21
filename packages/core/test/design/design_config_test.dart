import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/design/design_config.dart';

void main() {
  group('DesignColors Parsing and Calculation Tests', () {
    test('parseColor handles standard hex codes correctly', () {
      expect(DesignColors.parseColor('FFFFFF'), const Color(0xFFFFFFFF));
      expect(DesignColors.parseColor('000000'), const Color(0xFF000000));
      expect(DesignColors.parseColor('818CF8'), const Color(0xFF818CF8));
    });

    test('parseColor handles hex codes with # prefix', () {
      expect(DesignColors.parseColor('#FFFFFF'), const Color(0xFFFFFFFF));
      expect(DesignColors.parseColor('#818CF8'), const Color(0xFF818CF8));
    });

    test('parseColor handles hex codes with 0x prefix', () {
      expect(DesignColors.parseColor('0xFFFFFF'), const Color(0xFFFFFFFF));
      expect(DesignColors.parseColor('0x818CF8'), const Color(0xFF818CF8));
      expect(DesignColors.parseColor('0XFFFFFF'), const Color(0xFFFFFFFF));
    });

    test('parseColor returns null for invalid formats', () {
      expect(
        DesignColors.parseColor('FFF'),
        isNull,
      ); // 3-digit hex not supported
      expect(DesignColors.parseColor('#FFF'), isNull);
      expect(DesignColors.parseColor('invalid'), isNull);
      expect(DesignColors.parseColor(''), isNull);
    });

    test('lighten algorithm works correctly', () {
      const baseColor = Color(0xFF000000); // Black
      final lightened = DesignColors.lighten(baseColor, 0.5);

      // If we lighten black by 50%, it should be exactly halfway to white (127 in RGB)
      expect(lightened.r, closeTo(127.5 / 255.0, 0.05));
      expect(lightened.g, closeTo(127.5 / 255.0, 0.05));
      expect(lightened.b, closeTo(127.5 / 255.0, 0.05));
    });

    test('darken algorithm works correctly', () {
      const baseColor = Color(0xFFFFFFFF); // White
      final darkened = DesignColors.darken(baseColor, 0.5);

      // If we darken white by 50%, it should be exactly halfway to black (127 in RGB)
      expect(darkened.r, closeTo(127.5 / 255.0, 0.05));
      expect(darkened.g, closeTo(127.5 / 255.0, 0.05));
      expect(darkened.b, closeTo(127.5 / 255.0, 0.05));
    });
  });
}
