import 'package:mangaflow/data/models/session.dart';
import 'package:mangaflow/data/models/session_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_streak.g.dart';

class SessionStreakNotifier extends _$SessionStrekNotifier {
  @riverpod
  Future<List<Session>> sessionList(Ref ref) async {
    return await SessionRepository().getAll();
  }

  int calcolaStreak(List<Session> sessioni) {
    if (sessioni.isEmpty) return 0;

    // Estrai i giorni unici in ordine decrescente
    final giorniUnici =
        sessioni
            .map((s) => DateTime.fromMillisecondsSinceEpoch(s.startTimestamp))
            .map(
              (d) => DateTime(d.year, d.month, d.day),
            ) // azzera ore/minuti/secondi
            .toSet() // rimuovi duplicati stesso giorno
            .toList()
          ..sort((a, b) => b.compareTo(a)); // ordine decrescente

    int streak = 1;
    for (int i = 0; i < giorniUnici.length - 1; i++) {
      final differenza = giorniUnici[i].difference(giorniUnici[i + 1]).inDays;
      if (differenza == 1) {
        streak++;
      } else {
        break; // streak interrotta
      }
    }
    return streak;
  }
}
