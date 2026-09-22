// ignore_for_file: avoid_print

import 'dart:io';
import 'client_utils.dart';

void main(List<String> args) async {
  final cliArgs = parseArgs(args, 'run_client.dart');

  await runClientWorkflow(cliArgs, (client, appDirPath) async {
    final hasExplicitDevice = cliArgs.extraArgs.any(
      (arg) =>
          arg == '-d' ||
          arg == '--device' ||
          arg.startsWith('-d=') ||
          arg.startsWith('--device='),
    );

    String? targetDeviceId;
    if (!hasExplicitDevice) {
      targetDeviceId = await findDeviceIdForPlatform(cliArgs.platform);
      if (targetDeviceId != null) {
        Logger.info(
          'Target device resolved for ${cliArgs.platform}: $targetDeviceId',
        );
      } else {
        Logger.warn(
          'No connected ${cliArgs.platform} device detected. Letting Flutter prompt for devices...',
        );
      }
    }

    final runArgs = [
      'run',
      '--${cliArgs.mode}',
      if (targetDeviceId != null) ...['-d', targetDeviceId],
      ...client.toDartDefines(
        configPath: cliArgs.configPath,
        appDirPath: appDirPath,
      ),
      ...cliArgs.extraArgs,
    ];

    Logger.info(
      'Running the app for ${client.appName} (${cliArgs.platform}, ${cliArgs.mode} mode)...',
    );

    final runProcess = await Process.start(
      'flutter',
      runArgs,
      workingDirectory: appDirPath,
      mode: ProcessStartMode.inheritStdio,
    );

    // Intercept Ctrl+C: kill the flutter child process so that
    // runClientWorkflow's finally block can run and restore branding.
    // Without this, Dart exits immediately on SIGINT, skipping cleanup.
    final sigintSub = ProcessSignal.sigint.watch().listen((_) {
      Logger.warn('\nInterrupted. Restoring branding changes...');
      runProcess.kill(ProcessSignal.sigterm);
    });

    await runProcess.exitCode;
    await sigintSub.cancel();
  });
}
