import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core/utils/device_orientation_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DeviceOrientationHelper.isTablet', () {
    test('returns false for phone dimensions (< 600dp shortest side)', () {
      // iPhone 14/15/16 portrait: 393 x 852
      expect(DeviceOrientationHelper.isTablet(const Size(393, 852)), isFalse);
      // iPhone 14/15/16 landscape: 852 x 393
      expect(DeviceOrientationHelper.isTablet(const Size(852, 393)), isFalse);
      // Compact Android: 360 x 800
      expect(DeviceOrientationHelper.isTablet(const Size(360, 800)), isFalse);
      // Large phone: 428 x 926
      expect(DeviceOrientationHelper.isTablet(const Size(428, 926)), isFalse);
      // Just under breakpoint: 599 x 900
      expect(DeviceOrientationHelper.isTablet(const Size(599, 900)), isFalse);
    });

    test('returns true for tablet dimensions (>= 600dp shortest side)', () {
      // 7-inch tablet: 600 x 960
      expect(DeviceOrientationHelper.isTablet(const Size(600, 960)), isTrue);
      // iPad mini: 744 x 1133
      expect(DeviceOrientationHelper.isTablet(const Size(744, 1133)), isTrue);
      // iPad Air / Pro: 820 x 1180
      expect(DeviceOrientationHelper.isTablet(const Size(820, 1180)), isTrue);
      // iPad Pro 12.9": 1024 x 1366
      expect(DeviceOrientationHelper.isTablet(const Size(1024, 1366)), isTrue);
    });
  });

  group('DeviceOrientationHelper.configureOrientations', () {
    test('locks phone dimensions to portrait-only', () async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            log.add(call);
            return null;
          });

      await DeviceOrientationHelper.configureOrientations(const Size(393, 852));

      expect(log, isNotEmpty);
      final setOrientationsCall = log.firstWhere(
        (c) => c.method == 'SystemChrome.setPreferredOrientations',
      );
      expect(
        setOrientationsCall.arguments,
        equals(['DeviceOrientation.portraitUp']),
      );
    });

    test('allows portrait and landscape on tablet dimensions', () async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            log.add(call);
            return null;
          });

      await DeviceOrientationHelper.configureOrientations(
        const Size(820, 1180),
      );

      expect(log, isNotEmpty);
      final setOrientationsCall = log.firstWhere(
        (c) => c.method == 'SystemChrome.setPreferredOrientations',
      );
      expect(
        setOrientationsCall.arguments,
        equals([
          'DeviceOrientation.portraitUp',
          'DeviceOrientation.portraitDown',
          'DeviceOrientation.landscapeLeft',
          'DeviceOrientation.landscapeRight',
        ]),
      );
    });

    test('allowVideoOrientations allows portrait and landscape', () async {
      final log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            log.add(call);
            return null;
          });

      await DeviceOrientationHelper.allowVideoOrientations();

      expect(log, isNotEmpty);
      final setOrientationsCall = log.firstWhere(
        (c) => c.method == 'SystemChrome.setPreferredOrientations',
      );
      expect(
        setOrientationsCall.arguments,
        equals([
          'DeviceOrientation.portraitUp',
          'DeviceOrientation.landscapeLeft',
          'DeviceOrientation.landscapeRight',
        ]),
      );
    });
  });
}
