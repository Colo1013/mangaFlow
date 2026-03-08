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
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE mangas (id TEXT PRIMARY KEY , title TEXT, coverUrl TEXT ,currentVolume INTEGER,totalVolume INTEGER,isFavorite INTEGER )",
        );
      },
    );
  }

  Future<void> insertManga(Manga manga) async {
    final db = await instance.database;
    db.insert("mangas", manga.toMap());
  }

  Future<List<Manga>> getMangas() async {
    final db = await instance.database;
    List<Map<String, dynamic>> mappe = await db.query("mangas");

    List<Manga> out = [
      for (Map<String, dynamic> mappa in mappe) Manga.fromMap(mappa),
    ];
    return out;
  }
}
