import 'package:flutter/material.dart';
import 'dart:math';

// Estructura para el tema
class GameTheme {
  final String name;
  final bool isForDrawing;

  GameTheme({required this.name, required this.isForDrawing});
}

class GameState extends ChangeNotifier {
  List<String> players = [];
  int impostorIndex = -1;
  int currentPlayerIndex = 0;
  String currentTheme = '';
  
  bool isDrawingMode = false; 

  List<GameTheme> themes = [
    GameTheme(name: 'Animales de la Selva', isForDrawing: true),
    GameTheme(name: 'Objetos de la Casa', isForDrawing: true),
    GameTheme(name: 'Frutas y Verduras', isForDrawing: true),
    GameTheme(name: 'Marcas de Carros', isForDrawing: false),
    GameTheme(name: 'Películas de Disney', isForDrawing: false),
    GameTheme(name: 'Canciones de Ricky Martin', isForDrawing: false),
  ];

  // --- Funciones de Modalidad y Temas ---
  void toggleDrawingMode(bool value) {
    isDrawingMode = value;
    notifyListeners();
  }

  void addTheme(String name, bool isForDrawing) {
    bool exists = themes.any((t) => t.name.toLowerCase() == name.toLowerCase());
    if (name.isNotEmpty && !exists) {
      themes.add(GameTheme(name: name, isForDrawing: isForDrawing));
      notifyListeners();
    }
  }

  void removeTheme(int index) {
    if (themes.length > 1) {
      themes.removeAt(index);
      notifyListeners();
    }
  }

  // --- Funciones de Jugadores (¡Las que faltaban!) ---
  void addPlayer(String name) {
    if (name.isNotEmpty && players.length < 10) {
      players.add(name);
      notifyListeners(); 
    }
  }

  void removePlayer(int index) {
    players.removeAt(index);
    notifyListeners();
  }

  // --- Funciones del Flujo del Juego ---
  void startRound() {
    final random = Random();
    impostorIndex = random.nextInt(players.length);
    
    final List<GameTheme> availableThemes = isDrawingMode
        ? themes.where((t) => t.isForDrawing).toList()
        : themes;

    if (availableThemes.isEmpty) {
      currentTheme = 'Tema por defecto (Agrega temas de dibujo)';
    } else {
      currentTheme = availableThemes[random.nextInt(availableThemes.length)].name;
    }

    currentPlayerIndex = 0;
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