import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testpress/navigation/app_router.dart';

void main() {
  group('buildPrimaryNavigationItems', () {
    test('keeps Profile as the default fifth destination', () {
      final items = buildPrimaryNavigationItems(isInfoEnabled: false);

      expect(items.length, 4);
      expect(items.last.id, '/profile');
      expect(items.last.label, 'Profile');
      expect(items.last.icon, LucideIcons.user);
    });

    test('adds Info as the fourth destination when enabled', () {
      final items = buildPrimaryNavigationItems(isInfoEnabled: true);


      expect(items.length, 5);
      expect(items[3].id, '/info');
      expect(items[3].label, 'Info');
      expect(items[3].icon, LucideIcons.youtube);

      expect(items[4].id, '/profile');
      expect(items[4].label, 'Profile');
    });
  });
}
