import 'package:flutter/material.dart';
import '../../data/models/manga.dart';

class MangadetailView extends StatelessWidget {
  final Manga manga;

  const MangadetailView({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(manga.title)),
      body: Center(child: Image.network(manga.coverUrl)),
    );
  }
}
