import 'package:flutter/material.dart';

class RitualPainter extends CustomPainter {
  final double copertura;
  const RitualPainter({required this.copertura});

  double _progresso(double start, double end) =>
      ((copertura - start) / (end - start)).clamp(0.0, 1.0);

  void _disegna({
    required Canvas canvas,
    required double progresso,
    required Offset from,
    required Offset ctrl, // punto di controllo curva
    required Offset to,
    required double spessore,
  }) {
    if (progresso <= 0) return;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle
          .stroke // ← linea, non forma chiusa!
      ..strokeWidth = spessore
      ..strokeCap = StrokeCap
          .round // ← estremità arrotondate
      ..strokeJoin = StrokeJoin.round;

    // Una semplice curva quadratica = pennellata organica
    final path = Path();
    path.moveTo(from.dx, from.dy);
    path.quadraticBezierTo(ctrl.dx, ctrl.dy, to.dx, to.dy);

    // PathMetrics: disegna solo la porzione 0 → progresso
    // Questo è l'effetto "il pennello sta tracciando"
    final metric = path.computeMetrics().first;
    final parziale = metric.extractPath(0, metric.length * progresso);
    canvas.drawPath(parziale, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Lo spessore deve essere abbastanza grande da coprire
    // una fascia larga dello schermo
    final sp = w * 0.52;

    // 5 pennellate che si sovrappongono e coprono tutto lo schermo
    // Ogni pennellata entra in scena in momenti diversi

    // 1. Diagonale alto-sinistra → basso-destra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.0, 0.3),
      from: Offset(0, 0),
      ctrl: Offset(w * 0.5, h * 0.3),
      to: Offset(w, h * 0.5),
      spessore: sp,
    );

    // 2. Alto-destra → basso-sinistra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.15, 0.45),
      from: Offset(w, 0),
      ctrl: Offset(w * 0.4, h * 0.4),
      to: Offset(0, h * 0.6),
      spessore: sp,
    );

    // 3. Sinistra → destra nel mezzo
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.3, 0.6),
      from: Offset(0, h * 0.5),
      ctrl: Offset(w * 0.5, h * 0.3),
      to: Offset(w, h * 0.5),
      spessore: sp,
    );

    // 4. Basso-sinistra → alto-destra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.45, 0.75),
      from: Offset(0, h),
      ctrl: Offset(w * 0.6, h * 0.6),
      to: Offset(w, h * 0.2),
      spessore: sp,
    );

    // 5. Basso-destra → chiude i buchi
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.65, 1.0),
      from: Offset(w, h),
      ctrl: Offset(w * 0.3, h * 0.7),
      to: Offset(0, h * 0.4),
      spessore: sp,
    );
  }

  @override
  bool shouldRepaint(covariant RitualPainter old) => old.copertura != copertura;
}
