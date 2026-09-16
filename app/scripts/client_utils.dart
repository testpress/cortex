// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Parses CLI arguments and environment variables.
CliArgs parseArgs(List<String> args, String scriptName) {
  String? configPath;
  String? apiBaseUrl;

  for (final arg in args) {
    if (arg.startsWith('--config=')) {
      configPath = arg.substring('--config='.length);
    } else if (arg.startsWith('--api-base-url=')) {
      apiBaseUrl = arg.substring('--api-base-url='.length);
    }
  }

  if (apiBaseUrl == null) {
    print('❌ Error: Missing required argument: --api-base-url');
    print(
      'Usage: CLIENT_API_KEY=your_key dart run app/scripts/$scriptName --api-base-url=https://your-api.com [--config=config/your_client.json]',
    );
    exit(1);
  }

  final apiKey = Platform.environment['CLIENT_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('❌ Error: Missing CLIENT_API_KEY environment variable.');
    print('Please provide it securely:');
    print('CLIENT_API_KEY="your_key" dart run app/scripts/$scriptName ...');
    exit(1);
  }

  return CliArgs(
    configPath: configPath,
    apiBaseUrl: apiBaseUrl,
    apiKey: apiKey,
  );
}

/// Runs the complete client setup, executes the given [action], and guarantees cleanup.
Future<void> runClientWorkflow(
  CliArgs cliArgs,
  Future<void> Function(ClientConfig config, String appDirPath) action,
) async {
  final downloadedFiles = <File>[];
  bool brandingUpdated = false;
  final appDir = Directory('app');

  try {
    final client = await fetchClientConfig(cliArgs.apiBaseUrl, cliArgs.apiKey);
    print('Applying configuration for: ${client.appName}');

    downloadedFiles.addAll(await downloadClientAssets(client, appDir.path));
    await updateNativeBranding(client.appName, client.bundleId, appDir.path);
    await updateIosGoogleConfig(appDir.path, client.iosClientId);
    await updateAndroidGoogleConfig(appDir.path, client.googleServicesJson);
    brandingUpdated = true;

    await updateZoomDependency(appDir.path, client.zoomEnabled);

    final iconConfig = await generateNativeIcons(appDir.path);
    if (iconConfig != null) {
      downloadedFiles.add(iconConfig);
    }

    await action(client, appDir.path);
  } catch (e) {
    print('❌ Error: $e');
  } finally {
    if (downloadedFiles.isNotEmpty) {
      await cleanupTempFiles(downloadedFiles);
    }
    if (brandingUpdated) {
      await restoreGitChanges();
    }
  }
}

/// Fetches remote configuration from `/api/v2.5/admin/android/app-config/`
/// and `/api/v2.3/settings/` concurrently.
Future<ClientConfig> fetchClientConfig(String apiBaseUrl, String apiKey) async {
  final normalizedBaseUrl = apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;

  print('Fetching remote configuration from $normalizedBaseUrl...');

  final results = await Future.wait([
    http.get(
      Uri.parse('$normalizedBaseUrl/api/v2.5/admin/android/app-config/'),
      headers: {'API-access-key': apiKey},
    ),
    http.get(Uri.parse('$normalizedBaseUrl/api/v2.3/settings/')),
  ]);

  final appConfigRes = results[0];
  final settingsRes = results[1];

  if (appConfigRes.statusCode != 200) {
    throw Exception('Failed to fetch app-config: ${appConfigRes.statusCode}');
  }

  final remoteConfig = jsonDecode(appConfigRes.body) as Map<String, dynamic>;
  String? logoUrl;

  if (settingsRes.statusCode == 200) {
    final settingsData = jsonDecode(settingsRes.body);
    logoUrl = settingsData['photo'] as String?;
  }

  return ClientConfig.fromRemote(
    remoteConfig: remoteConfig,
    logoUrl: logoUrl,
    apiBaseUrl: apiBaseUrl,
  );
}

