import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/models/profile.dart';
import 'package:mangaflow/data/models/profile_repository.dart';
import 'package:mangaflow/features/focus_dojo/providers/profile_notifier.dart';

class ProfileEditSheet extends ConsumerStatefulWidget {
  final Profile currentProfile;

  const ProfileEditSheet({super.key, required this.currentProfile});

  @override
  ConsumerState<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends ConsumerState<ProfileEditSheet> {
  late TextEditingController _nameController;
  late String _selectedAvatarPath;

  // List of theoretical avatar assets to choose from.
  final List<String> _availableAvatars = [
    'assets/images/avatars/default.webp',
    'assets/images/avatars/avatar1.webp',
    'assets/images/avatars/avatar2.webp',
    'assets/images/avatars/avatar3.webp',
    'assets/images/avatars/avatar4.webp',
    'assets/images/avatars/avatar5.webp',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.currentProfile.userName,
    );
    _selectedAvatarPath = widget.currentProfile.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) return;

    final updatedProfile = widget.currentProfile.copyWith(
      userName: newName,
      avatarPath: _selectedAvatarPath,
    );

    // Save to repository
    await ProfileRepository().update(updatedProfile);

    // Refresh profile state
    await ref.read(profileProvider.notifier).refresh();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // using bottom sheet padding + keyboard padding
    final insets = MediaQuery.of(context).viewInsets;

    return Padding(
      padding: EdgeInsets.only(
        bottom: insets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Modifica Profilo",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Nome Utente",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Text("Scegli Avatar", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          // Horizontal scrolling list of avatars
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _availableAvatars.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final avatarPath = _availableAvatars[index];
                final isSelected = avatarPath == _selectedAvatarPath;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarPath = avatarPath;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          avatarPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 50),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Salva", style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
