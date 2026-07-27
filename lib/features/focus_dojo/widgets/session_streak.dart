import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class SessionStreakCard extends StatelessWidget {
  final List<Manga> streakMangas;

  const SessionStreakCard({super.key, required this.streakMangas});

  // Dizionario <lunghezza streak, colore> da freddo a caldo
  Color _getBackgroundColor(BuildContext context, int streak) {
    if (streak == 0) {
      // Colore neutro del tema per lo stato "spento" (si adatta a dark/light mode)
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }

    const coloriStreak = <int, Color>{
      1: Color(0xFF4FC3F7), // Azzurro (Freddo)
      2: Color(0xFF29B6F6), // Celeste
      3: Color(0xFF26A69A), // Verde acqua
      4: Color(0xFFFFCA28), // Giallo
      5: Color(0xFFFFA726), // Arancione chiaro
      6: Color(0xFFFF7043), // Arancione scuro
      7: Color(0xFFEF5350), // Rosso (Caldo)
    };

    // Ritorna il colore corrispondente, o il rosso scuro se è > 7
    return coloriStreak[streak] ?? const Color(0xFFD32F2F);
  }

  // Calcola se il testo deve essere chiaro o scuro per essere sempre leggibile
  Color _getTextColor(Color backgroundColor, BuildContext context) {
    if (streakMangas.isEmpty) {
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final sizes = Theme.of(context).extension<AppSizeExtension>();
    final paddingMedium = sizes?.medium ?? 16.0;
    final paddingSmall = sizes?.small ?? 8.0;
    final radiusBig = sizes?.bigradius ?? 16.0;
    final radiusSmall = sizes?.smallradius ?? 12.0;

    final streak = streakMangas.length;
    final bgColor = _getBackgroundColor(context, streak);
    final textColor = _getTextColor(bgColor, context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(paddingMedium),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radiusBig),
        boxShadow: streak > 0
            ? [
                BoxShadow(
                  color: bgColor.withValues(alpha: .4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [], // Nessuna ombra se la streak è a zero
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITOLO
          Row(
            children: [
              Icon(
                streak > 0 ? Icons.local_fire_department : Icons.schedule,
                color: textColor,
              ),
              SizedBox(width: paddingSmall),
              Text(
                'Streak: $streak giorn${streak == 1 ? 'o' : 'i'}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: paddingMedium),

          // CONTENUTO (Lista copertine o messaggio vuoto)
          if (streak == 0)
            Text(
              "Nessuna streak attiva. Inizia a leggere oggi per accendere la fiamma! 🔥",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: textColor),
            )
          else
            SizedBox(
              height: 120, // Altezza fissa per le copertine
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: streakMangas.length,
                separatorBuilder: (context, index) =>
                    SizedBox(width: paddingSmall),
                itemBuilder: (context, index) {
                  final manga = streakMangas[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(radiusSmall),
                    child: AspectRatio(
                      aspectRatio: 2 / 3, // Proporzione classica dei manga
                      child: CachedNetworkImage(
                        imageUrl: manga.coverUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: Icon(Icons.menu_book, color: textColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
