import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottomnavindiexnotifier.g.dart';

@riverpod
class BottomNavIndexNotifier extends _$BottomNavIndexNotifier {
  @override
  int build() {
    return 0; // Indice iniziale
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}
