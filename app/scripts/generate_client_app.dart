// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final cliArgs = parseArgs(args, 'generate_client_app.dart');

  if (cliArgs.platform == 'ios') {
    Logger.error(
      'generate_client_app.dart only supports Android (APK) builds.\n'
      'For iOS development, use run_client.dart with --platform=ios instead.',
    );
    exit(1);
  }

  await runClientWorkflow(cliArgs, (client, appDirPath) async {
    final buildArgs = [
      'build',
      'apk',
      ...client.toDartDefines(
        configPath: cliArgs.configPath,
        appDirPath: appDirPath,
      ),
      if (client.appVersion.isNotEmpty) '--build-name=${client.appVersion}',
      if (client.androidBuildNumber.isNotEmpty)
        '--build-number=${client.androidBuildNumber}',
      ...cliArgs.extraArgs,
    ];
    await _buildAndRenameApk(appDirPath, client.appName, buildArgs);
  });
}

Future<bool> _buildAndRenameApk(
  String workingDir,
  String appName,
  List<String> buildArgs,
) async {
  Logger.info('Building the APK for $appName... (This may take a few minutes)');

  final buildProcess = await Process.start(
    'flutter',
    buildArgs,
    workingDirectory: workingDir,
  );

  await stdout.addStream(buildProcess.stdout);
  await stderr.addStream(buildProcess.stderr);

  final exitCode = await buildProcess.exitCode;
  if (exitCode != 0) {
    Logger.error('Build failed with exit code $exitCode');
    return false;
  }

  var apkFile = File(
    '$workingDir/build/app/outputs/flutter-apk/app-release.apk',
  );
  if (!apkFile.existsSync()) {
    apkFile = File('$workingDir/build/app/outputs/apk/release/app-release.apk');
  }

  if (apkFile.existsSync()) {
    final safeAppName = appName.replaceAll(' ', '_');
    final newApkPath = '${apkFile.parent.path}/$safeAppName.apk';
    await apkFile.rename(newApkPath);
    Logger.success('Your APK is ready: $newApkPath');
  } else {
    Logger.warn('Build succeeded, but could not locate the APK to rename it.');
  }
  return true;
}
