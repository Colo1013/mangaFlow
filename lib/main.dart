import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mangaflow/features/focus_dojo/focusdojo_view.dart';
import 'package:mangaflow/features/library/library_view.dart';
import 'package:mangaflow/features/profile/profile_view.dart';
import 'package:mangaflow/theme/mangaquestapp.dart';
import 'package:mangaflow/features/library/providers/bottomnavindiexnotifier.dart';
// 1. Creiamo un Notifier per gestire l'indice della BottomNav

void main() {
  runApp(const ProviderScope(child: Mangaquestapp(home: MainAppView())));
}

class MainAppView extends ConsumerWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const List<Widget> screens = [
      LibraryView(),
      FocusdojoView(),
      ProfileView(),
    ];

    final int currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      extendBody: true, // Necessario per il blured background della navbar
      appBar: AppBar(
        title: const Text(
          "MangaFlow",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: _GlassBottomNav(
        currentIndex: currentIndex,
        onTap: (index) =>
            ref.read(bottomNavIndexProvider.notifier).setIndex(index),
      ),
    );
  }
}

class _GlassBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _GlassBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor.withValues(alpha: 0.8),
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
          ),
          child: BottomNavigationBar(
            backgroundColor:
                Colors.transparent, // Sfondo gestito dal Container sopra
            elevation: 0,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded),
                label: "Libreria",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.auto_stories_rounded),
                label: "Dojo",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: "Profilo",
              ),
            ],
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
