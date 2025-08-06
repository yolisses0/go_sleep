import 'package:flutter/material.dart';
import 'package:go_sleep/linux_scheduler.dart';

class SystemdPage extends StatelessWidget {
  const SystemdPage({super.key});

  final LinuxScheduler _linuxScheduler = const LinuxScheduler(
    path:
        "/home/yolisses/GoSleep/go_sleep/build/linux/x64/debug/bundle/go_sleep",
  );

  void onPressed() {
    _linuxScheduler.createService();
    _linuxScheduler.startService();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ElevatedButton(onPressed: onPressed, child: Text('press me'))],
    );
  }
}
