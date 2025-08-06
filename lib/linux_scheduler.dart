import 'dart:io';

class LinuxScheduler {
  static void schedule() {
    createService();
    createTimer();
  }

  static void createService() {
    final path =
        "/home/yolisses/GoSleep/go_sleep/build/linux/x64/debug/bundle/go_sleep";
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
    final file = File('/home/yolisses/.config/systemd/user/go_sleep.service');
    file.writeAsStringSync(content);
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
