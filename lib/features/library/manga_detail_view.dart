import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:mangaflow/core/widgets/apple_button.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import '../../data/models/manga.dart';

class MangaDetailView extends ConsumerWidget {
  final String mangaId;

  const MangaDetailView({super.key, required this.mangaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMangaList = ref.watch(mangaListProvider);

    return asyncMangaList.when(
      data: (mangas) {
        final manga = mangas.firstWhere(
          (m) => m.id == mangaId,
          orElse: () => throw Exception('Manga non trovato'),
        );
        return _MangaDetailSheet(manga: manga);
      },
      loading: () => const _SheetContainer(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _SheetContainer(
        child: Center(child: Text('Errore di caricamento: $error')),
      ),
    );
  }
}

/// Container base per il bottom sheet con bordi arrotondati e altezza ~90%.
class _SheetContainer extends StatelessWidget {
  final Widget child;

  const _SheetContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: child,
      ),
    );
  }
}

/// Layout principale del dettaglio manga, estrae i colori dalla copertina.
class _MangaDetailSheet extends ConsumerStatefulWidget {
  final Manga manga;

  const _MangaDetailSheet({required this.manga});

  @override
  ConsumerState<_MangaDetailSheet> createState() => _MangaDetailSheetState();
}

class _MangaDetailSheetState extends ConsumerState<_MangaDetailSheet> {
  PaletteGenerator? _palette;

  @override
  void initState() {
    super.initState();
    _extractColors();
  }

