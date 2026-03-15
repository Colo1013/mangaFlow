import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_circle.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';

class FocusdojoView extends ConsumerStatefulWidget {
  const FocusdojoView({super.key});

  @override
  ConsumerState<FocusdojoView> createState() => _FocusdojoViewState();
}

class _FocusdojoViewState extends ConsumerState<FocusdojoView>
    with SingleTickerProviderStateMixin {
  static const Duration _durataMax = Duration(hours: 1);
  double _progressione = 0.0;
  double _progressioneTarget = 0.0;
  double _progressioneInizio = 0.0;
  final _ringKey = GlobalKey();

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.addListener(() {
      setState(() {
        _progressione =
            _progressioneInizio +
            (_progressioneTarget - _progressioneInizio) * _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ExpPill(
              data: ExpMockData(
                grado: "Novizio",
                expAttuali: 150,
                expTotali: 300,
                coloreSfondo: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onPanStart: (details) => _onPanStart(details),
                onPanUpdate: (details) => _onPanUpdate(details),
                onPanEnd: (details) => _onPanEnd(details),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    key: _ringKey,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox.expand(
                          child: CustomPaint(
                            painter: FocusRingPainter(
                              progressione: _progressione,
                              activeColor: colorScheme.primary,
                              inactiveColor: colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(18),
                          child: FocusCircle(
                            durata: _durataMax * _progressione,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    _controller.stop();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final pos = details.localPosition;
    final size =
        (_ringKey.currentContext!.findRenderObject() as RenderBox).size;
    final dx = pos.dx - size.width / 2;
    final dy = pos.dy - size.height / 2;
    final angolo = (atan2(dy, dx) + pi / 2) % (2 * pi);
    final nuovaProgressione = angolo / (2 * pi);

    if ((nuovaProgressione - _progressione).abs() > 0.5) return;

    setState(() {
      _progressione = nuovaProgressione;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    _progressioneInizio = _progressione;
    const double passo = 5 / 60;
    _progressioneTarget = (_progressioneInizio / passo).roundToDouble() * passo;
    _controller.reset();
    _controller.forward();
  }
}
