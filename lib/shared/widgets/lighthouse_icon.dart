import 'package:flutter/material.dart';

/// Farol desenhado por código (viewBox 24x24). Hub central e logo.
class LighthouseIcon extends StatelessWidget {
  const LighthouseIcon({super.key, this.size = 36, this.color, this.strokeWidth = 2});
  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _LighthousePainter(color ?? Theme.of(context).colorScheme.primary, strokeWidth),
    );
  }
}

class _LighthousePainter extends CustomPainter {
  _LighthousePainter(this.color, this.stroke);
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * k
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    Offset o(double x, double y) => Offset(x * k, y * k);

    // torre: M9.5 21 l1 -11 h3 l1 11
    canvas.drawPath(
      Path()
        ..moveTo(9.5 * k, 21 * k)
        ..lineTo(10.5 * k, 10 * k)
        ..lineTo(13.5 * k, 10 * k)
        ..lineTo(14.5 * k, 21 * k),
      paint,
    );
    // base: M8 21 h8
    canvas.drawLine(o(8, 21), o(16, 21), paint);
    // lanterna: M10.5 10 V7.5 L12 6 l1.5 1.5 V10
    canvas.drawPath(
      Path()
        ..moveTo(10.5 * k, 10 * k)
        ..lineTo(10.5 * k, 7.5 * k)
        ..lineTo(12 * k, 6 * k)
        ..lineTo(13.5 * k, 7.5 * k)
        ..lineTo(13.5 * k, 10 * k),
      paint,
    );
    // feixes
    canvas.drawLine(o(16, 7.5), o(20, 6), paint);
    canvas.drawLine(o(16, 9.5), o(20, 11), paint);
    canvas.drawLine(o(8, 7.5), o(4, 6), paint);
    canvas.drawLine(o(8, 9.5), o(4, 11), paint);
  }

  @override
  bool shouldRepaint(_LighthousePainter old) => old.color != color || old.stroke != stroke;
}
