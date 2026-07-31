import 'package:core/data/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Playback speed settings', () {
    test('defaults rememberPlaybackSpeed to false and speed to null', () async {
      final settings = await db.getAppSettings();
      expect(settings.rememberPlaybackSpeed, isFalse);
      expect(settings.globalPlaybackSpeed, isNull);
    });

    test('toggle is persisted across reads', () async {
      await db.setRememberPlaybackSpeed(false);
      final settings = await db.getAppSettings();
      expect(settings.rememberPlaybackSpeed, isFalse);
    });

    test('global playback speed is persisted and updated', () async {
      await db.setGlobalPlaybackSpeed(2.0);
      var settings = await db.getAppSettings();
      expect(settings.globalPlaybackSpeed, 2.0);

      await db.setGlobalPlaybackSpeed(3.0);
      settings = await db.getAppSettings();
      expect(settings.globalPlaybackSpeed, 3.0);
    });

    test('toggle and speed persist together', () async {
      await db.setRememberPlaybackSpeed(true);
      await db.setGlobalPlaybackSpeed(1.5);
      final settings = await db.getAppSettings();
      expect(settings.rememberPlaybackSpeed, isTrue);
      expect(settings.globalPlaybackSpeed, 1.5);
    });
  });
}
