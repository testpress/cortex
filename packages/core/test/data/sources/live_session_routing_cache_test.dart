import 'package:core/data/sources/live_session_routing_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LiveSessionRoutingCache', () {
    late LiveSessionRoutingCache cache;

    setUp(() {
      cache = LiveSessionRoutingCache(maxEntries: 3);
    });

    test('tracks and identifies 1-on-1 session IDs', () {
      expect(cache.isKnownOneOnOne('1'), isFalse);
      cache.markOneOnOne('1');
      expect(cache.isKnownOneOnOne('1'), isTrue);
    });

    test('tracks and identifies nonexistent session IDs', () {
      expect(cache.isNonexistent('99'), isFalse);
      cache.markNonexistent('99');
      expect(cache.isNonexistent('99'), isTrue);
    });

    test('caps entries at maxEntries and evicts oldest FIFO', () {
      cache.markOneOnOne('1');
      cache.markOneOnOne('2');
      cache.markOneOnOne('3');
      expect(cache.isKnownOneOnOne('1'), isTrue);

      // Adding 4th item should evict '1'
      cache.markOneOnOne('4');
      expect(cache.isKnownOneOnOne('1'), isFalse);
      expect(cache.isKnownOneOnOne('2'), isTrue);
      expect(cache.isKnownOneOnOne('3'), isTrue);
      expect(cache.isKnownOneOnOne('4'), isTrue);
    });

    test('caps nonexistent entries at maxEntries and evicts oldest FIFO', () {
      cache.markNonexistent('10');
      cache.markNonexistent('20');
      cache.markNonexistent('30');
      expect(cache.isNonexistent('10'), isTrue);

      // Adding 4th item should evict '10'
      cache.markNonexistent('40');
      expect(cache.isNonexistent('10'), isFalse);
      expect(cache.isNonexistent('20'), isTrue);
      expect(cache.isNonexistent('30'), isTrue);
      expect(cache.isNonexistent('40'), isTrue);
    });

    test(
      'does not evict entries when re-marking an already cached id at capacity',
      () {
        final smallCache = LiveSessionRoutingCache(maxEntries: 2);

        // Marking a, b, then a again should leave both a and b in cache
        smallCache.markOneOnOne('a');
        smallCache.markOneOnOne('b');
        smallCache.markOneOnOne('a');
        expect(smallCache.isKnownOneOnOne('a'), isTrue);
        expect(smallCache.isKnownOneOnOne('b'), isTrue);

        smallCache.markNonexistent('x');
        smallCache.markNonexistent('y');
        smallCache.markNonexistent('x');
        expect(smallCache.isNonexistent('x'), isTrue);
        expect(smallCache.isNonexistent('y'), isTrue);
      },
    );

    test('clear wipes both caches', () {
      cache.markOneOnOne('1');
      cache.markNonexistent('2');
      cache.clear();

      expect(cache.isKnownOneOnOne('1'), isFalse);
      expect(cache.isNonexistent('2'), isFalse);
    });
  });
}
