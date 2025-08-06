import 'dart:io';

class LinuxScheduler {
  // TODO replace these hard coded values
  static final String homeDir = Platform.environment['HOME'] ?? '';
  static final servicePath = '$homeDir/.config/systemd/user/go_sleep.service';
  static final String path =
      "/home/yolisses/GoSleep/go_sleep/build/linux/x64/debug/bundle/go_sleep";

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
ExecStart=$path --sleep
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

  static void startService() {
    final result1 = Process.runSync('systemctl', [
      '--user',
      'unmask',
      'go_sleep.service',
    ]);
    if ((result1.stderr as String).isNotEmpty) {
      throw Exception(result1.stderr);
    }

    final result2 = Process.runSync('systemctl', [
      '--user',
      'start',
      'go_sleep.service',
    ]);
    if ((result2.stderr as String).isNotEmpty) {
      throw Exception(result1.stderr);
    }
  }
}
