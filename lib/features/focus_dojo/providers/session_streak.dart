import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/data/models/session.dart';
import 'package:mangaflow/data/models/session_repository.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_streak.g.dart';

@riverpod
Future<List<Manga>> streakMangas(Ref ref) async {
  // 1. Prendi tutte le sessioni e se non ci sono, ritorna lista vuota
  final sessioni = await SessionRepository().getAll();
  if (sessioni.isEmpty) return [];

  // Ordina dalla più recente alla meno recente
  sessioni.sort((a, b) => b.startTimestamp.compareTo(a.startTimestamp));

  final now = DateTime.now();
  final oggi = DateTime(now.year, now.month, now.day);
  final ieri = oggi.subtract(const Duration(days: 1));

  final sessioniStreak = <Session>[];
  DateTime? ultimoGiornoConsiderato;

  // 2. Crea la lista di sessioni che formano la streak
  for (final sessione in sessioni) {
    final d = DateTime.fromMillisecondsSinceEpoch(sessione.startTimestamp);
    final giornoSessione = DateTime(d.year, d.month, d.day);

    // Se è la prima sessione che valutiamo (la più recente in assoluto)
    if (ultimoGiornoConsiderato == null) {
      if (giornoSessione.isBefore(ieri)) {
        return []; // Se la lettura più recente è prima di ieri, la streak è morta
      }
      sessioniStreak.add(sessione);
      ultimoGiornoConsiderato = giornoSessione;
      continue;
    }

    // Ignora le altre sessioni dello stesso giorno (prendiamo solo la prima/più recente)
    if (giornoSessione.isAtSameMomentAs(ultimoGiornoConsiderato)) {
      continue;
    }

    // Se la sessione è esattamente del giorno precedente all'ultimo considerato, allunga la streak
    if (ultimoGiornoConsiderato.difference(giornoSessione).inDays == 1) {
      sessioniStreak.add(sessione);
      ultimoGiornoConsiderato = giornoSessione;
    } else {
      break; // Buco di più giorni, la streak si ferma qui
    }
  }

  // 3. Naviga la lista di sessioni della streak per prendere i Manga corrispondenti
  final tuttiIManga = await ref.watch(mangaListProvider.future);
  final mangaStreak = <Manga>[];

  for (final sessione in sessioniStreak) {
    // firstOrNull restituisce null se non trova nulla, niente eccezioni!
    final manga = tuttiIManga
        .where((m) => m.id == sessione.mangaId)
        .firstOrNull;

    if (manga != null) {
      mangaStreak.add(manga);
    }
  }

  return mangaStreak;
}
