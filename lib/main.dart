import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'setup_screen.dart';

void main() {
  runApp(
    // Envolvemos toda la app en el Provider
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const ImpostorApp(),
    ),
  );
}

class ImpostorApp extends StatelessWidget {
  const ImpostorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Impostor',
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de "DEBUG"
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111827), // Equivalente a bg-gray-900
        primaryColor: Colors.blue,
      ),
      home: const SetupScreen(), 
    );
  }
}

