import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'instructions_screen.dart'; // Importante para que funcione el botón de Comenzar Juego
import 'themes_screen.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  void _addPlayer(GameState gameState) {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      gameState.addPlayer(name);
      _nameController.clear();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemesScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'El Impostor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.blueAccent, 
                ),
              ),
              const SizedBox(height: 8), 
              const Text(
                'Agrega de 3 a 10 jugadores para empezar.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 24),
              
              // Fila para el input y el botón de "+"
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Nombre del jugador',
                        filled: true,
                        fillColor: Colors.grey[800],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addPlayer(gameState),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _addPlayer(gameState),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de jugadores dinámica
              Expanded(
                child: gameState.players.isEmpty
                    ? const Center(
                        child: Text(
                          'Aún no hay jugadores',
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        ),
                      )
                    : ListView.builder(
                        itemCount: gameState.players.length,
                        itemBuilder: (context, index) {
                          final player = gameState.players[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.blue[100], 
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  player,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900], 
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => gameState.removePlayer(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),

              // Selector de Modalidad Dibujo
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[800]?.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Modalidad Dibujo',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Filtra solo objetos abstractos/dibujables para jugar en papel real.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  secondary: Icon(
                    Icons.palette, 
                    color: gameState.isDrawingMode ? Colors.amber : Colors.grey
                  ),
                  value: gameState.isDrawingMode,
                  onChanged: (bool value) {
                    gameState.toggleDrawingMode(value);
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Botón de comenzar
              ElevatedButton(
                onPressed: (gameState.players.length >= 3 && gameState.players.length <= 10)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InstructionsScreen()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600], 
                  disabledBackgroundColor: Colors.grey[700], 
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Comenzar Juego',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}