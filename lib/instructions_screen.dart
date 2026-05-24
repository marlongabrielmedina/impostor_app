import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'turn_screen.dart';

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Aquí nos conectamos al estado, pero con "listen: false".
    // Como esta pantalla no necesita redibujarse si los datos cambian,
    // solo queremos el acceso para poder llamar a la función startRound().
    final gameState = Provider.of<GameState>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centramos verticalmente
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Instrucciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber, // Equivalente a text-yellow-400
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
                child: const Column(
                  children: [
                    Text(
                      '¡Hay un IMPOSTOR entre ustedes!',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Se asignará un impostor al azar. Todos los demás recibirán un tema secreto.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Por turnos, cada uno dirá una palabra relacionada con el tema. El impostor no conoce el tema y debe intentar camuflarse.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    Text(
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
                // 1. Ejecutamos la lógica para elegir tema e impostor
                gameState.startRound();
                
                // 2. Navegamos a la pantalla de turnos usando pushReplacement
                // Usamos pushReplacement en lugar de push para que no puedan 
                // regresar a las instrucciones deslizando hacia atrás.
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