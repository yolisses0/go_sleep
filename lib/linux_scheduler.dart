import 'dart:io';

class LinuxScheduler {
  const LinuxScheduler({required this.path});

  final String path;

  void schedule() {
    createService();
    createTimer();
  }

  void createService() {
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

  void deleteService() {}

  void createTimer() async {}

  void startService() {
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
