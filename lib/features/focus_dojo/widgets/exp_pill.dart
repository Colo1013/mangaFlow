import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class ExpMockData {
  final String grado;
  final int expAttuali;
  final int expTotali;
  final Color coloreSfondo;

  const ExpMockData({
    required this.grado,
    required this.expAttuali,
    required this.expTotali,
    required this.coloreSfondo,
  });
}

class ExpPill extends StatelessWidget {
  final ExpMockData data;
  const ExpPill({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    final progressione = data.expAttuali / data.expTotali;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(50),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Layer 1 — Sfondo frosted glass
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(color: Colors.white12),
              ),
            ),
            // Layer 2 — Barra di progressione
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(2.5),

                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressione,
                  child: Container(
                    decoration: BoxDecoration(
                      color: data.coloreSfondo.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ),
            ),
            // Layer 3 — Testo
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: appSizes.medium,
                vertical: appSizes.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: appSizes.small,
                children: [
                  Text(
                    data.grado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text("•", style: TextStyle(color: colorScheme.onSurface)),
                  Text(
                    "${data.expAttuali}/${data.expTotali} EXP",
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
