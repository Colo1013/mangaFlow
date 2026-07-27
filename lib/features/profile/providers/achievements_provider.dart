import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mangaflow/data/models/session_repository.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/features/focus_dojo/providers/profile_notifier.dart';

part 'achievements_provider.g.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.isUnlocked,
  });
}

@riverpod
Future<List<Achievement>> achievements(Ref ref) async {
  final mangaList = await ref.watch(mangaListProvider.future);
  final sessions = await SessionRepository().getAll();
  final profile = await ref.watch(profileProvider.future);

  return [
    Achievement(
      id: "primo_passo",
      title: "Primo Passo",
      description: "Avvia la tua prima sessione nel Dojo",
      isUnlocked: sessions.isNotEmpty,
    ),
    Achievement(
      id: "collezionista",
      title: "Collezionista",
      description: "Aggiungi 5 manga alla libreria",
      isUnlocked: mangaList.length >= 5,
    ),
    Achievement(
      id: "apprendista",
      title: "Focus Apprendista",
      description: "Accumula 1000 EXP",
      isUnlocked: profile.totalExp >= 1000,
    ),
  ];
}
