import 'package:flutter/material.dart';
import 'package:mangaflow/features/library/widgets/library_header.dart';
import 'package:mangaflow/features/library/widgets/manga_grid.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(slivers: [LibraryHeader(), MangaGrid()]);
  }
}
