// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final cliArgs = parseArgs(args, 'run_client.dart');

  await runClientWorkflow(cliArgs, (client, appDirPath) async {
    final runArgs = [
      'run',
      ...client.toDartDefines(
        configPath: cliArgs.configPath,
        appDirPath: appDirPath,
      ),
    ];

    print('🚀 Running the app for ${client.appName}... (Hot reload enabled)');

    final runProcess = await Process.start(
      'flutter',
      runArgs,
      workingDirectory: appDirPath,
      mode: ProcessStartMode.inheritStdio,
    );

    await runProcess.exitCode;
  });
}
