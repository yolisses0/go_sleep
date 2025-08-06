import 'dart:io';

class LinuxScheduler {
  static final String homeDir =
      Platform.environment['SNAP_REAL_HOME'] ??
      Platform.environment['HOME'] ??
      '';
  static final servicePath = '$homeDir/.config/systemd/user/go_sleep.service';

  static final String executablePath = Platform.environment['SNAP'] != null
      ? '/snap/bin/go-sleep'
      // For development
      : '${Directory.current.path}/build/linux/x64/debug/bundle/go_sleep';

  static void schedule() {
    createService();
    createTimer();
  }

  static void createService() {
    final content =
        """
[Unit]
Description=Go Sleep

[Service]
ExecStart=$executablePath --sleep
Type=simple

[Install]
WantedBy=default.target
""";
    final file = File(servicePath);
    file.writeAsStringSync(content);
  }

  static void deleteService() {
    final file = File(servicePath);
    file.deleteSync();
  }

  static void createTimer() async {}

  static void runCommand(String command) {
    final result = Process.runSync(command, []);
    if (result.stderr.toString().isNotEmpty) throw Exception(result.stderr);
  }

  static void startService() {
    runCommand('systemctl --user unmask go_sleep.service');
    runCommand('systemctl --user start go_sleep.service');
  }
}
