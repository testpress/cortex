// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final List<File> downloadedFiles = [];
  bool brandingUpdated = false;
  try {
    final cliArgs = parseArgs(args, 'generate_client_app.dart');
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

    await _buildApk(
      appDir.path,
      appName,
      cliArgs.configPath,
      cliArgs.apiBaseUrl,
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

Future<bool> _buildApk(
  String workingDir,
  String appName,
  String configPath,
  String apiBaseUrl,
) async {
  print('🚀 Building the APK for $appName... (This may take a few minutes)');
  final buildProcess = await Process.start('flutter', [
    'build',
    'apk',
    '--dart-define-from-file=../$configPath',
    '--dart-define=API_BASE_URL=$apiBaseUrl',
  ], workingDirectory: workingDir);

  await stdout.addStream(buildProcess.stdout);
  await stderr.addStream(buildProcess.stderr);

  final exitCode = await buildProcess.exitCode;
  if (exitCode == 0) {
    File apkFile = File(
      '$workingDir/build/app/outputs/flutter-apk/app-release.apk',
    );
    if (!apkFile.existsSync()) {
      apkFile = File(
        '$workingDir/build/app/outputs/apk/release/app-release.apk',
      );
    }

    if (apkFile.existsSync()) {
      final safeAppName = appName.replaceAll(' ', '_');
      final newApkPath = '${apkFile.parent.path}/$safeAppName.apk';
      await apkFile.rename(newApkPath);
      print('🎉 SUCCESS! Your APK is ready here:');
      print('👉 $newApkPath');
    } else {
      print('🎉 SUCCESS! But could not locate the APK to rename it.');
    }
    return true;
  } else {
    print('❌ Build failed with exit code $exitCode');
    return false;
  }
}
