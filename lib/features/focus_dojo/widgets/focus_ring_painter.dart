import 'dart:math';
import 'package:flutter/material.dart';

class FocusRingPainter extends CustomPainter {
  final double strokeWidth = 2.0;
  final int dashStep = 4; // Disegna un trattino ogni 4 gradi
  final double dashLength = 15.0; // Quanto è lungo ogni singolo trattino
  final double progressione;

  FocusRingPainter({required this.progressione});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Troviamo il centro esatto dello spazio a disposizione
    final center = Offset(size.width / 2, size.height / 2);

    // 2. Il raggio sarà la metà della dimensione minore tra larghezza e altezza
    final radius = min(size.width / 2, size.height / 2);

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.3)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    // 4. LA MATEMATICA: Un ciclo for che fa un giro completo (360 gradi)
    for (int i = 0; i < 360; i += dashStep) {
      final double radians = i * (pi / 180) - (pi / 2);

      // Calcoliamo il punto di INIZIO del trattino (raggio interno)
      final double innerRadius = radius - dashLength;
      final double x1 = center.dx + innerRadius * cos(radians);
      final double y1 = center.dy + innerRadius * sin(radians);

      // Calcoliamo il punto di FINE del trattino (raggio esterno)
      final double x2 = center.dx + radius * cos(radians);
      final double y2 = center.dy + radius * sin(radians);
      if (i / 360 > progressione) {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      } else {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return (oldDelegate as FocusRingPainter).progressione != progressione;
  }
}
