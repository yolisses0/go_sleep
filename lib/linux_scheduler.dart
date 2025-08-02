import 'dart:io';

class LinuxScheduler {
  static void schedule() {
    createService();
  }

  static void createService() async {
    final content = """
[Unit]
Description=Go Sleep

[Service]
ExecStart=/home/yolisses/GoSleep/go_sleep/linux/test1.sh
Type=simple

[Install]
WantedBy=default.target
""";
    final file = new File(
      '/home/yolisses/.config/systemd/user/go_sleep.service',
    );
    await file.writeAsString(content);
  }
}