/// Downloads client assets (launcher icon, splash, login, institute logo).
Future<List<File>> downloadClientAssets(
  ClientConfig config,
  String appDirPath,
) async {
  final downloadedFiles = <File>[];

  if (config.launcherIconUrl != null) {
    final iconFile = await _downloadFile(
      config.launcherIconUrl!,
      '$appDirPath/assets/images/temp_launcher.png',
    );
    if (iconFile != null) downloadedFiles.add(iconFile);
  }

  if (config.splashScreenUrl != null) {
    print('Downloading splash screen...');
    final splashFile = await _downloadFile(
      config.splashScreenUrl!,
      '$appDirPath/assets/images/splash_screen_image.png',
    );
    if (splashFile != null) downloadedFiles.add(splashFile);
  }

  if (config.loginScreenUrl != null) {
    print('Downloading login screen image...');
    final loginFile = await _downloadFile(
      config.loginScreenUrl!,
      '$appDirPath/assets/images/login_screen_image.png',
    );
    if (loginFile != null) downloadedFiles.add(loginFile);
  }

  if (config.logoUrl != null && config.logoUrl!.isNotEmpty) {
    print('Downloading institute logo...');
    final logoFile = await _downloadFile(
      config.logoUrl!,
      '$appDirPath/assets/images/institute_logo.png',
    );
    if (logoFile != null) downloadedFiles.add(logoFile);
  }

  return downloadedFiles;
}

Future<File?> _downloadFile(String url, String destPath) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    print(
      '⚠️ Failed to download asset from $url (HTTP ${response.statusCode}). Skipping...',
    );
    return null;
  }
  final file = File(destPath);
  if (!file.parent.existsSync()) {
    file.parent.createSync(recursive: true);
  }
  await file.writeAsBytes(response.bodyBytes);
  return file;
}

