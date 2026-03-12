import 'package:mangaflow/data/database_helper.dart';
import 'package:mangaflow/data/models/manga.dart';

class MangaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Manga>> getAll() async => await _dbHelper.getMangas();

  Future<void> add(Manga manga) async => await _dbHelper.insertManga(manga);

  Future<void> update(Manga manga) async => await _dbHelper.updateManga(manga);

  Future<void> delete(Manga manga) async => await _dbHelper.deleteManga(manga);

  /// Controlla se un manga con lo stesso titolo esiste già.
  Future<bool> existsByTitle(String title) async =>
      await _dbHelper.existsByTitle(title);
}
