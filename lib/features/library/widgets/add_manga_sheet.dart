import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/data/models/manga.dart';
import 'package:mangaflow/features/library/providers/mangalistnotifier.dart';
import 'package:mangaflow/theme/app_sizes.dart';

/// Bottom sheet modale per aggiungere un nuovo manga alla libreria.
class AddMangaSheet extends ConsumerStatefulWidget {
  const AddMangaSheet({super.key});

  @override
  ConsumerState<AddMangaSheet> createState() => _AddMangaSheetState();
}

class _AddMangaSheetState extends ConsumerState<AddMangaSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titoloController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _totalVolumeController = TextEditingController();

  @override
  void dispose() {
    _titoloController.dispose();
    _coverUrlController.dispose();
    _totalVolumeController.dispose();
    super.dispose();
  }

  Future<void> _salva() async {
    if (!_formKey.currentState!.validate()) return;

    final nuovoManga = Manga(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titoloController.text.trim(),
      coverUrl: _coverUrlController.text.trim(),
      totalVolume: int.parse(_totalVolumeController.text.trim()),
    );

    final aggiunto = await ref
        .read(mangaListProvider.notifier)
        .aggiungiManga(nuovoManga);

    if (!mounted) return;

    if (!aggiunto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Questo manga è già nella tua libreria')),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: appSizes.big,
            vertical: appSizes.medium,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HandleBar(color: colors.onSurfaceVariant),
                SizedBox(height: appSizes.medium),
                Text(
                  'Nuovo Manga',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: appSizes.big),
                _CampoTesto(
                  controller: _titoloController,
                  label: 'Titolo',
                  icon: Icons.menu_book_rounded,
                  validatore: (v) => (v == null || v.trim().isEmpty)
                      ? 'Inserisci un titolo'
                      : null,
                ),
                SizedBox(height: appSizes.medium),
                _CampoTesto(
                  controller: _coverUrlController,
                  label: 'URL Copertina',
                  icon: Icons.image_outlined,
                  inputType: TextInputType.url,
                ),
                SizedBox(height: appSizes.medium),
                _CampoTesto(
                  controller: _totalVolumeController,
                  label: 'Volumi Totali',
                  icon: Icons.numbers_rounded,
                  inputType: TextInputType.number,
                  validatore: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Inserisci il numero di volumi';
                    }
                    if (int.tryParse(v.trim()) == null) {
                      return 'Inserisci un numero valido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: appSizes.big),
                FilledButton.icon(
                  onPressed: _salva,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Aggiungi alla libreria'),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: appSizes.medium),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(appSizes.bigradius),
                    ),
                  ),
                ),
                SizedBox(height: appSizes.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Indicatore a barra in cima al bottom sheet.
class _HandleBar extends StatelessWidget {
  final Color color;
  const _HandleBar({required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

/// Campo di testo riutilizzabile con icona e validazione opzionale.
class _CampoTesto extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType inputType;
  final String? Function(String?)? validatore;

  const _CampoTesto({
    required this.controller,
    required this.label,
    required this.icon,
    this.inputType = TextInputType.text,
    this.validatore,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final appSizes = Theme.of(context).extension<AppSizeExtension>()!;

    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validatore,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(appSizes.smallradius),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
