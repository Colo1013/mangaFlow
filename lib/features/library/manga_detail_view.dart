import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/core/widgets/apple_button.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import '../../data/models/manga.dart';

class MangaDetailView extends ConsumerWidget {
  final Manga manga;

  const MangaDetailView({super.key, required this.manga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Manga mangaAggiornato = ref.watch(
      mangaListProvider.select(
        (lista) =>
            lista.firstWhere((m) => m.id == manga.id, orElse: () => manga),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dettagli",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              mangaAggiornato.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: mangaAggiornato.isFavorite ? Colors.redAccent : null,
            ),
            onPressed: () {
              ref.read(mangaListProvider.notifier).aggiungiPreferiti(manga.id);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            _CoverImage(coverUrl: mangaAggiornato.coverUrl),
            const SizedBox(height: 24),
            Text(
              mangaAggiornato.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            _ReadingProgress(
              currentVolume: mangaAggiornato.currentVolume,
              totalVolume: mangaAggiornato.totalVolume,
            ),
            const SizedBox(height: 32),
            AppleButton(
              icon: Icons.add_rounded,
              label: "Aggiungi Capitolo",
              onPressed: () {
                ref
                    .read(mangaListProvider.notifier)
                    .incrementaCapitolo(manga.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  final String coverUrl;

  const _CoverImage({required this.coverUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          coverUrl,
          width: 220,
          height: 330,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _ReadingProgress extends StatelessWidget {
  final int currentVolume;
  final int totalVolume;

  const _ReadingProgress({
    required this.currentVolume,
    required this.totalVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            "Letti: $currentVolume / $totalVolume",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
