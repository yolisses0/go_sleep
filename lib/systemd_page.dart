import 'package:flutter/material.dart';
import 'package:go_sleep/linux_scheduler.dart';

class SystemdPage extends StatelessWidget {
  const SystemdPage({super.key});

  void onPressed() {
    LinuxScheduler.createService();
    LinuxScheduler.startService();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ElevatedButton(onPressed: onPressed, child: Text('press me'))],
    );
  }
}