  Future<void> _extractColors() async {
    try {
      final palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.manga.coverUrl),
        maximumColorCount: 16,
      );
      if (mounted) {
        setState(() => _palette = palette);
      }
    } catch (_) {
      // Fallback ai colori del tema se l'estrazione fallisce
    }
  }

  /// Colore dominante estratto dalla copertina, con fallback al primary del tema.
  Color get _dominantColor =>
      _palette?.dominantColor?.color ?? Theme.of(context).colorScheme.primary;

  /// Colore vibrante per accenti (pulsanti, icone), con fallback.
  Color get _vibrantColor =>
      _palette?.vibrantColor?.color ??
      _palette?.dominantColor?.color ??
      Theme.of(context).colorScheme.primary;

  /// Colore muted per sfondi secondari, con fallback.
  Color get _mutedColor =>
      _palette?.mutedColor?.color ??
      _palette?.dominantColor?.color ??
      Theme.of(context).colorScheme.surfaceContainerHighest;

  /// Colore del testo leggibile sul colore dominante.
  Color get _onDominantColor =>
      _palette?.dominantColor?.titleTextColor ??
      Theme.of(context).colorScheme.onPrimary;

  /// Mostra il dialog di conferma per la rimozione del manga.
  void _showRemoveDialog(BuildContext context, Manga manga) {
    showCupertinoDialog(
      context: context,
      builder: (_) => _RemoveConfirmationDialog(
        mangaTitle: manga.title,
        onConfirm: () {
          ref.read(mangaListProvider.notifier).eliminaManga(manga);
          Navigator.pop(context); // Chiude il dialog
          Navigator.pop(context); // Chiude il bottom sheet
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manga = widget.manga;
    final theme = Theme.of(context);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _dominantColor.withValues(alpha: 0.15),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle / pill per indicare la trascinabilità
            _DragHandle(color: _dominantColor),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: [
                    // Riga: pulsante back + titolo + favorito
                    _TopBar(manga: manga, accentColor: _vibrantColor),
                    const SizedBox(height: 16),
                    _CoverImage(
                      coverUrl: manga.coverUrl,
                      shadowColor: _dominantColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      manga.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    _ReadingProgress(
                      currentVolume: manga.currentVolume,
                      totalVolume: manga.totalVolume,
                      backgroundColor: _mutedColor.withValues(alpha: 0.35),
                      iconColor: _vibrantColor,
                    ),
                    const SizedBox(height: 24),

                    // 1. Campo editabile capitoli totali
                    _EditableTotalChapters(
                      manga: manga,
                      accentColor: _vibrantColor,
                      onDominantColor: _onDominantColor,
                      backgroundColor: _mutedColor.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 12),

                    // 2. Bottone "Aggiungi Capitolo"
                    AppleButton(
                      icon: Icons.add_rounded,
                      label: "Aggiungi Capitolo",
                      backgroundColor: _vibrantColor,
                      foregroundColor: _onDominantColor,
                      onPressed: () {
                        ref
                            .read(mangaListProvider.notifier)
                            .incrementaCapitolo(manga.id);
                      },
                    ),
                    const SizedBox(height: 12),

                    // 3. Bottone "Rimuovi Manga"
                    AppleButton(
                      icon: Icons.delete_outline_rounded,
                      label: "Rimuovi Manga",
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.85),
                      foregroundColor: Colors.white,
                      onPressed: () => _showRemoveDialog(context, manga),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Handle pill in cima al bottom sheet.
class _DragHandle extends StatelessWidget {
  final Color color;

  const _DragHandle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}

/// Barra superiore: pulsante chiudi + favorito.
class _TopBar extends ConsumerWidget {
  final Manga manga;
  final Color accentColor;

  const _TopBar({required this.manga, required this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: accentColor.withValues(alpha: 0.1),
          ),
        ),
        Text(
          "Dettagli",
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        IconButton(
          icon: Icon(
            manga.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: manga.isFavorite ? Colors.redAccent : null,
          ),
          onPressed: () {
            ref.read(mangaListProvider.notifier).aggiungiPreferiti(manga.id);
          },
          style: IconButton.styleFrom(
            backgroundColor: accentColor.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}

/// Immagine di copertina con ombra colorata.
class _CoverImage extends StatelessWidget {
  final String coverUrl;
  final Color shadowColor;

  const _CoverImage({required this.coverUrl, required this.shadowColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: coverUrl,
          width: 220,
          height: 330,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 220,
            height: 330,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          errorWidget: (context, url, error) => Container(
            width: 220,
            height: 330,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Center(
              child: Icon(
                Icons.broken_image_rounded,
                color: Colors.grey,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Indicatore di progresso di lettura con colori dinamici.
class _ReadingProgress extends StatelessWidget {
  final int currentVolume;
  final int totalVolume;
  final Color backgroundColor;
  final Color iconColor;

  const _ReadingProgress({
    required this.currentVolume,
    required this.totalVolume,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_rounded, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            "Letti: $currentVolume / $totalVolume",
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

/// Campo cliccabile per modificare il numero totale di capitoli.
/// Mostra il valore attuale con un'icona matita; al tap entra in modalità editing.
class _EditableTotalChapters extends ConsumerStatefulWidget {
  final Manga manga;
  final Color accentColor;
  final Color onDominantColor;
  final Color backgroundColor;

  const _EditableTotalChapters({
    required this.manga,
    required this.accentColor,
    required this.onDominantColor,
    required this.backgroundColor,
  });

  @override
  ConsumerState<_EditableTotalChapters> createState() =>
      _EditableTotalChaptersState();
}

class _EditableTotalChaptersState
    extends ConsumerState<_EditableTotalChapters> {
  bool _isEditing = false;
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.manga.totalVolume.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant _EditableTotalChapters oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing &&
        oldWidget.manga.totalVolume != widget.manga.totalVolume) {
      _controller.text = widget.manga.totalVolume.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitValue() {
    final parsed = int.tryParse(_controller.text);
    if (parsed == null || parsed < widget.manga.currentVolume) {
      setState(() {
        _errorText = "Minimo: ${widget.manga.currentVolume}";
      });
      return;
    }

    ref
        .read(mangaListProvider.notifier)
        .aggiornaTotaleVolumi(widget.manga.id, parsed);

    setState(() {
      _isEditing = false;
      _errorText = null;
    });
  }

  void _cancelEditing() {
    setState(() {
      _controller.text = widget.manga.totalVolume.toString();
      _isEditing = false;
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isEditing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book_rounded, size: 20, color: widget.accentColor),
                const SizedBox(width: 8),
                Text(
                  "Capitoli Totali",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      errorText: _errorText,
                    ),
                    onSubmitted: (_) => _submitValue(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.check_rounded, color: widget.accentColor),
                  onPressed: _submitValue,
                  style: IconButton.styleFrom(
                    backgroundColor: widget.accentColor.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  onPressed: _cancelEditing,
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Stato non-editing: mostra valore + icona matita
    return GestureDetector(
      onTap: () => setState(() => _isEditing = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.book_rounded, size: 20, color: widget.accentColor),
            const SizedBox(width: 8),
            Text(
              "Capitoli totali: ${widget.manga.totalVolume}",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.edit_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dialog di conferma in stile Apple per la rimozione di un manga.
class _RemoveConfirmationDialog extends StatelessWidget {
  final String mangaTitle;
  final VoidCallback onConfirm;

  const _RemoveConfirmationDialog({
    required this.mangaTitle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Rimuovi Manga"),
      content: Text(
        "Sei sicuro di voler rimuovere \"$mangaTitle\" dalla tua libreria?",
      ),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text("Annulla"),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: onConfirm,
          child: const Text("Elimina"),
        ),
      ],
    );
  }
}
