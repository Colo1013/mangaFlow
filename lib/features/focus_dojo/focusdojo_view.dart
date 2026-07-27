import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/models/profile_repository.dart';
import 'package:mangaflow/features/focus_dojo/providers/focus_session.dart';
import 'package:mangaflow/features/focus_dojo/providers/profile_notifier.dart';
import 'package:mangaflow/features/focus_dojo/providers/session_streak.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_circle.dart';
import 'package:mangaflow/features/focus_dojo/widgets/focus_ring_painter.dart';
import 'package:mangaflow/features/focus_dojo/widgets/manga_selection_sheet.dart';
import 'package:mangaflow/features/focus_dojo/widgets/pausa_overlay_content.dart';
import 'package:mangaflow/features/focus_dojo/widgets/ritual_painter.dart';
import 'package:mangaflow/features/focus_dojo/widgets/session_streak.dart';
import 'package:mangaflow/features/focus_dojo/widgets/session_summary_card.dart';
import 'package:mangaflow/features/focus_dojo/widgets/waiting_overlay_content.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';

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
  StatoSchermo _statoCorrente = StatoSchermo.idle;
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
    _snapController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _progressione = _progressioneTarget;
      }
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
    final streakMangasAsync = ref.watch(streakMangasProvider);
    // in cima al build, dopo ref.watch(focusSessionProvider)
    final profileAsync = ref.watch(profileProvider);
    final ultimaSessione = ref
        .read(focusSessionProvider.notifier)
        .ultimaSessione;
    final stato = ref.watch(focusSessionProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(focusSessionProvider, (previous, next) {
      _statoCorrente = next;
      _overlayEntry?.markNeedsBuild();

      if (_statoCorrente == StatoSchermo.idle) _ritualController.reverse();
    });

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                profileAsync.when(
                  data: (profile) => ExpPill(profile: profile),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                // dentro la Column del SafeArea, dopo ExpPill
                if (kDebugMode)
                  TextButton(
                    onPressed: () async {
                      await ProfileRepository().addExp(100);
                      ref.read(profileProvider.notifier).refresh();
                    },
                    child: const Text("+100 EXP (debug)"),
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
                              child: AnimatedBuilder(
                                animation: _snapController,
                                builder: (context, child) {
                                  final p = _snapController.isAnimating
                                      ? _progressioneInizio +
                                            (_progressioneTarget -
                                                    _progressioneInizio) *
                                                _snapController.value
                                      : _progressione;
                                  return CustomPaint(
                                    painter: FocusRingPainter(
                                      progressione: p,
                                      activeColor: colorScheme.primary,
                                      inactiveColor: colorScheme.onSurface,
                                    ),
                                  );
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: _onCentralTap,
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: AnimatedBuilder(
                                  animation: _snapController,
                                  builder: (context, child) {
                                    final p = _snapController.isAnimating
                                        ? _progressioneInizio +
                                              (_progressioneTarget -
                                                      _progressioneInizio) *
                                                  _snapController.value
                                        : _progressione;
                                    return FocusCircle(durata: _durataMax * p);
                                  },
                                ),
                              ),
                            ),
                            // L'AnimatedSlide con il SummaryCard è stato spostato
                            // nello Stack principale per evitare problemi di
                            // overflow dovuti all'AspectRatio.
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                streakMangasAsync.when(
                  data: (mangas) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SessionStreakCard(streakMangas: mangas),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Text('Errore nel caricamento della streak'),
                ),
              ],
            ),
          ),

          // AnimatedBuilder isola i rebuild del rituale al solo painter,
          // senza coinvolgere l'intera view a ogni frame dell'animazione.
          AnimatedBuilder(
            animation: _ritualController,
            builder: (_, _) {
              if (stato != StatoSchermo.attesa) return const SizedBox.shrink();
              return SizedBox.expand(
                child: CustomPaint(
                  painter: RitualPainter(copertura: _ritualController.value),
                ),
              );
            },
          ),

          // Summary card posizionata sopra l'intera schermata (fuori da AspectRatio)
          AnimatedSlide(
            offset: ultimaSessione != null
                ? Offset
                      .zero // visibile
                : const Offset(0, 1), // nascosta sotto lo schermo
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ultimaSessione != null
                  ? SafeArea(child: _buildSummaryCard(ultimaSessione))
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(SessionResult risultato) {
    final mangaListAsync = ref.watch(mangaListProvider);

    return mangaListAsync.when(
      data: (mangas) {
        final manga = mangas.firstWhere((m) => m.id == risultato.mangaId);
        return SessionSummaryCard(
          manga: manga,
          expGuadagnati: risultato.expGuadagnati,
          durataEffettiva: risultato.durataEffettiva,
          onDismiss: () => setState(() {
            ref.read(focusSessionProvider.notifier).ultimaSessione = null;
          }),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MangaSelectionSheet(
        onConfirm: (mangaId) {
          // questo viene chiamato DOPO che il sheet è sparito
          ref
              .read(focusSessionProvider.notifier)
              .avviaSessione(
                mangaId: mangaId,
                durata: _progressione > 0 ? _durataMax * _progressione : null,
              );
          _ritualController.reset();
          _mostraIstruzioni = false;
          final size = MediaQuery.of(context).size;
          _overlayEntry = _buildOverlayEntry(size);
          Overlay.of(context).insert(_overlayEntry!);
          _ritualController.forward();
        },
      ),
    );
  }

  // ─── Builder dell'overlay ──────────────────────────────────────────────────

  /// Costruisce l'OverlayEntry del rituale pre-sessione.
  /// Separato da [_onCentralTap] per tenere la logica di costruzione UI distinta
  /// dalla logica di avvio della sessione.
  OverlayEntry _buildOverlayEntry(Size size) {
    return OverlayEntry(
      builder: (_) => AnimatedBuilder(
        animation: _ritualController,
        builder: (_, _) => Material(
          type: MaterialType.transparency,
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Sfondo: pennellate del rituale
                CustomPaint(
                  size: size,
                  painter: RitualPainter(copertura: _ritualController.value),
                ),
                // Primo piano: istruzioni + pulsante annulla
                if (_mostraIstruzioni)
                  if (_statoCorrente == StatoSchermo.pausa)
                    PausaOverlayContent(
                      opacity: _ritualController.value,
                      screenHeight: size.height,
                      onRiprendi: () =>
                          ref.read(focusSessionProvider.notifier).riprendi(),
                      onTermina: () => ref
                          .read(focusSessionProvider.notifier)
                          .terminaSessione(),
                    )
                  else
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
