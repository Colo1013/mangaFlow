import 'dart:math';
import 'package:flutter/material.dart';

class FocusRingPainter extends CustomPainter {
  final double progressione;
  final Color activeColor;
  final Color inactiveColor;

  const FocusRingPainter({
    required this.progressione,
    required this.activeColor,
    required this.inactiveColor,
  });

  static const double _strokeWidth = 12.0;
  static const int _dotCount = 12;
  static const double _dotRadius = 3.0;
  static const double _dotOffset = _strokeWidth + 8;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - _strokeWidth / 2;

    _drawInactiveArc(canvas, center, radius);
    if (progressione > 0) _drawActiveArc(canvas, center, radius);
    _drawDots(canvas, center, radius);
  }

  void _drawInactiveArc(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = inactiveColor.withValues(alpha: 0.2)
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      paint,
    );
  }

  void _drawActiveArc(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = activeColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progressione,
      false,
      paint,
    );
  }

  void _drawDots(Canvas canvas, Offset center, double radius) {
    final double dotRaggio = radius + _dotOffset;

    for (int i = 0; i < _dotCount; i++) {
      final angolo = (i / _dotCount) * 2 * pi - pi / 2;
      final x = center.dx + dotRaggio * cos(angolo);
      final y = center.dy + dotRaggio * sin(angolo);

      final isActive = progressione > 0 && (i / _dotCount) <= progressione;

      final paint = Paint()
        ..color = isActive ? activeColor : inactiveColor.withValues(alpha: 0.4)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), _dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FocusRingPainter oldDelegate) =>
      oldDelegate.progressione != progressione;
}
