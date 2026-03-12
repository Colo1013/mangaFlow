import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mangaflow/data/manga_repository.dart';
import 'package:mangaflow/data/models/manga.dart';

part 'mangalistnotifier.g.dart';

@riverpod
class MangaListNotifier extends _$MangaListNotifier {
  final MangaRepository _repository = MangaRepository();

  @override
  Future<List<Manga>> build() async {
    return await _repository.getAll();
  }

  Future<void> incrementaCapitolo(String mangaId) async {
    final listaAttuale = state.value;
    if (listaAttuale == null) return;

    final indice = listaAttuale.indexWhere((m) => m.id == mangaId);
    if (indice == -1) return;

    final manga = listaAttuale[indice];
    if (manga.currentVolume >= manga.totalVolume) return;

    final mangaAggiornato = manga.copyWith(
      currentVolume: manga.currentVolume + 1,
    );

    try {
      await _repository.update(mangaAggiornato);
      state = AsyncData([
        ...listaAttuale.sublist(0, indice),
        mangaAggiornato,
        ...listaAttuale.sublist(indice + 1),
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> aggiungiPreferiti(String mangaId) async {
    final listaAttuale = state.value;
    if (listaAttuale == null) return;

    final indice = listaAttuale.indexWhere((m) => m.id == mangaId);
    if (indice == -1) return;

    final manga = listaAttuale[indice];
    final mangaAggiornato = manga.copyWith(isFavorite: !manga.isFavorite);

    try {
      await _repository.update(mangaAggiornato);
      state = AsyncData([
        ...listaAttuale.sublist(0, indice),
        mangaAggiornato,
        ...listaAttuale.sublist(indice + 1),
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Aggiorna il numero totale di volumi di un manga.
  /// Il nuovo totale non può essere inferiore al volume corrente.
  Future<void> aggiornaTotaleVolumi(String mangaId, int nuovoTotale) async {
    final listaAttuale = state.value;
    if (listaAttuale == null) return;

    final indice = listaAttuale.indexWhere((m) => m.id == mangaId);
    if (indice == -1) return;

    final manga = listaAttuale[indice];
    if (nuovoTotale < manga.currentVolume) return;

    final mangaAggiornato = manga.copyWith(totalVolume: nuovoTotale);

    try {
      await _repository.update(mangaAggiornato);
      state = AsyncData([
        ...listaAttuale.sublist(0, indice),
        mangaAggiornato,
        ...listaAttuale.sublist(indice + 1),
      ]);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Aggiunge un manga. Ritorna `false` se esiste già un manga con lo stesso titolo.
  Future<bool> aggiungiManga(Manga manga) async {
    final esiste = await _repository.existsByTitle(manga.title);
    if (esiste) return false;

    await _repository.add(manga);
    state = AsyncData([...state.value!, manga]);
    return true;
  }

  Future<void> eliminaManga(Manga manga) async {
    await _repository.delete(manga);
    state = AsyncData(state.value!.where((m) => m.id != manga.id).toList());
  }
}
