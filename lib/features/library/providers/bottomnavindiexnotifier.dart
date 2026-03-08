import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 0; // Indice iniziale
  }

  void setIndex(int newIndex) {
    state = newIndex;
  }
}

// 2. Dichiariamo il NotifierProvider
final bottomNavIndexProvider = NotifierProvider<BottomNavIndexNotifier, int>(
  () {
    return BottomNavIndexNotifier();
  },
);
