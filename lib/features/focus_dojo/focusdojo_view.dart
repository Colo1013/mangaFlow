import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/providers/focus_session.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_circle.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';
import 'package:mangaflow/features/focus_dojo/widgets/ritual_painter.dart';
import 'package:mangaflow/features/focus_dojo/widgets/waiting_overlay_content.dart';

class FocusdojoView extends ConsumerStatefulWidget {
  const FocusdojoView({super.key});

  @override
  ConsumerState<FocusdojoView> createState() => _FocusdojoViewState();
}

class _FocusdojoViewState extends ConsumerState<FocusdojoView>
    with TickerProviderStateMixin {
  static const Duration _durataMax = Duration(hours: 1);

  double _progressione = 0.0;
  double _progressioneTarget = 0.0;
  double _progressioneInizio = 0.0;
  final _ringKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _mostraIstruzioni = false;

  // Rinominato da _controller: gestisce lo "snap" dell'anello ai multipli di 5 min.
  late AnimationController _snapController;
  // Gestisce la transizione grafica del rituale pre-sessione.
  late AnimationController _ritualController;

  @override
  void initState() {
    super.initState();

    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _snapController.addListener(() {
      // setState necessario: aggiorna _progressione usata dal FocusRingPainter nel body.
      setState(() {
        _progressione =
            _progressioneInizio +
            (_progressioneTarget - _progressioneInizio) * _snapController.value;
      });
    });

    _ritualController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    // Nessun addListener con setState: l'AnimatedBuilder nel body si occupa
    // di aggiornare il painter del rituale a ogni frame senza rebuild globali.
    _ritualController.addStatusListener(_onRitualStatusChanged);
  }

  void _onRitualStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _mostraIstruzioni = true;
      _overlayEntry?.markNeedsBuild();
    }
    // Animazione inversa completata → pulizia overlay.
    if (status == AnimationStatus.dismissed) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _mostraIstruzioni = false;
    }
  }

  @override
  void dispose() {
    _snapController.dispose();
    _ritualController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stato = ref.watch(focusSessionProvider);
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
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
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

          // AnimatedBuilder isola i rebuild del rituale al solo painter,
          // senza coinvolgere l'intera view a ogni frame dell'animazione.
          AnimatedBuilder(
            animation: _ritualController,
            builder: (_, __) {
              if (stato != StatoSchermo.attesa) return const SizedBox.shrink();
              return SizedBox.expand(
                child: CustomPaint(
                  painter: RitualPainter(copertura: _ritualController.value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Gesture handlers ──────────────────────────────────────────────────────

  void _onPanStart(DragStartDetails details) => _snapController.stop();

  void _onPanUpdate(DragUpdateDetails details) {
    final pos = details.localPosition;
    final size =
        (_ringKey.currentContext!.findRenderObject() as RenderBox).size;
    final dx = pos.dx - size.width / 2;
    final dy = pos.dy - size.height / 2;
    final angolo = (atan2(dy, dx) + pi / 2) % (2 * pi);
    final nuovaProgressione = angolo / (2 * pi);
    if ((nuovaProgressione - _progressione).abs() > 0.5) return;
    setState(() => _progressione = nuovaProgressione);
  }

  void _onPanEnd(DragEndDetails details) {
    _progressioneInizio = _progressione;
    const double passo = 5 / 60;
    _progressioneTarget = (_progressioneInizio / passo).roundToDouble() * passo;
    _snapController.reset();
    _snapController.forward();
  }

  // ─── Logica sessione ───────────────────────────────────────────────────────

  void _tornaIndietro() {
    ref.read(focusSessionProvider.notifier).annullaSessione();
    // Il listener su 'dismissed' si occupa di rimuovere l'overlay e resettare lo stato.
    _ritualController.reverse();
  }

  void _onCentralTap() {
    ref
        .read(focusSessionProvider.notifier)
        .avviaSessione(
          durata: _progressione > 0 ? _durataMax * _progressione : null,
        );
    _ritualController.reset();
    _mostraIstruzioni = false;

    final size = MediaQuery.of(context).size;
    _overlayEntry = _buildOverlayEntry(size);
    Overlay.of(context).insert(_overlayEntry!);
    _ritualController.forward();
  }

  // ─── Builder dell'overlay ──────────────────────────────────────────────────

  /// Costruisce l'OverlayEntry del rituale pre-sessione.
  /// Separato da [_onCentralTap] per tenere la logica di costruzione UI distinta
  /// dalla logica di avvio della sessione.
  OverlayEntry _buildOverlayEntry(Size size) {
    return OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _ritualController,
        builder: (_, __) => Material(
          type: MaterialType.transparency,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                // Sfondo: pennellate del rituale
                CustomPaint(
                  size: size,
                  painter: RitualPainter(copertura: _ritualController.value),
                ),
                // Primo piano: istruzioni + pulsante annulla
                if (_mostraIstruzioni)
                  WaitingOverlayContent(
                    opacity: _ritualController.value,
                    screenHeight: size.height,
                    onAnnulla: _tornaIndietro,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
