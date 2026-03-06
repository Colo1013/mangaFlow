import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import '../../data/models/manga.dart';

class MangadetailView extends ConsumerWidget {
  final Manga manga;

  const MangadetailView({super.key, required this.manga});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Manga> listaAttuale = ref.watch(mangaListProvider);
    Manga mangaAggiornato = listaAttuale.firstWhere((m) => m.id == manga.id);
    return Scaffold(
      appBar: AppBar(title: Text("Dettagli")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(manga.coverUrl, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Text(
                "Titolo : ${manga.title}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Capitoli letti : ${mangaAggiornato.currentVolume}, su : ${manga.totalVolume} capitoli",
                  ),
                  SizedBox(width: 50),
                  ElevatedButton.icon(
                    icon: Icon(Icons.plus_one),
                    onPressed: () {
                      ref
                          .read(mangaListProvider.notifier)
                          .incrementaCapitolo(manga.id);
                    },
                    label: Text("Aumenta Capitolo"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
