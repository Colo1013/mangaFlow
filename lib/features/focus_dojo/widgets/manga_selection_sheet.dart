import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/features/focus_dojo/widgets/manga_selection_grid.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class MangaSelectionSheet extends ConsumerStatefulWidget {
  final ValueChanged<String> onConfirm;

  const MangaSelectionSheet({super.key, required this.onConfirm});

  @override
  ConsumerState<MangaSelectionSheet> createState() =>
      _MangaSelectionSheetState();
}

class _MangaSelectionSheetState extends ConsumerState<MangaSelectionSheet> {
  String? _selectedMangaId;

  @override
  Widget build(BuildContext context) {
    final mangaListAsync = ref.watch(mangaListProvider);
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Padding(
            padding: EdgeInsets.only(top: appSizes.medium),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.4,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Titolo + tasto indietro
          Padding(
            padding: EdgeInsets.all(appSizes.medium),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  "Scegli la tua arma?",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          // Griglia manga
          Expanded(
            child: mangaListAsync.when(
              data: (mangas) => MangaSelectionGrid(
                listaManga: mangas,
                selectedMangaId: _selectedMangaId,
                onMangaSelected: (id) => setState(() => _selectedMangaId = id),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
          ),
          // Tasto conferma
          Padding(
            padding: EdgeInsets.all(appSizes.big),
            child: FilledButton(
              onPressed: _selectedMangaId == null
                  ? null // disabilitato se nessun manga selezionato
                  : () {
                      Navigator.pop(context);
                      widget.onConfirm(_selectedMangaId!);
                    },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text("Inizia sessione"),
            ),
          ),
        ],
      ),
    );
  }
}
