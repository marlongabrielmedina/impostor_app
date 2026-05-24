import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'setup_screen.dart';
import 'turn_screen.dart'; // Para volver a jugar con los mismos
// Importa instructions_screen.dart si prefieres que pasen por las reglas de nuevo

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  bool _isRevealed = false; // Controla el estado antes y después de revelar al impostor

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    
    // Obtenemos el nombre del impostor desde el cerebro del juego
    final impostorName = gameState.players[gameState.impostorIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // VISTA 1: Época de debate
              if (!_isRevealed) ...[
                const Icon(Icons.forum, size: 80, color: Colors.blueAccent),
                const SizedBox(height: 24),
                const Text(
                  '¡Hora de debatir!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Todos han dicho su palabra. Discutan y voten para decidir quién creen que es el impostor.',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRevealed = true; // Cambiamos la vista para revelar
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Revelar Impostor', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ] 
              // VISTA 2: La gran revelación
              else ...[
                const Text('El Impostor era...', style: TextStyle(fontSize: 24, color: Colors.grey), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text(
                  impostorName,
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Botón: Mismos Jugadores
                ElevatedButton(
                  onPressed: () {
                    gameState.startRound(); // Reinicia el turno y elige nuevo impostor/tema
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const TurnScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Jugar de nuevo (Mismos)', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                
                // Botón: Nuevos Jugadores
                TextButton(
                  onPressed: () {
                    gameState.resetNewPlayers(); // Borra la lista del cerebro
                    
                    // pushAndRemoveUntil limpia TODA la pila de pantallas (cartas)
                    // y te deja en la pantalla de Setup como si abrieras la app por primera vez.
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const SetupScreen()),
                      (route) => false, 
                    );
                  },
                  child: const Text('Jugar de nuevo (Nuevos jugadores)', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}