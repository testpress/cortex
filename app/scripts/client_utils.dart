// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Formats and prints colorized CLI messages.
class Logger {
  static const _reset = '\x1B[0m';
  static const _cyan = '\x1B[36m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';

  static void info(String message) {
    print('$_cyan[INFO]$_reset $message');
  }

  static void success(String message) {
    print('$_green[SUCCESS]$_reset $message');
  }

  static void warn(String message) {
    print('$_yellow[WARN]$_reset $message');
  }

  static void error(String message) {
    print('$_red[ERROR]$_reset $message');
  }
}

/// Parses CLI arguments and environment variables.
CliArgs parseArgs(List<String> args, String scriptName) {
  String? configPath;
  String? apiBaseUrl;
  String platform = 'android';
  String mode = 'debug';
  final extraArgs = <String>[];

  for (final arg in args) {
    if (arg.startsWith('--config=')) {
      configPath = arg.substring('--config='.length);
    } else if (arg.startsWith('--api-base-url=')) {
      apiBaseUrl = arg.substring('--api-base-url='.length);
    } else if (arg.startsWith('--platform=')) {
      platform = arg.substring('--platform='.length).toLowerCase();
    } else if (arg.startsWith('--mode=')) {
      mode = arg.substring('--mode='.length).toLowerCase();
    } else if (arg == '--release' || arg == '--profile' || arg == '--debug') {
      mode = arg.substring(2).toLowerCase();
    } else {
      extraArgs.add(arg);
    }
  }

  if (platform != 'android' && platform != 'ios') {
    Logger.error(
      'Invalid --platform "$platform". Supported values are "android" or "ios".',
    );
    exit(1);
  }

  if (mode != 'debug' && mode != 'profile' && mode != 'release') {
    Logger.error(
      'Invalid --mode "$mode". Supported values are "debug", "profile", or "release".',
    );
    exit(1);
  }

  if (apiBaseUrl == null) {
    Logger.error('Missing required argument: --api-base-url');
    print(
      'Usage: CLIENT_API_KEY=your_key dart run app/scripts/$scriptName --api-base-url=https://your-api.com [--platform=android|ios] [--mode=debug|profile|release] [--config=config/your_client.json] [extra flutter args...]',
    );
    exit(1);
  }

  final apiKey = Platform.environment['CLIENT_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    Logger.error('Missing CLIENT_API_KEY environment variable.');
    print('Please provide it securely:');
    print('CLIENT_API_KEY="your_key" dart run app/scripts/$scriptName ...');
    exit(1);
  }

  return CliArgs(
    configPath: configPath,
    apiBaseUrl: apiBaseUrl,
    apiKey: apiKey,
    platform: platform,
    mode: mode,
    extraArgs: extraArgs,
  );
}

/// Finds the first connected device ID matching the specified platform ('android' or 'ios').
Future<String?> findDeviceIdForPlatform(String platform) async {
  try {
    final result = await Process.run('flutter', ['devices', '--machine']);
    if (result.exitCode == 0) {
      final devices = jsonDecode(result.stdout as String) as List<dynamic>;
      for (final device in devices) {
        final targetPlatform =
            device['targetPlatform']?.toString().toLowerCase() ?? '';
        final isSupported = device['isSupported'] == true;
        if (isSupported && targetPlatform.startsWith(platform.toLowerCase())) {
          return device['id']?.toString();
        }
      }
    }
  } catch (e) {
    Logger.warn('Failed to query flutter devices: $e');
  }
  return null;
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
    Logger.info(
      'Applying configuration for: ${client.appName} (Platform: ${cliArgs.platform})',
    );

    downloadedFiles.addAll(
      await downloadClientAssets(
        client,
        appDir.path,
        platform: cliArgs.platform,
      ),
    );

    await updateNativeBranding(
      appName: client.appName,
      androidPackageName: client.packageName,
      iosBundleId: client.bundleId,
      platform: cliArgs.platform,
      workingDir: appDir.path,
    );

    if (cliArgs.platform == 'ios') {
      await updateIosGoogleConfig(appDir.path, client.iosClientId);
    } else {
      await updateAndroidGoogleConfig(appDir.path, client.googleServicesJson);
    }
    brandingUpdated = true;

    await updateZoomDependency(appDir.path, client.zoomEnabled);

    final iconConfig = await generateNativeIcons(
      appDir.path,
      platform: cliArgs.platform,
    );
    if (iconConfig != null) {
      downloadedFiles.add(iconConfig);
    }

    await action(client, appDir.path);
  } catch (e) {
    Logger.error('$e');
  } finally {
    if (downloadedFiles.isNotEmpty) {
      await cleanupTempFiles(downloadedFiles);
    }
    if (brandingUpdated) {
      await restoreGitChanges(platform: cliArgs.platform);
    }
  }
}

