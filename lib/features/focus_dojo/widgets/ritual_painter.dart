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
    required Offset ctrl,
    required Offset to,
    required double spessore,
  }) {
    if (progresso <= 0) return;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = spessore
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(from.dx, from.dy);
    path.quadraticBezierTo(ctrl.dx, ctrl.dy, to.dx, to.dy);

    final metric = path.computeMetrics().first;
    final parziale = metric.extractPath(0, metric.length * progresso);
    canvas.drawPath(parziale, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final sp = w * 0.58;

    // 1. Alto-sinistra → basso-destra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.00, 0.20),
      from: Offset(-w * 0.1, h * 0.1),
      ctrl: Offset(w * 0.85, -h * 0.15),
      to: Offset(w * 1.1, h * 0.55),
      spessore: sp,
    );

    // 2. Alto-destra → basso-sinistra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.14, 0.34),
      from: Offset(w * 1.1, -h * 0.05),
      ctrl: Offset(w * 0.15, h * 0.85),
      to: Offset(-w * 0.1, h * 0.5),
      spessore: sp,
    );

    // 3. Sinistra → destra, arco verso l'alto
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.27, 0.47),
      from: Offset(0, h * 0.45),
      ctrl: Offset(w * 0.5, -h * 0.2),
      to: Offset(w, h * 0.55),
      spessore: sp,
    );

    // 4. Basso-sinistra → alto-destra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.40, 0.60),
      from: Offset(-w * 0.05, h * 1.1),
      ctrl: Offset(w * 0.9, h * 0.4),
      to: Offset(w * 1.05, -h * 0.05),
      spessore: sp,
    );

    // 5. Alto-centro → basso, curva verso sinistra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.52, 0.72),
      from: Offset(w * 0.55, -h * 0.1),
      ctrl: Offset(-w * 0.15, h * 0.5),
      to: Offset(w * 0.4, h * 1.1),
      spessore: sp,
    );

    // 6. Destra-centro → basso-sinistra
    //    ctrl puntato verso centro-destra per coprire il buco
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.63, 0.83),
      from: Offset(w * 1.1, h * 0.3),
      ctrl: Offset(w * 0.75, h * 0.45),
      to: Offset(0, h * 0.9),
      spessore: sp,
    );

    // 7. Basso-destra → chiude angoli rimasti
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.80, 1.00),
      from: Offset(w * 1.05, h * 1.05),
      ctrl: Offset(w * 0.1, h * 0.6),
      to: Offset(w * 0.2, -h * 0.05),
      spessore: sp,
    );

    // 8. (NUOVA) Dedicata al cuneo bottom-right
    //    entra da destra, abbraccia l'angolo con ctrl in basso-destra
    _disegna(
      canvas: canvas,
      progresso: _progresso(0.88, 1.00),
      from: Offset(w * 1.1, h * 0.75),
      ctrl: Offset(w * 0.95, h * 1.1),
      to: Offset(w * 0.4, h * 1.1),
      spessore: sp,
    );
  }

  @override
  bool shouldRepaint(covariant RitualPainter old) => old.copertura != copertura;
}
