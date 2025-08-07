import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_sleep/linux_scheduler.dart';

void main() {
  test('0:0 -> 0:0', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 0, minute: 0),
        TimeOfDay(hour: 0, minute: 0),
      ),
      ["0:0..0:0/1"],
    );
  });

  test('0:1 -> 0:2', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 0, minute: 1),
        TimeOfDay(hour: 0, minute: 2),
      ),
      ["0:1..2:0/1"],
    );
  });

  test('1:2 -> 2:3', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 1, minute: 2),
        TimeOfDay(hour: 2, minute: 3),
      ),
      ["1:2..59:0/1", "2:0..3:0/1"],
    );
  });

  test('1:2 -> 3:4', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 1, minute: 2),
        TimeOfDay(hour: 3, minute: 4),
      ),
      ["1:2..59:0/1", "2..2:*:0/1", "3:0..4:0/1"],
    );
  });

  test('1:2 -> 5:6', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 1, minute: 2),
        TimeOfDay(hour: 5, minute: 6),
      ),
      ["1:2..59:0/1", "2..4:*:0/1", "5:0..6:0/1"],
    );
  });

  test('2:3 -> 0:1', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 2, minute: 3),
        TimeOfDay(hour: 0, minute: 1),
      ),
      ["2:3..59:0/1", "3..23:*:0/1", "0:0..1:0/1"],
    );
  });

  test('2:3 -> 1:2', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 2, minute: 3),
        TimeOfDay(hour: 1, minute: 2),
      ),
      ["2:3..59:0/1", "3..23:*:0/1", "0..0:*:0/1", "1:0..2:0/1"],
    );
  });

  test('5:6 ->3:4', () {
    expect(
      LinuxScheduler.createOnCalendar(
        TimeOfDay(hour: 5, minute: 6),
        TimeOfDay(hour: 3, minute: 4),
      ),
      ["5:6..59:0/1", "6..23:*:0/1", "0..2:*:0/1", "3:0..4:0/1"],
    );
  });
}
