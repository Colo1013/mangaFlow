import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/mock/mock_mangas.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/mangaDetail_view.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Manga> listaAttuale = ref.watch(mangaListProvider);
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Continua a leggere"),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listaAttuale.length,
              itemBuilder: (BuildContext context, int index) {
                final manga = listaAttuale[index];

                return Container(
                  width: 150,
                  margin: EdgeInsets.all(appSizes.small),
                  color: Colors.blueAccent,
                  child: Center(child: Text(manga.title)),
                );
              },
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(appSizes.medium),
            itemCount: listaAttuale.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: appSizes.medium,
              mainAxisSpacing: appSizes.medium,
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

                    boxShadow: [
                      BoxShadow(color: Theme.of(context).colorScheme.shadow),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(manga.coverUrl, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
