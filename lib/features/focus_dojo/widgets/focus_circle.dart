import 'package:flutter/material.dart';

class FocusCircle extends StatelessWidget {
  final Duration durata;
  const FocusCircle({super.key, required this.durata});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white12,
            shape: BoxShape.circle,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              durata.inMinutes == 0
                  ? "∞"
                  : "${(durata.inMinutes).toString().padLeft(2, '0')} : ${(durata.inSeconds % 60).toString().padLeft(2, '0')}",
            ),
            Text(
              durata.inMinutes == 0 ? "Sessione Libera" : "Sessione a tempo",
            ),
          ],
        ),
      ],
    );
  }
}
