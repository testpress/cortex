// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'client_utils.dart';

void main(List<String> args) async {
  String? subdomain;
  String? apiBaseUrl;
  String platform = 'android';
  String? configPath;

  for (final arg in args) {
    if (arg.startsWith('--subdomain=')) {
      subdomain = arg.substring('--subdomain='.length);
    } else if (arg.startsWith('--api-base-url=')) {
      apiBaseUrl = arg.substring('--api-base-url='.length);
    } else if (arg.startsWith('--platform=')) {
      platform = arg.substring('--platform='.length).toLowerCase();
    } else if (arg.startsWith('--config=')) {
      configPath = arg.substring('--config='.length);
    }
  }

  if (apiBaseUrl == null && subdomain != null) {
    apiBaseUrl = 'https://$subdomain.testpress.in';
  }

  if (apiBaseUrl == null) {
    Logger.error('Missing required argument: --subdomain or --api-base-url');
    exit(1);
  }

  final apiKey =
      Platform.environment['API_ACCESS_KEY'] ??
      Platform.environment['CLIENT_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    Logger.error(
      'Missing API_ACCESS_KEY / CLIENT_API_KEY environment variable.',
    );
    exit(1);
  }

  if (platform != 'android' && platform != 'ios') {
    Logger.error('Invalid platform "$platform". Must be "android" or "ios".');
    exit(1);
  }

  final appDir = Directory('app');
  final client = await fetchClientConfig(apiBaseUrl, apiKey);
  Logger.info('Loaded config for: ${client.appName} (Platform: $platform)');

  // 1. Download basic assets (icons, splash, logo)
  await downloadClientAssets(client, appDir.path, platform: platform);

  // 2. Update native branding (package name / bundle ID, app name)
  await updateNativeBranding(
    appName: client.appName,
    androidPackageName: client.packageName,
    iosBundleId: client.bundleId,
    platform: platform,
    workingDir: appDir.path,
  );

  // 3. Platform specific configs and credentials
  String? keystorePath;
  String? playKeyPath;
  String? appleKeyPath;

  if (platform == 'android') {
    await updateAndroidGoogleConfig(appDir.path, client.googleServicesJson);

    // Download keystore if available
    if (client.keystoreUrl != null && client.keystoreUrl!.isNotEmpty) {
      Logger.info('Downloading Android keystore...');
      final keystoreFile = File('${appDir.path}/android/app/keystore.jks');
      final downloaded = await _downloadFile(
        client.keystoreUrl!,
        keystoreFile.path,
      );
      if (downloaded != null) {
        keystorePath = keystoreFile.path;
        // Inject signing properties directly into gradle.properties
        final gradleProps = File('${appDir.path}/android/gradle.properties');
        final content = StringBuffer()
          ..writeln('\n# Injected release signing properties')
          ..writeln(
            'android.injected.signing.store.file=${keystoreFile.absolute.path}',
          )
          ..writeln(
            'android.injected.signing.store.password=${client.keystorePassword ?? ""}',
          )
          ..writeln(
            'android.injected.signing.key.alias=${client.keyAlias ?? ""}',
          )
          ..writeln(
            'android.injected.signing.key.password=${client.keyPassword ?? ""}',
          );
        await gradleProps.writeAsString(
          content.toString(),
          mode: FileMode.append,
        );
        Logger.success(
          'Injected release signing properties into ${gradleProps.path}',
        );
      }
    }

    // Download Play Console service account key if available
    if (client.playConsoleKeyUrl != null &&
        client.playConsoleKeyUrl!.isNotEmpty) {
      Logger.info('Downloading Google Play Console service account key...');
      final playKeyFile = File('${appDir.path}/android/play_console_key.json');
      final downloaded = await _downloadFile(
        client.playConsoleKeyUrl!,
        playKeyFile.path,
      );
      if (downloaded != null) {
        playKeyPath = playKeyFile.path;
      }
    }
  } else {
    // iOS
    await updateIosGoogleConfig(appDir.path, client.iosClientId);

    if (client.appleApiKeyUrl != null && client.appleApiKeyUrl!.isNotEmpty) {
      Logger.info('Downloading Apple App Store Connect API Key (.p8)...');
      final p8File = File(
        '${appDir.path}/ios/AuthKey_${client.appleKeyId ?? "key"}.p8',
      );
      final downloaded = await _downloadFile(
        client.appleApiKeyUrl!,
        p8File.path,
      );
      if (downloaded != null) {
        appleKeyPath = p8File.path;
      }
    }
  }

  // 4. Update Zoom dependency if configured
  await updateZoomDependency(appDir.path, client.zoomEnabled);

  // 5. Generate native launcher icons
  await generateNativeIcons(appDir.path, platform: platform);

  // 6. Write GitHub Actions environment outputs (if GITHUB_OUTPUT is set)
  final githubOutput = Platform.environment['GITHUB_OUTPUT'];
  final defines = client.toDartDefines(
    configPath: configPath,
    appDirPath: appDir.path,
  );
  final version = client.appVersion;
  final buildNumber = platform == 'android'
      ? client.androidBuildNumber
      : client.iosBuildNumber;

  final outputs = <String, String>{
    'app_name': client.appName,
    'package_name': client.packageName,
    'bundle_id': client.bundleId,
    'version': version,
    'build_number': buildNumber,
    'dart_defines': defines.join(' '),
    'keystore_path': keystorePath ?? '',
    'play_key_path': playKeyPath ?? '',
    'apple_key_path': appleKeyPath ?? '',
    'apple_key_id': client.appleKeyId ?? '',
    'apple_issuer_id': client.appleIssuerId ?? '',
    'apple_team_id': client.appleTeamId ?? '',
    'app_store_app_id': client.appStoreAppId ?? '',
  };

  if (githubOutput != null && File(githubOutput).existsSync()) {
    final sink = File(githubOutput).openWrite(mode: FileMode.append);
    for (final entry in outputs.entries) {
      final cleanKey = entry.key.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
      final delimiter =
          'EOF_${DateTime.now().microsecondsSinceEpoch}_$cleanKey';
      sink.writeln('$cleanKey<<$delimiter');
      sink.writeln(entry.value);
      sink.writeln(delimiter);
    }
    await sink.close();
    Logger.success('Exported release parameters to GITHUB_OUTPUT');
  }

  // Also write to a local metadata JSON file for Fastlane / scripts to consume
  final releaseMetaFile = File('release_metadata.json');
  await releaseMetaFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(outputs),
  );
  Logger.success(
    'Release preparation complete. Metadata written to ${releaseMetaFile.path}',
  );
}

Future<File?> _downloadFile(String url, String destPath) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      Logger.warn('Failed to download $url (HTTP ${response.statusCode})');
      return null;
    }
    final file = File(destPath);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } catch (e) {
    Logger.warn('Error downloading from $url: $e');
    return null;
  }
}