/// Fetches remote configuration from `/api/v2.5/admin/cortex/app-config/`
/// and `/api/v2.3/settings/` concurrently.
Future<ClientConfig> fetchClientConfig(String apiBaseUrl, String apiKey) async {
  final normalizedBaseUrl = apiBaseUrl.endsWith('/')
      ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
      : apiBaseUrl;

  Logger.info('Fetching remote configuration from $normalizedBaseUrl...');

  final results = await Future.wait([
    http.get(
      Uri.parse('$normalizedBaseUrl/api/v2.5/admin/cortex/app-config/'),
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

/// Downloads client assets (launcher icon, splash, login, institute logo, google plist).
Future<List<File>> downloadClientAssets(
  ClientConfig config,
  String appDirPath, {
  String platform = 'android',
}) async {
  final downloadedFiles = <File>[];

  if (config.launcherIconUrl != null) {
    final iconFile = await _downloadFile(
      config.launcherIconUrl!,
      '$appDirPath/assets/images/temp_launcher.png',
    );
    if (iconFile != null) downloadedFiles.add(iconFile);
  }

  if (config.splashScreenUrl != null) {
    Logger.info('Downloading splash screen...');
    final splashFile = await _downloadFile(
      config.splashScreenUrl!,
      '$appDirPath/assets/images/splash_screen_image.png',
    );
    if (splashFile != null) downloadedFiles.add(splashFile);
  }

  if (config.loginScreenUrl != null) {
    Logger.info('Downloading login screen image...');
    final loginFile = await _downloadFile(
      config.loginScreenUrl!,
      '$appDirPath/assets/images/login_screen_image.png',
    );
    if (loginFile != null) downloadedFiles.add(loginFile);
  }

  if (config.logoUrl != null && config.logoUrl!.isNotEmpty) {
    Logger.info('Downloading institute logo...');
    final logoFile = await _downloadFile(
      config.logoUrl!,
      '$appDirPath/assets/images/institute_logo.png',
    );
    if (logoFile != null) downloadedFiles.add(logoFile);
  }

  if (platform == 'ios' &&
      config.googlePlistUrl != null &&
      config.googlePlistUrl!.isNotEmpty) {
    Logger.info('Downloading GoogleService-Info.plist for iOS...');
    final plistFile = await _downloadFile(
      config.googlePlistUrl!,
      '$appDirPath/ios/Runner/GoogleService-Info.plist',
    );
    if (plistFile != null) downloadedFiles.add(plistFile);
  }

  return downloadedFiles;
}

Future<File?> _downloadFile(String url, String destPath) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    Logger.warn(
      'Failed to download asset from $url (HTTP ${response.statusCode}). Skipping...',
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

/// Updates native app name and platform identifier for the target platform.
Future<void> updateNativeBranding({
  required String appName,
  required String androidPackageName,
  required String iosBundleId,
  required String platform,
  required String workingDir,
}) async {
  if (platform == 'ios') {
    Logger.info(
      'Updating iOS app name ($appName) and bundle ID ($iosBundleId)...',
    );

    var result = await Process.run('dart', [
      'run',
      'rename',
      'setAppName',
      '--targets',
      'ios',
      '--value',
      appName,
    ], workingDirectory: workingDir);

    if (result.exitCode != 0) {
      throw Exception('Failed to update iOS app name: ${result.stderr}');
    }

    if (iosBundleId.isNotEmpty) {
      result = await Process.run('dart', [
        'run',
        'rename',
        'setBundleId',
        '--targets',
        'ios',
        '--value',
        iosBundleId,
      ], workingDirectory: workingDir);

      if (result.exitCode != 0) {
        throw Exception('Failed to update iOS bundle ID: ${result.stderr}');
      }
    }
  } else {
    Logger.info(
      'Updating Android app name ($appName) and package name ($androidPackageName)...',
    );

    var result = await Process.run('dart', [
      'run',
      'rename',
      'setAppName',
      '--targets',
      'android',
      '--value',
      appName,
    ], workingDirectory: workingDir);

    if (result.exitCode != 0) {
      throw Exception('Failed to update Android app name: ${result.stderr}');
    }

    if (androidPackageName.isNotEmpty) {
      result = await Process.run('dart', [
        'run',
        'rename',
        'setBundleId',
        '--targets',
        'android',
        '--value',
        androidPackageName,
      ], workingDirectory: workingDir);

      if (result.exitCode != 0) {
        throw Exception(
          'Failed to update Android package name: ${result.stderr}',
        );
      }
    }
  }
}

/// Updates iOS Google Sign-In config.
Future<void> updateIosGoogleConfig(
  String appDirPath,
  String iosClientId,
) async {
  Logger.info('Updating iOS Google Sign-In config...');
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
    Logger.info('Writing android/app/google-services.json...');
    final file = File('$appDirPath/android/app/google-services.json');
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    await file.writeAsString(jsonEncode(googleServices));
  } else {
    Logger.warn('google_services_json not found in remote config. Skipping...');
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
    Logger.info('Enabling Zoom native SDK dependency in pubspec.yaml...');
    content = content.replaceAll(
      '  testpress:\n    path: ../packages/testpress',
      '  testpress:\n    path: ../packages/testpress\n  zoom:\n    path: ../packages/zoom',
    );
  } else {
    Logger.info('Zoom native SDK dependency is disabled.');
  }

  await pubspecFile.writeAsString(content);

  Logger.info('Syncing dependencies with flutter pub get...');
  final pubGetResult = await Process.run('flutter', [
    'pub',
    'get',
  ], workingDirectory: appDirPath);

  if (pubGetResult.exitCode != 0) {
    Logger.warn('flutter pub get failed: ${pubGetResult.stderr}');
  }
}

/// Generates native launcher icons from `temp_launcher.png` for the target platform.
Future<File?> generateNativeIcons(
  String workingDir, {
  String platform = 'android',
}) async {
  final iconFile = File('$workingDir/assets/images/temp_launcher.png');
  if (!iconFile.existsSync()) {
    Logger.warn('Launcher icon not found. Skipping native icon generation.');
    return null;
  }

  final isAndroid = platform == 'android';
  Logger.info(
    'Generating ${isAndroid ? "Android" : "iOS"} native launcher icons...',
  );
  final iconConfig = File('$workingDir/flutter_launcher_icons.yaml');
  await iconConfig.writeAsString('''
flutter_launcher_icons:
  android: ${isAndroid ? "true" : "false"}
  ios: ${isAndroid ? "false" : "true"}
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
  Logger.info('Cleaning up temporary files...');
  for (final file in files) {
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

/// Restores git working tree to a clean state.
Future<void> restoreGitChanges({String platform = 'android'}) async {
  Logger.info('Cleaning up native configuration changes...');
  final pathsToCheckout = [
    if (platform == 'ios') 'app/ios' else 'app/android',
    'app/pubspec.yaml',
    'app/pubspec.lock',
  ];

  final checkoutResult = await Process.run('git', [
    'checkout',
    '--',
    ...pathsToCheckout,
  ]);
  if (checkoutResult.exitCode != 0) {
    Logger.warn('git checkout failed: ${checkoutResult.stderr}');
  }

  final cleanResult = await Process.run('git', [
    'clean',
    '-fd',
    if (platform == 'ios') 'app/ios' else 'app/android',
  ]);
  if (cleanResult.exitCode != 0) {
    Logger.warn('git clean failed: ${cleanResult.stderr}');
  }

  if (checkoutResult.exitCode == 0 && cleanResult.exitCode == 0) {
    Logger.success('Workspace restored cleanly.');
  }
}

/// Strongly typed container for remote client configuration.
class ClientConfig {
  final String appName;
  final String bundleId;
  final String packageName;
  final String apiBaseUrl;
  final String? logoUrl;
  final String? launcherIconUrl;
  final String? splashScreenUrl;
  final String? loginScreenUrl;
  final String? launchImageUrl;
  final String? serverClientId;
  final String? primaryColor;
  final String? secondaryColor;
  final String? tertiaryColor;
  final String appVersion;
  final String androidBuildNumber;
  final String iosBuildNumber;
  final bool zoomEnabled;
  final String iosClientId;
  final String? googlePlistUrl;
  final dynamic googleServicesJson;

  /// Returns target build number (defaults to Android build number).
  String get buildNumber =>
      androidBuildNumber.isNotEmpty ? androidBuildNumber : iosBuildNumber;

  const ClientConfig({
    required this.appName,
    required this.bundleId,
    required this.packageName,
    required this.apiBaseUrl,
    required this.logoUrl,
    required this.launcherIconUrl,
    required this.splashScreenUrl,
    required this.loginScreenUrl,
    this.launchImageUrl,
    required this.serverClientId,
    required this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
    required this.appVersion,
    required this.androidBuildNumber,
    required this.iosBuildNumber,
    required this.zoomEnabled,
    required this.iosClientId,
    this.googlePlistUrl,
    required this.googleServicesJson,
  });

  factory ClientConfig.fromRemote({
    required Map<String, dynamic> remoteConfig,
    required String? logoUrl,
    required String apiBaseUrl,
  }) {
    final androidCode = remoteConfig['android_version_code'].toString();
    final iosCode = remoteConfig['ios_version_code'].toString();
    final pkgName = remoteConfig['package_name'].toString();
    final bundleId = remoteConfig['bundle_id'].toString();

    return ClientConfig(
      appName: remoteConfig['app_name'].toString(),
      bundleId: bundleId,
      packageName: pkgName,
      apiBaseUrl: apiBaseUrl,
      logoUrl: logoUrl,
      launcherIconUrl:
          remoteConfig['app_icon']?.toString() ??
          remoteConfig['launcher_xxxhdpi']?.toString(),
      splashScreenUrl: remoteConfig['splash_screen']?.toString(),
      loginScreenUrl:
          remoteConfig['login_image']?.toString() ??
          remoteConfig['login_screen_image']?.toString(),
      launchImageUrl: remoteConfig['launch_image']?.toString(),
      serverClientId: remoteConfig['server_client_id']?.toString(),
      primaryColor: remoteConfig['primary_color']?.toString(),
      secondaryColor: remoteConfig['secondary_color']?.toString(),
      tertiaryColor: remoteConfig['tertiary_color']?.toString(),
      appVersion: remoteConfig['version']?.toString() ?? '0.1.0',
      androidBuildNumber: androidCode,
      iosBuildNumber: iosCode,
      zoomEnabled: remoteConfig['zoom_enabled'] as bool? ?? false,
      iosClientId: remoteConfig['ios_client_id']?.toString() ?? '',
      googlePlistUrl: remoteConfig['google_plist']?.toString(),
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
  final String platform;
  final String mode;
  final List<String> extraArgs;

  const CliArgs({
    required this.configPath,
    required this.apiBaseUrl,
    required this.apiKey,
    this.platform = 'android',
    this.mode = 'debug',
    this.extraArgs = const [],
  });
}
