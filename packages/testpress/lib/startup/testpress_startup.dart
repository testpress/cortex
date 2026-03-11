import 'package:core/data/data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> initializeTestpress() async {
  await _loadEnv();

  AppConfig.configure(
    useMockData: _parseBool(dotenv.env['USE_MOCK']),
    apiBaseUrl: dotenv.env['API_BASE_URL'],
  );

  await SessionStorage.instance.initialize();
}

Future<void> _loadEnv() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Optional file: build-time defaults from AppConfig remain in effect.
  }
}

bool? _parseBool(String? value) {
  if (value == null) return null;
  final normalized = value.trim().toLowerCase();
  if (normalized == 'true') return true;
  if (normalized == 'false') return false;
  return null;
}
