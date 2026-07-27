import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/providers/profile_notifier.dart';
import 'package:mangaflow/features/focus_dojo/providers/session_streak.dart';
import 'package:mangaflow/features/focus_dojo/widgets/exp_pill.dart';
import 'package:mangaflow/features/focus_dojo/widgets/session_streak.dart';
import 'package:mangaflow/features/profile/widgets/profile_edit_sheet.dart';
import 'package:mangaflow/features/profile/widgets/statistics_card.dart';
import 'package:mangaflow/features/profile/widgets/achievements_card.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final streakMangasAsync = ref.watch(streakMangasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Placeholder for future settings screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impostazioni in arrivo!')),
              );
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Profilo
                Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: profile.levelColor,
                                width: 4,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                backgroundImage: AssetImage(profile.avatarPath),
                                onBackgroundImageError: (e, trace) => const Icon(
                                    Icons.person,
                                    size: 50),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.white, size: 20),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                  ),
                                  builder: (_) => ProfileEditSheet(
                                    currentProfile: profile,
                                  ),
                                );
                              },
                              tooltip: "Modifica Profilo",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.userName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.levelName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: profile.levelColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ExpPill(profile: profile),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Statistiche
                const StatisticsCard(),
                const SizedBox(height: 16),
                
                // Obiettivi
                const AchievementsCard(),
                const SizedBox(height: 16),
                
                // Streak Card
                streakMangasAsync.when(
                  data: (mangas) => SessionStreakCard(streakMangas: mangas),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      const Text('Errore nel caricamento della streak'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Errore caricamento profilo: $err'),
        ),
      ),
    );
  }
}
