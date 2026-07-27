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

    // 1. Salviamo lo stato precedente per eventuale rollback
    final statoPrecedente = listaAttuale;

    // 2. Aggiornamento ottimistico (la UI si aggiorna istantaneamente)
    state = AsyncData([
      ...listaAttuale.sublist(0, indice),
      mangaAggiornato,
      ...listaAttuale.sublist(indice + 1),
    ]);

    // 3. Tentiamo l'aggiornamento sul DB
    try {
      await _repository.update(mangaAggiornato);
    } catch (e) {
      // 4. Rollback in caso di errore e propagazione dell'eccezione
      state = AsyncData(statoPrecedente);
      throw Exception("Impossibile aggiornare il capitolo. Riprova.");
    }
  }

  Future<void> aggiungiPreferiti(String mangaId) async {
    final listaAttuale = state.value;
    if (listaAttuale == null) return;

    final indice = listaAttuale.indexWhere((m) => m.id == mangaId);
    if (indice == -1) return;

    final manga = listaAttuale[indice];
    final mangaAggiornato = manga.copyWith(isFavorite: !manga.isFavorite);

    final statoPrecedente = listaAttuale;

    state = AsyncData([
      ...listaAttuale.sublist(0, indice),
      mangaAggiornato,
      ...listaAttuale.sublist(indice + 1),
    ]);

    try {
      await _repository.update(mangaAggiornato);
    } catch (e) {
      state = AsyncData(statoPrecedente);
      throw Exception("Impossibile aggiornare i preferiti.");
    }
  }

  Future<void> aggiornaTotaleVolumi(String mangaId, int nuovoTotale) async {
    final listaAttuale = state.value;
    if (listaAttuale == null) return;

    final indice = listaAttuale.indexWhere((m) => m.id == mangaId);
    if (indice == -1) return;

    final manga = listaAttuale[indice];
    if (nuovoTotale < manga.currentVolume) return;

    final mangaAggiornato = manga.copyWith(totalVolume: nuovoTotale);

    final statoPrecedente = listaAttuale;

    state = AsyncData([
      ...listaAttuale.sublist(0, indice),
      mangaAggiornato,
      ...listaAttuale.sublist(indice + 1),
    ]);

    try {
      await _repository.update(mangaAggiornato);
    } catch (e) {
      state = AsyncData(statoPrecedente);
      throw Exception("Impossibile aggiornare il totale dei volumi.");
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
