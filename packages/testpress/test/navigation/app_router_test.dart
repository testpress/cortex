import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/app_router.dart';

void main() {
  group('buildPrimaryNavigationItems', () {
    test('keeps Profile as the default fifth destination', () {
      final items = buildPrimaryNavigationItems(isClientInfoEnabled: false);

      expect(items.length, 4);
      expect(items.last.id, '/profile');
      expect(items.last.label, 'Profile');
      expect(items.last.icon, LucideIcons.user);
    });

    test('switches the fifth destination to Info when enabled', () {
      final items = buildPrimaryNavigationItems(isClientInfoEnabled: true);

      expect(items.length, 4);
      expect(items.last.id, '/profile');
      expect(items.last.label, 'Info');
      expect(items.last.icon, LucideIcons.info);
      expect(items.last.iconBuilder, isNotNull);
    });
  });
}
