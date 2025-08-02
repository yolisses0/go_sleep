import 'dart:io';

class LinuxScheduler {
  void schedule() {
    createService();
  }

  void createService() {
    final file = """
[Unit]
Description=Go Sleep

[Service]
ExecStart=/home/yolisses/GoSleep/go_sleep/linux/test1.sh
Type=simple

[Install]
WantedBy=default.target
""";
    final filePath = '/home/yolisses/.config/systemd/user/go_sleep.service';
    Process.run('echo', [file, '>', filePath]);
  }
}
