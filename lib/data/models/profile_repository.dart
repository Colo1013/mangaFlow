import 'package:mangaflow/data/database_helper.dart';
import 'package:mangaflow/data/models/profile.dart';

class ProfileRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<Profile> getProfile() async => await _db.getProfile();

  Future<void> insert(Profile profile) async =>
      await _db.insertProfile(profile);

  Future<void> update(Profile profile) async =>
      await _db.updateProfile(profile);

  Future<void> addExp(int exp) async {
    final profilo = await getProfile();
    await update(profilo.copyWith(totalExp: profilo.totalExp + exp));
  }
}
