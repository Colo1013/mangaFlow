import 'package:mangaflow/data/database_helper.dart';
import 'package:mangaflow/data/models/session.dart';

class SessionRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<void> insert(Session session) async =>
      await _db.insertSession(session);

  Future<List<Session>> getAll() async => await _db.getSessions();
}
