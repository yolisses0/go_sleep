import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

class LinuxScheduler {
  static final String homeDir =
      Platform.environment['SNAP_REAL_HOME'] ??
      Platform.environment['HOME'] ??
      '';
  static final servicePath = '$homeDir/.config/systemd/user/go_sleep.service';
  static final timerPath = '$homeDir/.config/systemd/user/go_sleep.timer';

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
        """[Unit]
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

  static List<String> createOnCalendar(TimeOfDay start, TimeOfDay end) {
    final List<String> result = [];
    final hourDifference = end.hour - start.hour;
    if (hourDifference == 0) {
      final [first, second] = start.isAfter(end) ? [end, start] : [start, end];
      result.add('${start.hour}:${first.minute}..${second.minute}:0/1');
    } else if (start.isBefore(end)) {
      result.add('${start.hour}:${start.minute}..59:0/1');
      if (end.hour - start.hour > 1) {
        result.add('${start.hour + 1}..${end.hour - 1}:*:0/1');
      }
      result.add('${end.hour}:0..${end.minute}:0/1');
    } else {
      result.add('${start.hour}:${start.minute}..59:0/1');
      if (24 - start.hour > 1) {
        result.add('${start.hour + 1}..23:*:0/1');
      }
      if (end.hour > 0) {
        result.add('0..${end.hour - 1}:*:0/1');
      }
      result.add('${end.hour}:0..${end.minute}:0/1');
    }
    return result;
  }

  static void createTimer() async {
    final content = """[Unit]
Description=Run test1

[Timer]
OnCalendar=18..20:*:00/1
AccuracySec=100ms

[Install]
WantedBy=timers.target""";
    final file = File(servicePath);
    file.writeAsStringSync(content);
  }

  static void runCommand(
    String command,
    List<String> arguments, {
    bool stopOnError = false,
  }) {
    final result = Process.runSync(command, arguments);

    final text = result.stderr.toString();
    if (text.isNotEmpty) {
      if (stopOnError) {
        throw Exception(text);
      } else {
        log(text);
      }
    }
  }

  static void startService() {
    runCommand('systemctl', ['--user', 'unmask', 'go_sleep.service']);
    runCommand('systemctl', ['--user', 'daemon-reload']);
    runCommand('systemctl', ['--user', 'start', 'go_sleep.service']);
  }
}
