import 'package:flutter/material.dart';
import 'package:mangaflow/features/focus_dojo/widgets/overlay_widget.dart';

class PausaOverlayContent extends StatelessWidget {
  final double opacity;
  final double screenHeight;
  final VoidCallback onRiprendi;
  final VoidCallback onTermina;

  const PausaOverlayContent({
    super.key,
    required this.opacity,
    required this.screenHeight,
    required this.onRiprendi,
    required this.onTermina,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          const OverlayTextContent(
            icon: Icons.pause_rounded,
            testo: "Sessione in pausa",
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Center(
                  child: OverlayActionButton(
                    label: "Riprendi",
                    onTap: onRiprendi,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: OverlayActionButton(
                    label: "Termina",
                    onTap: onTermina,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
