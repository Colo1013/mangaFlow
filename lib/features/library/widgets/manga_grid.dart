import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/features/library/widgets/manga_cover_card.dart';
import 'package:mangaflow/theme/app_sizes.dart';

class MangaGrid extends ConsumerWidget {
  const MangaGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    final mangaList = ref.watch(mangaListProvider);

    // Aggiungiamo un bottom padding dinamico per evitare che la Navbar copra gli ultimi elementi
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 90.0;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        appSizes.medium,
        appSizes.medium,
        appSizes.medium,
        appSizes.medium + bottomPadding,
      ),
      sliver: SliverGrid(
        // Utilizziamo SliverGridDelegateWithMaxCrossAxisExtent per consentire
        // un layout fluido e responsivo che si calcola in base alla viewport
        // (su Desktop e Tablet vedremo più elementi).
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          crossAxisSpacing: appSizes.medium,
          mainAxisSpacing: appSizes.medium,
          childAspectRatio: 0.7,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final manga = mangaList[index];
          return MangaCoverCard(manga: manga, style: MangaCoverStyle.standard);
        }, childCount: mangaList.length),
      ),
    );
  }
}
