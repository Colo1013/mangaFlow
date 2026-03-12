import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/features/library/widgets/add_manga_sheet.dart';
import 'package:mangaflow/features/library/widgets/library_header.dart';
import 'package:mangaflow/features/library/widgets/manga_grid.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class LibraryView extends ConsumerWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaListAsync = ref.watch(mangaListProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                Theme.of(context).extension<AppSizeExtension>()?.bigradius ??
                    16,
              ),
            ),
          ),
          builder: (_) => const AddMangaSheet(),
        ),
        child: const Icon(Icons.add),
      ),
      body: mangaListAsync.when(
        data: (listaManga) {
          return _LayoutPrincipale(listaManga: listaManga);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text(error.toString())),
      ),
    );
  }
}

class _LayoutPrincipale extends StatelessWidget {
  final List<Manga> listaManga;
  const _LayoutPrincipale({required this.listaManga});

  @override
  Widget build(BuildContext context) {
    final favoriteManga = listaManga
        .where((manga) => manga.isFavorite)
        .toList();
    return CustomScrollView(
      slivers: [
        LibraryHeader(listaManga: favoriteManga),
        MangaGrid(listaManga: listaManga),
      ],
    );
  }
}
