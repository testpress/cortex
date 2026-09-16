// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final cliArgs = parseArgs(args, 'generate_client_app.dart');

  await runClientWorkflow(cliArgs, (client, appDirPath) async {
    final buildArgs = [
      'build',
      'apk',
      ...client.toDartDefines(
        configPath: cliArgs.configPath,
        appDirPath: appDirPath,
      ),
      if (client.appVersion.isNotEmpty) '--build-name=${client.appVersion}',
      if (client.buildNumber.isNotEmpty) '--build-number=${client.buildNumber}',
    ];

    await _buildAndRenameApk(appDirPath, client.appName, buildArgs);
  });
}

Future<bool> _buildAndRenameApk(
  String workingDir,
  String appName,
  List<String> buildArgs,
) async {
  print('🚀 Building the APK for $appName... (This may take a few minutes)');

  final buildProcess = await Process.start(
    'flutter',
    buildArgs,
    workingDirectory: workingDir,
  );

  await stdout.addStream(buildProcess.stdout);
  await stderr.addStream(buildProcess.stderr);

  final exitCode = await buildProcess.exitCode;
  if (exitCode != 0) {
    print('❌ Build failed with exit code $exitCode');
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
    print('🎉 SUCCESS! Your APK is ready here:');
    print('👉 $newApkPath');
  } else {
    print('🎉 SUCCESS! But could not locate the APK to rename it.');
  }
  return true;
}
