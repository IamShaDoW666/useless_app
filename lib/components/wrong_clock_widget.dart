import 'dart:math';
import 'package:flutter/material.dart';

class WrongClockWidget extends StatefulWidget {
  const WrongClockWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WrongClockWidgetState createState() => _WrongClockWidgetState();
}

class _WrongClockWidgetState extends State<WrongClockWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: WrongClockPainter(),
          ),
        ),
      ),
    );
  }
}

class WrongClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(size.width, size.height) / 2 * 0.8;

    // Draw Clock Circle
    final paint = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Misplaced Numbers
    const textStyle = TextStyle(fontSize: 18, color: Colors.black);
    const textSpan = TextSpan(text: '12', style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(centerX - 20, centerY + radius / 2)); // 12 at bottom

    const textSpan3 = TextSpan(text: '3', style: textStyle);
    final textPainter3 =
        TextPainter(text: textSpan3, textDirection: TextDirection.ltr);
    textPainter3.layout();
    textPainter3.paint(
        canvas, Offset(centerX - radius / 2, centerY - 20)); // 3 at left

    const textSpan6 = TextSpan(text: '6', style: textStyle);
    final textPainter6 =
        TextPainter(text: textSpan6, textDirection: TextDirection.ltr);
    textPainter6.layout();
    textPainter6.paint(
        canvas,
        Offset(
            centerX + radius / 2, centerY - 10)); // 6 at right (slightly off)

    const textSpan9 = TextSpan(text: '9', style: textStyle);
    final textPainter9 =
        TextPainter(text: textSpan9, textDirection: TextDirection.ltr);
    textPainter9.layout();
    textPainter9.paint(canvas,
        Offset(centerX - 10, centerY - radius / 2)); // 9 at top (slightly off)

    // Hands (running backwards)
    final now = DateTime.now();
    final hourAngle =
        (now.hour + now.minute / 60) * -pi / 6; // Negative for reverse
    final minuteAngle = now.minute * -pi / 30; // Negative for reverse
    final secondAngle = now.second * -pi / 30; // Negative for reverse

    // Hour Hand
    final hourPaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + radius * 0.5 * sin(hourAngle),
        centerY - radius * 0.5 * cos(hourAngle),
      ),
      hourPaint,
    );

    // Minute Hand
    final minutePaint = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + radius * 0.7 * sin(minuteAngle),
        centerY - radius * 0.7 * cos(minuteAngle),
      ),
      minutePaint,
    );

    // Second Hand
    final secondPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(centerX, centerY),
      Offset(
        centerX + radius * 0.9 * sin(secondAngle),
        centerY - radius * 0.9 * cos(secondAngle),
      ),
      secondPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) =>
      true; // Repaint for animation
}
