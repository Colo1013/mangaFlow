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

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - _strokeWidth / 2;

    // 1. Arco di sfondo
    final paintSfondo = Paint()
      ..color = inactiveColor.withValues(alpha: 0.2)
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi,
      false,
      paintSfondo,
    );

    // 2. Arco attivo
    if (progressione > 0) {
      final paintAttivo = Paint()
        ..color = activeColor
        ..strokeWidth = _strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progressione,
        false,
        paintAttivo,
      );
    }
  }

  @override
  bool shouldRepaint(covariant FocusRingPainter oldDelegate) =>
      oldDelegate.progressione != progressione;
}
