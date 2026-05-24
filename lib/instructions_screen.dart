import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'turn_screen.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Al quitar el "listen: false", la pantalla puede leer los cambios de estado
    // como la modalidad de dibujo que configuramos en la pantalla anterior.
    final gameState = Provider.of<GameState>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Instrucciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, 
                ),
              ),
              const SizedBox(height: 32),
              
              // Tarjeta con las reglas del juego
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '¡Hay un IMPOSTOR entre ustedes!',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Se asignará un impostor al azar. Todos los demás recibirán un tema secreto.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    
                    // --- AQUÍ ESTÁ LA MAGIA CONDICIONAL ---
                    Text(
                      gameState.isDrawingMode 
                          ? 'Por turnos, cada uno hará un trazo o línea en un papel relacionado con el tema. El impostor no lo conoce e intentará camuflarse en el dibujo.'
                          : 'Por turnos, cada uno dirá una palabra relacionada con el tema. El impostor no conoce el tema y debe intentar camuflarse.',
                      style: const TextStyle(color: Colors.amberAccent, fontSize: 16, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    // --------------------------------------

                    const SizedBox(height: 12),
                    const Text(
                      'Después de la ronda, discutan y voten para encontrar al impostor.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Botón para iniciar la ronda
              ElevatedButton(
                onPressed: () {
                  gameState.startRound();
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const TurnScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '¡Entendido!',
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