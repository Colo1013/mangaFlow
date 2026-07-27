import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/profile/providers/achievements_provider.dart';

class AchievementsCard extends ConsumerWidget {
  const AchievementsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_events,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  "Obiettivi",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            achievementsAsync.when(
              data: (achievements) {
                return Column(
                  children: achievements.map((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: _AchievementTile(achievement: achievement),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => const Center(
                child: Text('Errore nel caricamento obiettivi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement achievement;

  const _AchievementTile({required this.achievement});

  IconData _getIconForId(String id) {
    switch (id) {
      case 'primo_passo':
        return Icons.directions_walk;
      case 'collezionista':
        return Icons.collections_bookmark;
      case 'apprendista':
        return Icons.school;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUnlocked
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getIconForId(achievement.id),
            color: isUnlocked
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant.withOpacity(0.5),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isUnlocked
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withOpacity(0.5),
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isUnlocked
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
              ),
            ],
          ),
        ),
        if (isUnlocked)
          Icon(
            Icons.check_circle,
            color: colorScheme.primary,
          )
        else
          Icon(
            Icons.lock,
            color: colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
      ],
    );
  }
}
