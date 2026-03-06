import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/mock/mock_mangas.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/mangaDetail_view.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Manga> listaAttuale = ref.watch(mangaListProvider);
    return GridView.builder(
      padding: EdgeInsets.all(16),
      itemCount: listaAttuale.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        final manga = listaAttuale[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MangadetailView(manga: manga),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),

              boxShadow: [BoxShadow(color: Colors.black12)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(manga.coverUrl, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
