import 'package:flutter/material.dart';
import 'package:mangaflow/features/focus_dojo/widgets/overlay_widget.dart';

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
      child: Stack(
        children: [
          OverlayTextContent(
            icon: Icons.phone_android_rounded,
            testo:
                "Blocca lo schermo e\nposiziona il telefono\na faccia in giù",
          ),
          Positioned(
            bottom: screenHeight * 0.12,
            left: 0,
            right: 0,
            child: Center(
              child: OverlayActionButton(label: "Annulla", onTap: onAnnulla),
            ),
          ),
        ],
      ),
    );
  }
}
