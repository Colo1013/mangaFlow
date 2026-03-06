import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mangaflow/features/focus_dojo/focusdojo_view.dart';
import 'package:mangaflow/features/library/library_view.dart';
import 'package:mangaflow/features/profile/profile_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);
void main() {
  runApp(const ProviderScope(child: MaterialApp(home: MyWidget())));
}

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> schermate = [LibraryView(), FocusdojoView(), ProfileView()];
    int indiceAttuale = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      appBar: AppBar(title: Text("MangaFlow App")),
      body: schermate[indiceAttuale],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.blueAccent),
            label: "Libreria",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories, color: Colors.amber),
            label: "Concentrazione",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.deepPurple),
            label: "Profilo",
          ),
        ],
        currentIndex: indiceAttuale,
        onTap: (int nuovoIndice) {
          ref.read(bottomNavIndexProvider.notifier).state = nuovoIndice;
        },
      ),
    );
  }
}

class _MyWidgetState extends State<MyWidget> {
  int indiceAttuale = 0;
  List<Widget> schermate = [LibraryView(), FocusdojoView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MangaFlow App")),
      body: schermate[indiceAttuale],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.blueAccent),
            label: "Libreria",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories, color: Colors.amber),
            label: "Concentrazione",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.deepPurple),
            label: "Profilo",
          ),
        ],
        currentIndex: indiceAttuale,
        onTap: (int nuovoIndice) {
          setState(() {
            indiceAttuale = nuovoIndice;
          });
        },
      ),
    );
  }
}
