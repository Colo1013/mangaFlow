import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/profile.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class ExpPill extends StatelessWidget {
  final Profile profile;
  const ExpPill({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    final expAttuali = profile.totalExp;
    final expProssimoLivello = Profile.levelMap[profile.level + 1];
    final expLivelloCorrente = Profile.levelMap[profile.level] ?? 0;

    // Se non esiste un livello successivo, siamo al massimo
    final bool isMaxLevel = expProssimoLivello == null;

    final double progressione = isMaxLevel
        ? 1.0
        : (expAttuali - expLivelloCorrente) /
              (expProssimoLivello - expLivelloCorrente);

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
                padding: const EdgeInsets.all(2.5),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressione.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: profile.levelColor.withValues(alpha: 0.85),
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
                    profile.levelName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text("•", style: TextStyle(color: colorScheme.onSurface)),
                  Text(
                    isMaxLevel
                        ? "Livello Massimo"
                        : "$expAttuali/$expProssimoLivello EXP",
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
