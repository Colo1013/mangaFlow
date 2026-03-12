import 'package:mangaflow/data/models/manga.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String cartella = await getDatabasesPath();
    String percorso = join(cartella, "mangas.db");
    return await openDatabase(
      percorso,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE mangas (id TEXT PRIMARY KEY, title TEXT UNIQUE, coverUrl TEXT, currentVolume INTEGER, totalVolume INTEGER, isFavorite INTEGER)",
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE mangas RENAME TO mangas_old');
          await db.execute(
            'CREATE TABLE mangas (id TEXT PRIMARY KEY, title TEXT UNIQUE, coverUrl TEXT, currentVolume INTEGER, totalVolume INTEGER, isFavorite INTEGER)',
          );
          await db.execute(
            'INSERT OR IGNORE INTO mangas SELECT * FROM mangas_old',
          );
          await db.execute('DROP TABLE mangas_old');
        }
      },
    );
  }

  Future<void> insertManga(Manga manga) async {
    final db = await instance.database;
    await db.insert(
      "mangas",
      manga.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Controlla se un manga con lo stesso titolo esiste già (case-insensitive).
  Future<bool> existsByTitle(String title) async {
    final db = await instance.database;
    final result = await db.query(
      "mangas",
      where: "LOWER(title) = LOWER(?)",
      whereArgs: [title.trim()],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<Manga>> getMangas() async {
    final db = await instance.database;
    List<Map<String, dynamic>> mappe = await db.query("mangas");

    List<Manga> out = [
      for (Map<String, dynamic> mappa in mappe) Manga.fromMap(mappa),
    ];
    return out;
  }

  Future<void> updateManga(Manga manga) async {
    final db = await instance.database;
    await db.update(
      "mangas",
      manga.toMap(),
      where: "id = ?",
      whereArgs: [manga.id],
    );
  }

  Future<void> deleteManga(Manga manga) async {
    final db = await instance.database;
    await db.delete("mangas", where: "id = ?", whereArgs: [manga.id]);
  }
}
