import 'package:mangaflow/data/models/profile.dart';
import 'package:mangaflow/data/models/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  final ProfileRepository _repository = ProfileRepository();

  @override
  Future<Profile> build() async {
    return await _repository.getProfile();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _repository.getProfile());
  }
}
