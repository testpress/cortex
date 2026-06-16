// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

void main(List<String> args) async {
  try {
    String? configPath;
    for (final arg in args) {
      if (arg.startsWith('--config=')) {
        configPath = arg.substring('--config='.length);
      }
    }

    if (configPath == null) {
      print('❌ Error: Please provide the path to the config file.');
      print(
        'Usage: dart run app/scripts/generate_client_app.dart --config=config/your_client.json',
      );
      exit(1);
    }
    final config = await _loadConfig(configPath);
    final appName = config['APP_NAME'];
    final bundleId = config['BUNDLE_ID'];
    final iconUrl = config['LAUNCHER_ICON'];
    final appDir = Directory('app');

    print('Applying configuration for: $appName');

    final iconFile = await _downloadIcon(
      iconUrl,
      '${appDir.path}/assets/images/temp_launcher.png',
    );
    await _updateBranding(appName, bundleId, appDir.path);
    final iconConfig = await _generateNativeIcons(appDir.path);
    await _cleanupTempFiles([iconFile, iconConfig]);
    await _buildApk(appDir.path, appName, configPath);
    await _restoreGitChanges();
  } catch (e) {
    print('❌ Error: $e');
  }
}

Future<Map<String, dynamic>> _loadConfig(String path) async {
  final configFile = File(path);
  if (!configFile.existsSync()) {
    throw Exception(
      'Config file not found at $path. Run from the root of the workspace.',
    );
  }
  return jsonDecode(await configFile.readAsString());
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

Future<void> _updateBranding(
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

Future<File> _generateNativeIcons(String workingDir) async {
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

Future<void> _cleanupTempFiles(List<File> files) async {
  print('Cleaning up temporary files...');
  for (final file in files) {
    if (file.existsSync()) {
      await file.delete();
    }
  }
}

Future<bool> _buildApk(
  String workingDir,
  String appName,
  String configPath,
) async {
  print('🚀 Building the APK for $appName... (This may take a few minutes)');
  final buildProcess = await Process.start('flutter', [
    'build',
    'apk',
    '--dart-define-from-file=../$configPath',
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

Future<void> _restoreGitChanges() async {
  print('🧹 Cleaning up native configuration changes...');
  await Process.run('git', ['checkout', '--', 'app/ios', 'app/android']);
  await Process.run('git', ['clean', '-fd', 'app/ios', 'app/android']);
  print('✨ Repository restored to original state.');
}
