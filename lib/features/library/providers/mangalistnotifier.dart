import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/mock/mock_mangas.dart';
import 'package:mangaflow/data/models/manga.dart';

class MangaListNotifier extends Notifier<List<Manga>> {
  @override
  List<Manga> build() {
    return mockMangaList;
  }

  void incrementaCapitolo(String mangaId) {
    state = [
      for (Manga m in state)
        m.currentVolume < m.totalVolume && m.id == mangaId
            ? m.copyWith(currentVolume: m.currentVolume + 1)
            : m,
    ];
  }
}

final mangaListProvider = NotifierProvider<MangaListNotifier, List<Manga>>(() {
  return MangaListNotifier();
});
