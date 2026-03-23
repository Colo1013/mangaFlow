import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/widgets/manga_cover_card.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class MangaSelectionGrid extends StatelessWidget {
  final List<Manga> listaManga;
  final String? selectedMangaId;
  final ValueChanged<String> onMangaSelected;

  const MangaSelectionGrid({
    super.key,
    required this.listaManga,
    required this.onMangaSelected,
    this.selectedMangaId,
  });

  @override
  Widget build(BuildContext context) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    return GridView.builder(
      padding: EdgeInsets.all(appSizes.medium),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: appSizes.medium,
        mainAxisSpacing: appSizes.medium,
        childAspectRatio: 0.7,
      ),
      itemCount: listaManga.length,
      itemBuilder: (context, index) {
        final manga = listaManga[index];
        return MangaCoverCard(
          manga: manga,
          style: MangaCoverStyle.standard,
          isSelected: manga.id == selectedMangaId,
          onTap: () => onMangaSelected(manga.id),
        );
      },
    );
  }
}
