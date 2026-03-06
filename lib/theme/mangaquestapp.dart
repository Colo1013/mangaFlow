import 'package:flutter/material.dart';
import "app_sizes.dart";

class Mangaquestapp extends StatelessWidget {
  const Mangaquestapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ), // Tema chiaro
        extensions: [
          AppSizeExtension(
            small: 8.0,
            medium: 16.0,
            big: 24.0,
            smallradius: 12.0,
            bigradius: 16.0,
          ),
        ],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        extensions: [
          AppSizeExtension(
            small: 8.0,
            medium: 16.0,
            big: 24.0,
            smallradius: 12.0,
            bigradius: 16.0,
          ),
        ],
      ),
      themeMode: ThemeMode.system,
      home: Mangaquestapp(),
    );
  }
}
