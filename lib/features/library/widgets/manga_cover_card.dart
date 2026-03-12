import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/manga_detail_view.dart';
import 'package:mangaflow/theme/app_sizes.dart';

enum MangaCoverStyle {
  standard, // Per la griglia: solo copertina
  overlayTitle, // Per il carosello preferiti: gradient e titolo sopra l'immagine
  detail, // Per la vista di dettaglio: dimensioni fisse, nessuna interazione al tap
}

class MangaCoverCard extends StatelessWidget {
  final Manga manga;
  final MangaCoverStyle style;

  /// Utilizzato per forzare width/height nel caso di `MangaCoverStyle.detail` o caroselli
  final double? width;
  final double? height;

  const MangaCoverCard({
    super.key,
    required this.manga,
    this.style = MangaCoverStyle.standard,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (style == MangaCoverStyle.detail) {
      return _buildCard(context, isInteractive: false);
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MangaDetailView(mangaId: manga.id),
        );
      },
      child: _buildCard(context, isInteractive: true),
    );
  }

  Widget _buildCard(BuildContext context, {required bool isInteractive}) {
    // Dimensioni di default o personalizzate
    final cardWidth = width;
    final cardHeight = height;

    // L'ombra per il detail è leggermente diversa (più sfumata e distanziata)
    final shadowOffset = style == MangaCoverStyle.detail
        ? const Offset(0, 12)
        : (style == MangaCoverStyle.overlayTitle
              ? const Offset(0, 8)
              : const Offset(0, 6));
    final shadowBlur = style == MangaCoverStyle.detail
        ? 24.0
        : (style == MangaCoverStyle.overlayTitle ? 15.0 : 12.0);
    final shadowSpread = style == MangaCoverStyle.detail ? -4.0 : -2.0;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          style == MangaCoverStyle.detail ? 20 : 16,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: style == MangaCoverStyle.detail
                  ? 0.15
                  : (style == MangaCoverStyle.overlayTitle ? 0.1 : 0.08),
            ),
            blurRadius: shadowBlur,
            offset: shadowOffset,
            spreadRadius: shadowSpread,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          style == MangaCoverStyle.detail ? 20 : 16,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: manga.coverUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
            if (style == MangaCoverStyle.overlayTitle)
              _buildOverlayTitle(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayTitle(BuildContext context) {
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(appSizes.small),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          manga.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
