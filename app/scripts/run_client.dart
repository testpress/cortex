// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final List<File> downloadedFiles = [];
  bool brandingUpdated = false;
  try {
    final cliArgs = parseArgs(args, 'run_client.dart');
    final remoteConfig = await fetchRemoteConfig(
      cliArgs.apiBaseUrl,
      cliArgs.apiKey,
    );

    final appName = remoteConfig['app_name'];
    final bundleId = remoteConfig['package_name'];

    String? serverClientId = remoteConfig['server_client_id'] as String?;

    final appDir = Directory('app');

    print('Applying configuration for: $appName');

    downloadedFiles.addAll(await downloadAssets(remoteConfig, appDir.path));
    await updateBranding(appName, bundleId, appDir.path);
    await updateIosGoogleConfig(appDir.path, remoteConfig);
    brandingUpdated = true;

    final iconConfig = await generateNativeIcons(appDir.path);
    if (iconConfig != null) {
      downloadedFiles.add(iconConfig);
    }

    await _runApp(
      appDir.path,
      appName,
      cliArgs.configPath,
      cliArgs.apiBaseUrl,
      serverClientId: serverClientId,
      primaryColor: remoteConfig['primary_color']?.toString(),
    );
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

Future<void> _runApp(
  String workingDir,
  String appName,
  String configPath,
  String apiBaseUrl, {
  String? serverClientId,
  String? primaryColor,
}) async {
  print('🚀 Running the app for $appName... (Hot reload enabled)');
  final runArgs = [
    'run',
    '--dart-define-from-file=../$configPath',
    '--dart-define=API_BASE_URL=$apiBaseUrl',
  ];
  if (serverClientId != null) {
    runArgs.add('--dart-define=GOOGLE_SERVER_CLIENT_ID=$serverClientId');
  }
  if (primaryColor != null && primaryColor.isNotEmpty) {
    runArgs.add('--dart-define=PRIMARY_COLOR=$primaryColor');
  }

  final runProcess = await Process.start(
    'flutter',
    runArgs,
    workingDirectory: workingDir,
    mode: ProcessStartMode.inheritStdio,
  );

  await runProcess.exitCode;
}
