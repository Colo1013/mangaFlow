import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/widgets/manga_cover_card.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class MangaGrid extends StatelessWidget {
  final List<Manga> listaManga;
  const MangaGrid({super.key, required this.listaManga});

  @override
  Widget build(BuildContext context) {
    if (listaManga.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              "Nessun manga trovato nella libreria.",
              style: TextStyle(color: Theme.of(context).disabledColor),
            ),
          ),
        ),
      );
    }

    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 90.0;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        appSizes.medium,
        appSizes.medium,
        appSizes.medium,
        appSizes.medium + bottomPadding,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          crossAxisSpacing: appSizes.medium,
          mainAxisSpacing: appSizes.medium,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final manga = listaManga[index];
          return MangaCoverCard(manga: manga, style: MangaCoverStyle.standard);
        }, childCount: listaManga.length),
      ),
    );
  }
}
