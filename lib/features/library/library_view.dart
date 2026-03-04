import 'package:flutter/material.dart';
import 'package:mangaflow/data/mock/mock_mangas.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      itemCount: mockMangaList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (BuildContext context, int index) {
        final manga = mockMangaList[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),

            boxShadow: [BoxShadow(color: Colors.black12)],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(manga.coverUrl, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