/// Updates native app name and bundle identifier.
Future<void> updateNativeBranding(
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

/// Updates iOS Google Sign-In config.
Future<void> updateIosGoogleConfig(
  String appDirPath,
  String iosClientId,
) async {
  print('Updating iOS Google Sign-In config...');
  String reversedClientId = '';
  if (iosClientId.isNotEmpty) {
    reversedClientId = iosClientId.split('.').reversed.join('.');
  }

  final configFile = File('$appDirPath/ios/Flutter/GoogleConfig.xcconfig');
  if (!configFile.parent.existsSync()) {
    configFile.parent.createSync(recursive: true);
  }
  await configFile.writeAsString('''
GOOGLE_IOS_CLIENT_ID = $iosClientId
GOOGLE_REVERSED_CLIENT_ID = $reversedClientId
''');
}

/// Updates Android Google Services configuration.
Future<void> updateAndroidGoogleConfig(
  String appDirPath,
  dynamic googleServices,
) async {
  if (googleServices != null) {
    print('Writing android/app/google-services.json...');
    final file = File('$appDirPath/android/app/google-services.json');
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    await file.writeAsString(jsonEncode(googleServices));
  } else {
    print('⚠️ google_services_json not found in remote config. Skipping...');
  }
}

/// Adds or removes Zoom SDK native dependency in pubspec.yaml.
Future<void> updateZoomDependency(String appDirPath, bool enabled) async {
  final pubspecFile = File('$appDirPath/pubspec.yaml');
  if (!pubspecFile.existsSync()) return;

  var content = await pubspecFile.readAsString();
  content = content.replaceAll(
    RegExp(r'\s*#?\s*zoom:\s*\n\s*#?\s*path:\s*\.\./packages/zoom\s*\n'),
    '\n',
  );

  if (enabled) {
    print('Enabling Zoom native SDK dependency in pubspec.yaml...');
    content = content.replaceAll(
      '  testpress:\n    path: ../packages/testpress',
      '  testpress:\n    path: ../packages/testpress\n  zoom:\n    path: ../packages/zoom',
    );
  } else {
    print('Zoom native SDK dependency is disabled.');
  }

  await pubspecFile.writeAsString(content);

  print('Syncing dependencies with flutter pub get...');
  final pubGetResult = await Process.run('flutter', [
    'pub',
    'get',
  ], workingDirectory: appDirPath);

  if (pubGetResult.exitCode != 0) {
    print('⚠️ Warning: flutter pub get failed: ${pubGetResult.stderr}');
  }
}

/// Generates native launcher icons from `temp_launcher.png`.
Future<File?> generateNativeIcons(String workingDir) async {
  final iconFile = File('$workingDir/assets/images/temp_launcher.png');
  if (!iconFile.existsSync()) {
    print('⚠️ Launcher icon not found. Skipping native icon generation.');
    return null;
  }

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

/// Cleans up temporary downloaded asset files.
Future<void> cleanupTempFiles(List<File> files) async {
  print('Cleaning up temporary files...');
  for (final file in files) {
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

/// Restores git working tree to a clean state.
Future<void> restoreGitChanges() async {
  print('🧹 Cleaning up native configuration changes...');
  await Process.run('git', [
    'checkout',
    '--',
    'app/ios',
    'app/android',
    'app/pubspec.yaml',
    'app/pubspec.lock',
  ]);
  await Process.run('git', ['clean', '-fd', 'app/ios', 'app/android']);
  print('✨ Repository restored to original state.');
}

/// Strongly typed container for remote client configuration.
class ClientConfig {
  final String appName;
  final String bundleId;
  final String apiBaseUrl;
  final String? logoUrl;
  final String? launcherIconUrl;
  final String? splashScreenUrl;
  final String? loginScreenUrl;
  final String? serverClientId;
  final String? primaryColor;
  final String appVersion;
  final String buildNumber;
  final bool zoomEnabled;
  final String iosClientId;
  final dynamic googleServicesJson;

  const ClientConfig({
    required this.appName,
    required this.bundleId,
    required this.apiBaseUrl,
    required this.logoUrl,
    required this.launcherIconUrl,
    required this.splashScreenUrl,
    required this.loginScreenUrl,
    required this.serverClientId,
    required this.primaryColor,
    required this.appVersion,
    required this.buildNumber,
    required this.zoomEnabled,
    required this.iosClientId,
    required this.googleServicesJson,
  });

  factory ClientConfig.fromRemote({
    required Map<String, dynamic> remoteConfig,
    required String? logoUrl,
    required String apiBaseUrl,
  }) {
    return ClientConfig(
      appName: remoteConfig['app_name']?.toString() ?? 'Testpress App',
      bundleId: remoteConfig['package_name']?.toString() ?? 'in.testpress.app',
      apiBaseUrl: apiBaseUrl,
      logoUrl: logoUrl,
      launcherIconUrl: remoteConfig['launcher_xxxhdpi']?.toString(),
      splashScreenUrl: remoteConfig['splash_screen']?.toString(),
      loginScreenUrl: remoteConfig['login_screen_image']?.toString(),
      serverClientId: remoteConfig['server_client_id']?.toString(),
      primaryColor: remoteConfig['primary_color']?.toString(),
      appVersion: remoteConfig['version']?.toString() ?? '0.1.0',
      buildNumber: remoteConfig['version_code']?.toString() ?? '1',
      zoomEnabled: remoteConfig['zoom_enabled'] as bool? ?? false,
      iosClientId: remoteConfig['ios_client_id']?.toString() ?? '',
      googleServicesJson: remoteConfig['google_services_json'],
    );
  }

  /// Builds the common `--dart-define` list for Flutter commands.
  List<String> toDartDefines({String? configPath, String appDirPath = 'app'}) {
    final defines = <String>['--dart-define=API_BASE_URL=$apiBaseUrl'];

    if (configPath != null && configPath.isNotEmpty) {
      defines.add('--dart-define-from-file=../$configPath');
    }

    final logoFile = File('$appDirPath/assets/images/institute_logo.png');
    if (logoFile.existsSync()) {
      defines.add(
        '--dart-define=INSTITUTE_LOGO_PATH=assets/images/institute_logo.png',
      );
    }

    if (appName.isNotEmpty) {
      defines.add('--dart-define=INSTITUTE_NAME=$appName');
    }

    if (serverClientId != null && serverClientId!.isNotEmpty) {
      defines.add('--dart-define=GOOGLE_SERVER_CLIENT_ID=$serverClientId');
    }

    if (primaryColor != null && primaryColor!.isNotEmpty) {
      defines.add('--dart-define=PRIMARY_COLOR=$primaryColor');
    }

    return defines;
  }
}

/// CLI arguments passed to the script.
class CliArgs {
  final String? configPath;
  final String apiBaseUrl;
  final String apiKey;

  const CliArgs({
    required this.configPath,
    required this.apiBaseUrl,
    required this.apiKey,
  });
}
