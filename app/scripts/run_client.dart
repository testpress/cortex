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
    final appDir = Directory('app');

    print('Applying configuration for: $appName');

    downloadedFiles.addAll(await downloadAssets(remoteConfig, appDir.path));
    await updateBranding(appName, bundleId, appDir.path);
    brandingUpdated = true;

    final iconConfig = await generateNativeIcons(appDir.path);
    if (iconConfig != null) {
      downloadedFiles.add(iconConfig);
    }

    await _runApp(appDir.path, appName, cliArgs.configPath, cliArgs.apiBaseUrl);
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
  String apiBaseUrl,
) async {
  print('🚀 Running the app for $appName... (Hot reload enabled)');
  final runProcess = await Process.start(
    'flutter',
    [
      'run',
      '--dart-define-from-file=../$configPath',
      '--dart-define=API_BASE_URL=$apiBaseUrl',
    ],
    workingDirectory: workingDir,
    mode: ProcessStartMode.inheritStdio,
  );

  await runProcess.exitCode;
}
