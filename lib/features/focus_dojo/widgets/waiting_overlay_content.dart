import 'package:flutter/material.dart';

/// Contenuto visivo mostrato sopra il [RitualPainter] una volta completata
/// l'animazione di copertura dello schermo.
///
/// Riceve [opacity] direttamente dall'[AnimationController] del rituale,
/// così da essere già sincronizzato senza bisogno di un controller proprio.
class WaitingOverlayContent extends StatelessWidget {
  final double opacity;
  final double screenHeight;
  final VoidCallback onAnnulla;

  const WaitingOverlayContent({
    super.key,
    required this.opacity,
    required this.screenHeight,
    required this.onAnnulla,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Stack(children: [_buildCenterContent(), _buildCancelButton()]),
    );
  }

  /// Icona del telefono + testo istruzioni centrati verticalmente.
  Widget _buildCenterContent() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.08),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
            child: const Text(
              "Blocca lo schermo e\nposiziona il telefono\na faccia in giù",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.5,
                height: 1.4,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pulsante "Annulla" posizionato in basso allo schermo.
  Widget _buildCancelButton() {
    return Positioned(
      bottom: screenHeight * 0.12,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: onAnnulla,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
              color: Colors.white.withValues(alpha: 0.08),
            ),
            child: const Text(
              "Annulla",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
