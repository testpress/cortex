import 'package:flutter_test/flutter_test.dart';
import 'package:courses/widgets/lesson_detail/teams_web_view.dart';

TeamsAutoJoinHandler _buildHandler({
  void Function()? onJoinSuccess,
  void Function()? onJoinTimeout,
  void Function()? onLoadingStart,
  void Function()? onLoadingEnd,
}) {
  return TeamsAutoJoinHandler(
    onJoinSuccess: onJoinSuccess,
    onJoinTimeout: onJoinTimeout,
    onLoadingStart: onLoadingStart,
    onLoadingEnd: onLoadingEnd,
  );
}

void main() {
  group('TeamsAutoJoinHandler — URL gate detection', () {
    const gateUrls = [
      'https://teams.microsoft.com/l/meetup-join/19%3A/thread',
      'https://teams.microsoft.com/v2/?launcher=false',
      'https://teams.microsoft.com/meet/join/abc123',
      'https://TEAMS.MICROSOFT.COM/L/PRE-JOIN/abc',
    ];

    const nonGateUrls = [
      'https://teams.microsoft.com/meet/lobby',
      'https://teams.microsoft.com/v2/#/meeting',
      'https://example.com/join',
      'https://zoom.us/j/123456',
      '',
    ];

    for (final url in gateUrls) {
      test('onPageStarted triggers loading for gate URL: $url', () {
        bool loadingStarted = false;
        final handler =
            _buildHandler(onLoadingStart: () => loadingStarted = true);
        handler.onPageStarted(url);
        expect(loadingStarted, isTrue);
      });
    }

    test('onPageStarted does NOT trigger loading after join is complete', () {
      bool loadingStarted = false;
      final handler =
          _buildHandler(onLoadingStart: () => loadingStarted = true);
      handler.simulateJsMessage('onButtonClicked');
      loadingStarted = false;
      handler.onPageStarted(gateUrls.first);
      expect(loadingStarted, isFalse);
    });

    for (final url in nonGateUrls) {
      test('onPageFinished calls onLoadingEnd for non-gate URL: "$url"', () {
        bool loadingEnded = false;
        final handler = _buildHandler(onLoadingEnd: () => loadingEnded = true);
        handler.onPageFinished(url);
        expect(loadingEnded, isTrue);
      });
    }
  });

  group('TeamsAutoJoinHandler — JS message handling', () {
    test('onButtonClicked: loader stays up until next page finishes', () {
      bool loadingEnded = false;
      bool joinSucceeded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        onJoinSuccess: () => joinSucceeded = true,
      );

      handler.simulateJsMessage('onButtonClicked');

      // Loader must NOT drop immediately after button click
      expect(loadingEnded, isFalse);
      expect(joinSucceeded, isFalse);

      // Simulate lobby page finishing load
      handler.onPageFinished('https://teams.microsoft.com/meet/lobby');

      expect(loadingEnded, isTrue);
      expect(joinSucceeded, isTrue);
    });

    test('onLobbyDetected: drops loader and fires onJoinSuccess immediately',
        () {
      bool loadingEnded = false;
      bool joinSucceeded = false;
      final handler = _buildHandler(
        onLoadingEnd: () => loadingEnded = true,
        onJoinSuccess: () => joinSucceeded = true,
      );

      handler.simulateJsMessage('onLobbyDetected');

      expect(loadingEnded, isTrue);
      expect(joinSucceeded, isTrue);
    });

    test('onAutoJoinTimeout fires onJoinTimeout', () {
      bool timedOut = false;
      final handler = _buildHandler(onJoinTimeout: () => timedOut = true);
      handler.simulateJsMessage('onAutoJoinTimeout');
      expect(timedOut, isTrue);
    });

    test('messages after dispose() are silently ignored', () {
      bool joinSucceeded = false;
      final handler = _buildHandler(onJoinSuccess: () => joinSucceeded = true);
      handler.dispose();
      handler.simulateJsMessage('onLobbyDetected');
      expect(joinSucceeded, isFalse);
    });
  });
}
