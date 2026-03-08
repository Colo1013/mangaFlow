import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/features/library/widgets/manga_cover_card.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class LibraryHeader extends ConsumerWidget {
  const LibraryHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    final favoriteMangas = ref
        .watch(mangaListProvider)
        .where((m) => m.isFavorite)
        .toList();

    if (favoriteMangas.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    // Utilizziamo LayoutBuilder per adattare l'altezza del carosello dinamicamente
    // in base allo spazio disponibile, garantendo proporzioni ottimali su schermi più larghi (Tablet/Desktop).
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double carouselHeight = constraints.maxWidth > 600 ? 300 : 220;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(appSizes.medium),
                child: const Text(
                  "I tuoi preferiti",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              SizedBox(
                height: carouselHeight,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: appSizes.medium),
                  itemCount: favoriteMangas.length,
                  itemBuilder: (context, index) {
                    final manga = favoriteMangas[index];
                    return Padding(
                      padding: EdgeInsets.only(right: appSizes.medium),
                      child: MangaCoverCard(
                        manga: manga,
                        style: MangaCoverStyle.overlayTitle,
                        width: 150,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
