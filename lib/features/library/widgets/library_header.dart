import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/widgets/manga_cover_card.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class LibraryHeader extends StatelessWidget {
  final List<Manga> listaManga;
  const LibraryHeader({super.key, required this.listaManga});

  @override
  Widget build(BuildContext context) {
    if (listaManga.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

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
                  itemCount: listaManga.length,
                  itemBuilder: (context, index) {
                    final manga = listaManga[index];
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
