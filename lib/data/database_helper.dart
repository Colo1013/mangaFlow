import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/data/models/profile.dart';
import 'package:mangaflow/data/models/session.dart';
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
      version: 4,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE mangas (id TEXT PRIMARY KEY, title TEXT UNIQUE, coverUrl TEXT, currentVolume INTEGER, totalVolume INTEGER, isFavorite INTEGER)",
        );
        await db.execute(
          "CREATE TABLE sessions (startTimestamp INTEGER PRIMARY KEY,endTimestamp INTEGER, mangaId TEXT, expGained INTEGER )",
        );
        await db.execute(
          "CREATE TABLE profile (id TEXT PRIMARY KEY, userName TEXT, totalExp INTEGER)",
        );
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE mangas RENAME TO mangas_old');
          await db.execute(
            'CREATE TABLE mangas (id TEXT PRIMARY KEY, title TEXT UNIQUE, coverUrl TEXT, currentVolume INTEGER, totalVolume INTEGER, isFavorite INTEGER)',
          );
          await db.execute(
            'INSERT OR IGNORE INTO mangas SELECT * FROM mangas_old',
          );
          await db.execute('DROP TABLE mangas_old');
          await db.execute('DROP TABLE IF EXISTS sessions');
          await db.execute('DROP TABLE IF EXISTS profile');
          await db.execute(
            "CREATE TABLE sessions (startTimestamp INTEGER PRIMARY KEY,endTimestamp INTEGER, mangaId TEXT, expGained INTEGER )",
          );
          await db.execute(
            "CREATE TABLE profile (id TEXT PRIMARY KEY, userName TEXT, totalExp INTEGER)",
          );
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

  Future<void> insertSession(Session session) async {
    final db = await instance.database;
    await db.insert(
      "sessions",
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> insertProfile(Profile profile) async {
    final db = await instance.database;
    await db.insert(
      "profile",
      profile.toMap(),
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

  Future<Profile> getProfile() async {
    final db = await instance.database;
    List<Map<String, dynamic>> mappe = await db.query("profile");
    if (mappe.isEmpty) {
      Profile base = Profile(totalExp: 0, userName: "Empty");
      await insertProfile(base);
      return base;
    }
    return Profile.fromMap(mappe.single);
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

  Future<void> updateProfile(Profile profile) async {
    final db = await instance.database;

    await db.update(
      "profile",
      profile.toMap(),
      where: "id = ?",
      whereArgs: [profile.id],
    );
  }

  Future<void> deleteManga(Manga manga) async {
    final db = await instance.database;
    await db.delete("mangas", where: "id = ?", whereArgs: [manga.id]);
  }

  Future<List<Session>> getSessions() async {
    final db = await instance.database;
    final mappe = await db.query("sessions", orderBy: "startTimestamp DESC");
    return [for (final m in mappe) Session.fromMap(m)];
  }
}
