import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_circle.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';
import 'package:mangaflow/features/focus_dojo/widgets/ritual_painter.dart';

enum _StatoSchermo { idle, attesa, attiva, pausa }

class FocusdojoView extends ConsumerStatefulWidget {
  const FocusdojoView({super.key});

  @override
  ConsumerState<FocusdojoView> createState() => _FocusdojoViewState();
}

class _FocusdojoViewState extends ConsumerState<FocusdojoView>
    with TickerProviderStateMixin {
  static const Duration _durataMax = Duration(hours: 1);
  _StatoSchermo _stato = _StatoSchermo.idle;
  double _progressione = 0.0;
  double _progressioneTarget = 0.0;
  double _progressioneInizio = 0.0;
  final _ringKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _mostraIstruzioni = false;

  late AnimationController _controller;
  late AnimationController _ritualController;

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
    _ritualController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _ritualController.addListener(() => setState(() {}));
    _ritualController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _mostraIstruzioni = true;
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _ritualController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                            GestureDetector(
                              onTap: _onCentralTap,
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: FocusCircle(
                                  durata: _durataMax * _progressione,
                                ),
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
          // Overlay del rituale — copre tutto, notch incluso
          if (_stato == _StatoSchermo.attesa)
            SizedBox.expand(
              child: CustomPaint(
                painter: RitualPainter(copertura: _ritualController.value),
              ),
            ),
        ],
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

  void _onCentralTap() {
    setState(() => _stato = _StatoSchermo.attesa);
    _ritualController.reset();

    final size = MediaQuery.of(context).size;

    _overlayEntry = OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _ritualController,
        builder: (_, __) => SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              CustomPaint(
                size: size,
                painter: RitualPainter(copertura: _ritualController.value),
              ),
              if (_mostraIstruzioni)
                AnimatedOpacity(
                  opacity: _mostraIstruzioni ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: const Center(
                    child: Text(
                      "Blocca lo schermo e\nposiziona il telefono\na faccia in giù",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    _ritualController.forward();
  }
}
