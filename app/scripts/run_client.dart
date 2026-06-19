// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
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

    final downloadedFiles = await downloadAssets(remoteConfig, appDir.path);
    await updateBranding(appName, bundleId, appDir.path);
    final iconConfig = await generateNativeIcons(appDir.path);

    downloadedFiles.add(iconConfig);
    await _runApp(appDir.path, appName, cliArgs.configPath, cliArgs.apiBaseUrl);
    await cleanupTempFiles(downloadedFiles);
    await restoreGitChanges();
  } catch (e) {
    print('❌ Error: $e');
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
