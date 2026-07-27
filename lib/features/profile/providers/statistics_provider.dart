import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangaflow/data/models/session_repository.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';

part 'statistics_provider.g.dart';

class ProfileStatistics {
  final Duration totalFocusTime;
  final int totalVolumesRead;
  final String? mostReadMangaTitle;

  const ProfileStatistics({
    this.totalFocusTime = Duration.zero,
    this.totalVolumesRead = 0,
    this.mostReadMangaTitle,
  });
}

@riverpod
Future<ProfileStatistics> profileStatistics(Ref ref) async {
  // We use .future to wait for the manga list to load
  final mangaList = await ref.watch(mangaListProvider.future);
  final sessions = await SessionRepository().getAll();

  int totalVolumes = 0;
  for (final manga in mangaList) {
    totalVolumes += (manga.currentVolume as num).toInt();
  }

  int totalTimeMs = 0;
  final Map<String, int> durationPerManga = {};

  for (final session in sessions) {
    final duration = session.endTimestamp - session.startTimestamp;
    if (duration > 0) {
      totalTimeMs += duration;
      durationPerManga[session.mangaId] =
          (durationPerManga[session.mangaId] ?? 0) + duration;
    }
  }

  String? mostReadMangaTitle;
  if (durationPerManga.isNotEmpty) {
    var maxEntry =
        durationPerManga.entries.reduce((a, b) => a.value > b.value ? a : b);
    try {
      final bestManga = mangaList.firstWhere((m) => m.id == maxEntry.key);
      mostReadMangaTitle = bestManga.title;
    } catch (_) {
      mostReadMangaTitle = "Sconosciuto";
    }
  }

  return ProfileStatistics(
    totalFocusTime: Duration(milliseconds: totalTimeMs),
    totalVolumesRead: totalVolumes,
    mostReadMangaTitle: mostReadMangaTitle,
  );
}
