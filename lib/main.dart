import 'package:flutter/material.dart';
import 'package:mangaflow/features/focus_dojo/focusdojo_view.dart';
import 'package:mangaflow/features/library/library_view.dart';
import 'package:mangaflow/features/profile/profile_view.dart';

void main() {
  runApp(MaterialApp(home: MyWidget()));
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
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
