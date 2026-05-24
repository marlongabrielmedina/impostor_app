import 'package:flutter/material.dart';
import 'dart:math';

class GameState extends ChangeNotifier {
  // --- Variables Globales (Lo que tenías en JS) ---
  List<String> players = [];
  int impostorIndex = -1;
  int currentPlayerIndex = 0;
  String currentTheme = '';

  // Lista de temas
// --- Temas del Juego ---
  // Quitamos la palabra "final"
  List<String> themes = [
    'Comidas Típicas',
    'Animales de la Selva',
    'Marcas de Carros',
    'Películas de Disney',
    'Superhéroes de Marvel',
  ];

  void addTheme(String newTheme) {
    // Evitamos agregar temas vacíos o repetidos
    if (newTheme.isNotEmpty && !themes.contains(newTheme)) {
      themes.add(newTheme);
      notifyListeners();
    }
  }

  void removeTheme(int index) {
    // Es buena idea dejar al menos 1 tema para que el juego no falle al iniciar
    if (themes.length > 1) {
      themes.removeAt(index);
      notifyListeners();
    }
  }

  // --- Funciones del Juego ---

  void addPlayer(String name) {
    if (name.isNotEmpty && players.length < 10) {
      players.add(name);
      notifyListeners(); // Esto le dice a la UI que se redibuje
    }
  }

  void removePlayer(int index) {
    players.removeAt(index);
    notifyListeners();
  }

  void startRound() {
    final random = Random();
    impostorIndex = random.nextInt(players.length);
    currentTheme = themes[random.nextInt(themes.length)];
    currentPlayerIndex = 0;
    
    // En Flutter, es buena práctica imprimir en consola con 'debugPrint'
    debugPrint('Impostor: ${players[impostorIndex]}');
    debugPrint('Tema: $currentTheme');
    
    notifyListeners();
  }

  void nextTurn() {
    currentPlayerIndex++;
    notifyListeners();
  }

  void resetNewPlayers() {
    players.clear();
    impostorIndex = -1;
    currentPlayerIndex = 0;
    currentTheme = '';
    notifyListeners();
  }
}