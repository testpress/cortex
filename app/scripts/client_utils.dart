// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CliArgs {
  final String configPath;
  final String apiBaseUrl;
  final String apiKey;
  CliArgs(this.configPath, this.apiBaseUrl, this.apiKey);
}

CliArgs parseArgs(List<String> args, String scriptName) {
  String? configPath;
  String? apiBaseUrl;
  String? apiKey;
  for (final arg in args) {
    if (arg.startsWith('--config=')) {
      configPath = arg.substring('--config='.length);
    } else if (arg.startsWith('--api-base-url=')) {
      apiBaseUrl = arg.substring('--api-base-url='.length);
    } else if (arg.startsWith('--api-key=')) {
      apiKey = arg.substring('--api-key='.length);
    }
  }

  if (configPath == null || apiBaseUrl == null || apiKey == null) {
    print('❌ Error: Missing required arguments.');
    print(
      'Usage: dart run app/scripts/$scriptName --config=config/your_client.json --api-base-url=https://your-api.com --api-key=your_key',
    );
    exit(1);
  }
  return CliArgs(configPath, apiBaseUrl, apiKey);
}

Future<Map<String, dynamic>> fetchRemoteConfig(
  String apiBaseUrl,
  String apiKey,
) async {
  final configEndpoint = '/api/v2.5/admin/android/app-config/';
  print('Fetching remote configuration from $apiBaseUrl$configEndpoint...');
  final response = await http.get(
    Uri.parse('$apiBaseUrl$configEndpoint'),
    headers: {'API-access-key': apiKey},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch remote config: ${response.statusCode}');
  }
  return jsonDecode(response.body);
}

Future<List<File>> downloadAssets(
  Map<String, dynamic> remoteConfig,
  String appDirPath,
) async {
  final iconUrl = remoteConfig['launcher_xxxhdpi'];
  final splashScreenUrl = remoteConfig['splash_screen'];
  final loginScreenUrl = remoteConfig['login_screen_image'];
  final List<File> downloadedFiles = [];

  final iconFile = await _downloadIcon(
    iconUrl,
    '$appDirPath/assets/images/temp_launcher.png',
  );
  downloadedFiles.add(iconFile);

  if (splashScreenUrl != null) {
    print('Downloading splash screen...');
    final splashFile = await _downloadIcon(
      splashScreenUrl,
      '$appDirPath/assets/images/splash_screen_image.png',
    );
    downloadedFiles.add(splashFile);
  }

  if (loginScreenUrl != null) {
    print('Downloading login screen image...');
    final loginFile = await _downloadIcon(
      loginScreenUrl,
      '$appDirPath/assets/images/login_screen_image.png',
    );
    downloadedFiles.add(loginFile);
  }

  return downloadedFiles;
}

Future<File> _downloadIcon(String url, String destPath) async {
  print('Downloading icon...');
  final response = await http.get(Uri.parse(url));
  final iconFile = File(destPath);
  if (!iconFile.parent.existsSync()) {
    iconFile.parent.createSync(recursive: true);
  }
  await iconFile.writeAsBytes(response.bodyBytes);
  return iconFile;
}

Future<void> updateBranding(
  String appName,
  String bundleId,
  String workingDir,
) async {
  print('Updating App Name and Bundle ID...');

  var result = await Process.run('dart', [
    'run',
    'rename',
    'setAppName',
    '--targets',
    'ios,android',
    '--value',
    appName,
  ], workingDirectory: workingDir);

  if (result.exitCode != 0) {
    throw Exception('Failed to update app name: ${result.stderr}');
  }

  result = await Process.run('dart', [
    'run',
    'rename',
    'setBundleId',
    '--targets',
    'ios,android',
    '--value',
    bundleId,
  ], workingDirectory: workingDir);

  if (result.exitCode != 0) {
    throw Exception('Failed to update bundle ID: ${result.stderr}');
  }
}

Future<File> generateNativeIcons(String workingDir) async {
  print('Generating native icons...');
  final iconConfig = File('$workingDir/flutter_launcher_icons.yaml');
  await iconConfig.writeAsString('''
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/temp_launcher.png"
''');

  final result = await Process.run('dart', [
    'run',
    'flutter_launcher_icons',
  ], workingDirectory: workingDir);
  if (result.exitCode != 0) {
    throw Exception('Failed to generate icons: ${result.stderr}');
  }
  return iconConfig;
}

Future<void> cleanupTempFiles(List<File> files) async {
  print('Cleaning up temporary files...');
  for (final file in files) {
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

Future<void> restoreGitChanges() async {
  print('🧹 Cleaning up native configuration changes...');
  await Process.run('git', ['checkout', '--', 'app/ios', 'app/android']);
  await Process.run('git', ['clean', '-fd', 'app/ios', 'app/android']);
  print('✨ Repository restored to original state.');
}
