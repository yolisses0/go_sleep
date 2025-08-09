import 'dart:math';

import 'package:flutter/material.dart';

class TimeGraph extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final double size;

  const TimeGraph({
    super.key,
    required this.startTime,
    required this.endTime,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: TimeGraphPainter(startTime: startTime, endTime: endTime),
      ),
    );
  }
}

class TimeGraphPainter extends CustomPainter {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeGraphPainter({required this.startTime, required this.endTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw the circle background
    final circlePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 2, circlePaint);

    // Convert TimeOfDay to angles (0° is at 12 o'clock, moving clockwise)
    final shutdownAngle = _timeToAngle(startTime);
    final wakeupAngle = _timeToAngle(endTime);

    // Draw the arc for shutdown period
    final arcPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 2),
      shutdownAngle,
      _calculateSweepAngle(shutdownAngle, wakeupAngle),
      false,
      arcPaint,
    );

    // Draw hour markers
    _drawHourMarkers(canvas, center, radius);
  }

  double _timeToAngle(TimeOfDay time) {
    // Convert time to angle (starting from 12 o'clock position)
    final hours = time.hour + time.minute / 60;
    // Multiply by (pi/12) to convert 24 hours to 2π radians
    // Subtract pi/2 to start from top (12 o'clock position)
    return (hours * (pi / 12)) - (pi / 2);
  }

  double _calculateSweepAngle(double start, double end) {
    double sweep = end - start;
    if (sweep < 0) sweep += 2 * pi;
    return sweep;
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius) {
    final markerPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Text style for hour labels
    const textStyle = TextStyle(
      color: Colors.grey,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    for (int hour = 0; hour < 24; hour++) {
      final angle = (hour - 6) * (pi / 12);
      final markerStart = Offset(
        center.dx + (radius - 8) * cos(angle),
        center.dy + (radius - 8) * sin(angle),
      );
      final markerEnd = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      canvas.drawLine(markerStart, markerEnd, markerPaint);

      // Add text for specific hours
      if (hour == 0 || hour == 6 || hour == 12 || hour == 18) {
        final textSpan = TextSpan(
          text: '${hour.toString().padLeft(2, '0')}:00',
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        // Position text inside the circle (at 70% of the radius instead of 80%)instead of 80%)
        final textAngle = (hour - 6) * (pi / 12);
        final textRadius =
            radius * 0.7; // Changed from 0.8 to 0.7 // Changed from 0.8 to 0.7
        final textCenter = Offset(
          center.dx + textRadius * cos(textAngle),
          center.dy + textRadius * sin(textAngle),
        );

        textPainter.paint(
          canvas,
          textCenter.translate(-textPainter.width / 2, -textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
